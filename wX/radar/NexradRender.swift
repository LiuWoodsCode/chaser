// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation
import QuartzCore
import Metal
import simd
import UIKit

final class NexradRender {

    // TODO migrate towards android architecture wrt downloads

    private let device: MTLDevice
    var lastPanLocation: CGPoint!
#if !targetEnvironment(macCatalyst)
    static let zoomToHideMiscFeatures: Float = 0.5
#endif
#if targetEnvironment(macCatalyst)
    static let zoomToHideMiscFeatures: Float = 0.2
#endif
    private var totalBins = 0
    private let timeButton: ToolbarIcon
    private let productButton: ToolbarIcon    
    var wxMetalTextObject: NexradRenderTextObject
    var renderFn: ((Int) -> Void)?
    let fileStorage = FileStorage()
    let state = NexradRenderState()
    var data: NexradRenderData
    let construct: NexradRenderConstruct!

    init(_ device: MTLDevice,
         _ wxMetalTextObject: NexradRenderTextObject,
         _ timeButton: ToolbarIcon,
         _ productButton: ToolbarIcon,
         paneNumber: Int,
         _ numberOfPanes: Int,
         useMapKitBaseLayer: Bool = false
    ) {
        data = NexradRenderData(useMapKitBaseLayer: useMapKitBaseLayer)
        self.wxMetalTextObject = wxMetalTextObject
        self.device = device
        self.timeButton = timeButton
        self.productButton = productButton
        state.paneNumber = paneNumber
        state.indexString = String(paneNumber)
        state.numberOfPanes = numberOfPanes
        data.radarBuffers.fileStorage = fileStorage
        construct = NexradRenderConstruct(device, fileStorage, state)
        state.readPreferences()
        state.regenerateProductList()
        construct.scaleLengthLocationDot = scaleLengthLocationDot
        data.addToLayers()
        if numberOfPanes == 1 || !RadarPreferences.dualpaneshareposn {
            loadGeometry()
        }
    }

    func render(
        commandQueue: MTLCommandQueue,
        pipelineState: MTLRenderPipelineState,
        drawable: CAMetalDrawable,
        parentModelViewMatrix: float4x4,
        projectionMatrix: float4x4
        // clearColor: MTLClearColor?
    ) {
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        let clearAlpha = data.useMapKitBaseLayer ? 0.0 : 1.0
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(
            red: Double(Color.red(data.radarBuffers.bgColor)) / 255.0,
            green: Double(Color.green(data.radarBuffers.bgColor)) / 255.0,
            blue: Double(Color.blue(data.radarBuffers.bgColor)) / 255.0,
            alpha: clearAlpha
        )
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        let commandBuffer = commandQueue.makeCommandBuffer()
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        // For now cull mode is used instead of depth buffer
        renderEncoder!.setCullMode(MTLCullMode.front)
        renderEncoder!.setRenderPipelineState(pipelineState)
        var projectionMatrixRef = projectionMatrix
        data.radarLayers.forEach { vbuffer in
            if vbuffer.vertexCount > 0 {
                if vbuffer.scaleCutOff < state.zoom {
                    if !(vbuffer.honorDisplayHold && state.displayHold) || !vbuffer.honorDisplayHold {
                        renderEncoder!.setVertexBuffer(vbuffer.mtlBuffer, offset: 0, index: 0)
                        var nodeModelMatrix = NexradRenderUtilities.modelMatrix()
                        nodeModelMatrix.multiplyLeft(parentModelViewMatrix)
                        let uniformBuffer = device.makeBuffer(
                            length: MemoryLayout<Float>.size * float4x4.numberOfElements() * 2,
                            options: []
                        )
                        let bufferPointer = uniformBuffer?.contents()
                        memcpy(
                            bufferPointer,
                            &nodeModelMatrix,
                            MemoryLayout<Float>.size * float4x4.numberOfElements()
                        )
                        memcpy(
                            bufferPointer! + MemoryLayout<Float>.size * float4x4.numberOfElements(),
                            &projectionMatrixRef,
                            MemoryLayout<Float>.size * float4x4.numberOfElements()
                        )
                        renderEncoder!.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
                        renderEncoder!.drawPrimitives(type: vbuffer.shape, vertexStart: 0, vertexCount: vbuffer.vertexCount)
                    }
                }
            }
        }
        if RadarPreferences.wpcFronts {
            if state.zoom < NexradRender.zoomToHideMiscFeatures {
                data.wpcFrontBuffersList.forEach { vbuffer in
                    if vbuffer.vertexCount > 0 {
                        if vbuffer.scaleCutOff < state.zoom {
                            if !(vbuffer.honorDisplayHold && state.displayHold) || !vbuffer.honorDisplayHold {
                                renderEncoder!.setVertexBuffer(vbuffer.mtlBuffer, offset: 0, index: 0)
                                var nodeModelMatrix = NexradRenderUtilities.modelMatrix()
                                nodeModelMatrix.multiplyLeft(parentModelViewMatrix)
                                let uniformBuffer = device.makeBuffer(
                                    length: MemoryLayout<Float>.size * float4x4.numberOfElements() * 2,
                                    options: []
                                )
                                let bufferPointer = uniformBuffer?.contents()
                                memcpy(
                                    bufferPointer,
                                    &nodeModelMatrix,
                                    MemoryLayout<Float>.size * float4x4.numberOfElements()
                                )
                                memcpy(
                                    bufferPointer! + MemoryLayout<Float>.size * float4x4.numberOfElements(),
                                    &projectionMatrixRef,
                                    MemoryLayout<Float>.size * float4x4.numberOfElements()
                                )
                                renderEncoder!.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
                                renderEncoder!.drawPrimitives(type: .line, vertexStart: 0, vertexCount: vbuffer.vertexCount)
                            }
                        }
                    }
                }
            }
        }
        renderEncoder!.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }

    func loadGeometry() {
        state.projectionNumbers = ProjectionNumbers(state.radarSite)
        data.geographicBuffers.forEach {
            construct.genericGeographic($0)
            $0.generateMtlBuffer(device)
        }
        if PolygonType.LOCDOT.display || RadarPreferences.locdotFollowsGps {
            construct.locationDot(data.locdotBuffers, data.locCircleBuffers, setZoom)
        }
        setZoom()
    }

    func getRadar(_ url: String, _ additionalText: String = "") {
        _ = FutureVoid({ NexradRenderRadar.downloadRadar(url, self.data, self.state, self.fileStorage) }, { self.updateRadar(additionalText) })
        if url == "" { // not animating
            downloadLayers()
        }
    }

    private func downloadLayers() {
        [data.stiBuffers, data.tvsBuffers, data.hiBuffers].forEach {
            if $0.type.display {
                let item = $0
                _ = FutureVoid({ self.construct.level3TextProduct(item.typeEnum, self.data) }, setZoom)
            }
        }
        if PolygonType.SPOTTER.display || PolygonType.SPOTTER_LABELS.display {
            _ = FutureVoid({ self.construct.spotters(self.data.spotterBuffers) }, {})
        }
        if PolygonType.OBS.display || PolygonType.WIND_BARB.display {
            _ = FutureVoid(downloadObs, renderIt)
        }
        if PolygonType.SWO.display {
            _ = FutureVoid(SwoDayOne.get, { self.construct.swoLines(self.data.swoBuffers, self.state.projectionNumbers) })
        }
        if PolygonType.FIRE.display {
            _ = FutureVoid(FireDayOne.get, { self.construct.fireLines(self.data.fireBuffers, self.state.projectionNumbers) })
        }
        if RadarPreferences.wpcFronts {
            _ = FutureVoid(WpcFronts.get, { self.construct.wpcFronts(&self.data.wpcFrontBuffersList, &self.data.wpcFrontPaints) })
        }
    }

    private func downloadObs() {
        if PolygonType.OBS.display || PolygonType.WIND_BARB.display {
            Metar.getStateMetarArrayForWXOGL(state.radarSite, fileStorage)
        }
        if PolygonType.WIND_BARB.display {
            construct.wBLines(data.wbBuffers, data.wbGustsBuffers, data.wbCircleBuffers)
        }
    }

    private func renderIt() {
        demandRender()
        if !state.isAnimating && PolygonType.OBS.display {
            wxMetalTextObject.removeTextLabels()
            wxMetalTextObject.addTextLabels()
        }
    }

    private func updateRadar(_ additionalText: String) {
        totalBins = NexradRenderRadar.constructPolygons(data, state, fileStorage, device)
        showTimeToolbar(additionalText, state.isAnimating)
        productButton.title = state.product
        demandRender()
        if !state.isAnimating {
            wxMetalTextObject.removeTextLabels()
            wxMetalTextObject.addTextLabels()
        }
    }

    func setRenderFunction(_ fn: @escaping (Int) -> Void) {
        renderFn = fn
    }

    func demandRender() {
        if renderFn != nil {
            renderFn!(state.paneNumber)
        }
    }

    func updateTimeToolbar() {
        showTimeToolbar("", false)
    }

    func showTimeToolbar(_ additionalText: String, _ isAnimating: Bool) {
        let timeTokens = data.radarBuffers.levelData.radarInfo.split(" ")
        if timeTokens.count > 1 {
            var replaceToken = "Mode:"
            if state.product.hasPrefix("L2") {
                replaceToken = "Product:"
            }
            timeButton.title = timeTokens[1].replace(GlobalVariables.newline + replaceToken, "") + additionalText
            var textColor = UIColor.white
            if NexradUtil.isRadarTimeOld(data.radarBuffers.levelData) && !isAnimating {
                textColor = UIColor.red
            }
            timeButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: textColor], for: .normal)
        } else {
            timeButton.title = ""
        }
    }

    func scaleLengthLocationDot(_ currentLength: Double) -> Double {
        (currentLength / Double(state.zoom)) * 2.0
    }

    func setZoom() {
        [data.locdotBuffers, data.wbCircleBuffers, data.spotterBuffers, data.hiBuffers, data.tvsBuffers].forEach {
            $0.lenInit = scaleLengthLocationDot($0.type.size)
            $0.draw(state.projectionNumbers)
            $0.generateMtlBuffer(device)
        }
        if RadarPreferences.locdotFollowsGps {
            data.locCircleBuffers.lenInit = data.locdotBuffers.lenInit
            NexradRenderUtilities.genCircleLocationDot(data.locCircleBuffers, state.projectionNumbers, state.gpsLocation)
            data.locCircleBuffers.generateMtlBuffer(device)
        }
        demandRender()
    }

    func resetRadarSite(_ radarSite: String, isHomeScreen: Bool = false) {
        state.radarSite = radarSite
        state.xPos = 0.0
        state.yPos = 0.0
        let prefFactor = (Float(RadarPreferences.wxoglSize) / 10.0)
        state.zoom = 1.0 / prefFactor
        if UtilityUI.isLandscape() {
            state.zoom = 0.60 / prefFactor
        }
        #if targetEnvironment(macCatalyst)
        state.zoom = 0.40 / prefFactor
        if isHomeScreen {
            state.zoom = 0.70 / prefFactor
        }
        #endif
        loadGeometry()
    }

    func resetRadarSiteAndGetData(_ radarSite: String, isHomeScreen: Bool = false) {
        resetRadarSite(radarSite, isHomeScreen: isHomeScreen)
        getRadar("")
    }

    func changeProduct(_ product: String) {
        state.product = product
        getRadar("")
        productButton.title = product
    }
}
