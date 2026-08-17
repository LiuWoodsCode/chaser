// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Metal
import UIKit
import simd

final class NexradStateHS {

    var wxMetal = [NexradRender?]()
    var wxMetalTextObject = NexradRenderTextObject()
    let device = MTLCreateSystemDefaultDevice()
    var metalLayer = [CAMetalLayer?]()
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    let numberOfPanes = 1
    let ortInt: Float = 350.0
    var projectionMatrix: float4x4!

    func setupMetal() {
        let defaultLibrary = device?.makeDefaultLibrary()!
        let fragmentProgram = defaultLibrary?.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary?.makeFunction(name: "basic_vertex")
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        do {
            pipelineState = try device?.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        } catch {
            print("error init pipelineState")
        }
        commandQueue = device?.makeCommandQueue()
    }

    func setupMetalLayer(_ stackView: UIStackView) {
        let paneRange = [0]
        let (width, _) = UtilityUI.getScreenBoundsCGFloat()
        let screenWidth = width
        let screenHeight = screenWidth
        let carect = CGRect(x: 0, y: 0, width: CGFloat(screenWidth), height: CGFloat(screenWidth))
        let caview = UIView(frame: carect)
        caview.widthAnchor.constraint(equalToConstant: CGFloat(screenWidth)).isActive = true
        caview.heightAnchor.constraint(equalToConstant: CGFloat(screenWidth)).isActive = true
        let surfaceRatio = Float(screenWidth) / Float(screenHeight)
        projectionMatrix = float4x4.makeOrtho(
            -1.0 * ortInt,
             right: ortInt,
             bottom: -1.0 * ortInt * (1.0 / surfaceRatio),
             top: ortInt * (1.0 / surfaceRatio),
            nearZ: -100.0,
            farZ: 100.0
        )
        paneRange.indices.forEach { index in
            if metalLayer.count < 1 {
                metalLayer.append(CAMetalLayer())
                metalLayer[index]!.device = device
                metalLayer[index]!.pixelFormat = .bgra8Unorm
                metalLayer[index]!.framebufferOnly = true
            }
        }
        metalLayer[0]!.frame = CGRect(x: 0, y: 0, width: CGFloat(screenWidth), height: CGFloat(screenWidth))
        metalLayer.forEach { caview.layer.addSublayer($0!) }
        stackView.addArrangedSubview(caview)
        if wxMetal.count < 1 {
            wxMetal.append(NexradRender(device!, wxMetalTextObject, ToolbarIcon(), ToolbarIcon(), paneNumber: 0, numberOfPanes))
        }
    }

    func getRadar(_ render: @escaping (Int) -> Void) {
        wxMetal[0]!.state.gpsLocation = Location.latLon.reverse()
        wxMetal[0]!.construct.locationDot(wxMetal[0]!.data.locdotBuffers, wxMetal[0]!.data.locCircleBuffers, wxMetal[0]!.setZoom)
        wxMetal[0]!.setRenderFunction(render)
        wxMetal[0]!.resetRadarSiteAndGetData(Location.radarSite, isHomeScreen: true)
    }

    func modelMatrix(_ index: Int) -> float4x4 {
        var matrix = float4x4()
        matrix.translate(wxMetal[index]!.state.xPos, y: wxMetal[index]!.state.yPos, z: wxMetal[index]!.state.zPos)
        matrix.rotateAroundX(0, y: 0, z: 0)
        matrix.scale(wxMetal[index]!.state.zoom, y: wxMetal[index]!.state.zoom, z: wxMetal[index]!.state.zoom)
        return matrix
    }
}
