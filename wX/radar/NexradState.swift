// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Metal
import UIKit
import simd

final class NexradState {

    var wxMetalRenders = [NexradRender?]()
    var wxMetalTextObject = NexradRenderTextObject()
    var device: MTLDevice! = MTLCreateSystemDefaultDevice()
    var metalLayer = [CAMetalLayer?]()
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var paneRange: Range<Int> = 0..<1
    var numberOfPanes = 1
    let ortInt: Float = 250.0
    private var screenWidth = 0.0
    private var screenHeight = 0.0
    private var screenScale = 0.0
    var projectionMatrix: float4x4!

    func setupMetalLayer() {
        paneRange.indices.forEach { index in
            metalLayer.append(CAMetalLayer())
            metalLayer[index]!.device = device
            metalLayer[index]!.pixelFormat = .bgra8Unorm
            metalLayer[index]!.framebufferOnly = true
        }
        let defaultLibrary = device.makeDefaultLibrary()!
        let fragmentProgram = defaultLibrary.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary.makeFunction(name: "basic_vertex")
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        } catch {
            print("error init pipelineState")
        }
        commandQueue = device.makeCommandQueue()
    }

    func setupRenders(_ view: UIView, _ radarSiteOverride: String, _ nexradSubmenu: NexradSubmenu) {
        metalLayer.forEach { mlayer in
            view.layer.addSublayer(mlayer!)
        }
        paneRange.forEach { index in
            wxMetalRenders.append(
                NexradRender(
                    device,
                    wxMetalTextObject,
                    nexradSubmenu.timeButton,
                    nexradSubmenu.productButton[index],
                    paneNumber: index,
                    numberOfPanes))
        }
        nexradSubmenu.productButton.enumerated().forEach {
            $1.title = wxMetalRenders[$0]!.state.product
        }
        // when called from severedashboard and us alerts
        if radarSiteOverride != "" {
            wxMetalRenders[0]!.resetRadarSite(radarSiteOverride)
        }
        nexradSubmenu.radarSiteButton.title = wxMetalRenders[0]!.state.radarSite
        if numberOfPanes > 1 {
            nexradSubmenu.siteButton.enumerated().forEach {
                $1.title = wxMetalRenders[$0]!.state.radarSite
            }
        }
        if RadarPreferences.dualpaneshareposn && numberOfPanes > 1 {
            let x = wxMetalRenders[0]!.state.xPos
            let y = wxMetalRenders[0]!.state.yPos
            let zoom = wxMetalRenders[0]!.state.zoom
            let rid = wxMetalRenders[0]!.state.radarSite
            wxMetalRenders.forEach {
                $0!.state.xPos = x
                $0!.state.yPos = y
                $0!.state.zoom = zoom
                $0!.state.radarSite = rid
                $0!.loadGeometry()
            }
        }
    }

    func setPaneSize(_ cgsize: CGSize) {
        let width = cgsize.width
        let height = cgsize.height
        screenWidth = Double(width)
        screenHeight = Double(height)
        let screenWidth = width
        var screenHeight = height + CGFloat(UIPreferences.toolbarHeight)
        #if targetEnvironment(macCatalyst)
        screenHeight = height
        #endif
        var surfaceRatio = Float(screenWidth) / Float(screenHeight)
        if numberOfPanes == 2 {
            surfaceRatio = Float(screenWidth) / Float(screenHeight / 2.0)
        }
        if numberOfPanes == 4 {
            surfaceRatio = Float(screenWidth / 2.0) / Float(screenHeight / 2.0)
        }
        let bottom = -1.0 * ortInt * (1.0 / surfaceRatio)
        let top = ortInt * (1 / surfaceRatio)
        projectionMatrix = float4x4.makeOrtho(-1.0 * ortInt, right: ortInt, bottom: bottom, top: top, nearZ: -100.0, farZ: 100.0)
        let halfWidth: CGFloat = screenWidth / 2
        let halfHeight: CGFloat = screenHeight / 2
        if numberOfPanes == 1 {
            metalLayer[0]!.frame = CGRect(x: 0, y: 0, width: width, height: height)
        } else if numberOfPanes == 2 {
            if UtilityUI.isLandscape() || screenWidth > screenHeight {
                surfaceRatio = Float(screenWidth / 2.0) / Float(screenHeight)
                let scaleFactor: Float = 0.5
                projectionMatrix = float4x4.makeOrtho(
                    -1.0 * ortInt * scaleFactor,
                    right: ortInt * scaleFactor,
                    bottom: -1.0 * ortInt * (1.0 / surfaceRatio) * scaleFactor,
                    top: ortInt * (1.0 / surfaceRatio) * scaleFactor,
                    nearZ: -100.0,
                    farZ: 100.0
                )
                // left half for dual
                metalLayer[0]!.frame = CGRect(x: 0, y: 0, width: screenWidth / 2.0, height: height)
                // right half for dual
                metalLayer[1]!.frame = CGRect(x: halfWidth, y: 0, width: screenWidth / 2.0, height: height)
            } else {
                metalLayer[0]!.frame = CGRect(x: 0, y: 0, width: screenWidth, height: halfHeight)
                // bottom half for dual
                metalLayer[1]!.frame = CGRect(x: 0, y: halfHeight, width: screenWidth, height: halfHeight)
            }
        } else if numberOfPanes == 4 {
            // top half for quad
            metalLayer[0]!.frame = CGRect(x: 0, y: 0, width: halfWidth, height: halfHeight)
            metalLayer[1]!.frame = CGRect(x: CGFloat(halfWidth), y: 0, width: halfWidth, height: halfHeight)
            // bottom half for quad
            metalLayer[2]!.frame = CGRect(x: 0, y: halfHeight, width: halfWidth, height: halfHeight)
            metalLayer[3]!.frame = CGRect(x: halfWidth, y: halfHeight, width: halfWidth, height: halfHeight)
        }
    }

    func setupTextObject(_ uiv: UIViewController) {
        screenScale = Double(UIScreen.main.scale)
        #if targetEnvironment(macCatalyst)
        screenScale *= 2.0
        #endif
        wxMetalTextObject = NexradRenderTextObject(
            uiv,
            screenWidth,
            screenHeight,
            wxMetalRenders[0]!,
            screenScale
        )
        wxMetalTextObject.initializeTextLabels()
        wxMetalTextObject.addTextLabels()
        wxMetalRenders.forEach {
            $0?.wxMetalTextObject = wxMetalTextObject
        }
    }

    func resetTextObject(_ uiv: UIViewController) {
        uiv.view.subviews.forEach {
            if $0 is UITextView {
                $0.removeFromSuperview()
            }
        }
        wxMetalTextObject = NexradRenderTextObject(
            uiv,
            Double(uiv.view.frame.width),
            Double(uiv.view.frame.height),
            wxMetalRenders[0]!,
            screenScale
        )
        wxMetalTextObject.initializeTextLabels()
        wxMetalTextObject.addTextLabels()
    }

    func modelMatrix(_ index: Int) -> float4x4 {
        var matrix = float4x4()
        if !RadarPreferences.wxoglCenterOnLocation {
            matrix.translate(wxMetalRenders[index]!.state.xPos, y: wxMetalRenders[index]!.state.yPos, z: wxMetalRenders[index]!.state.zPos)
        } else {
            wxMetalRenders[index]!.state.xPos = wxMetalRenders[index]!.state.gpsLatLonTransformed.0 * wxMetalRenders[index]!.state.zoom
            wxMetalRenders[index]!.state.yPos = wxMetalRenders[index]!.state.gpsLatLonTransformed.1 * wxMetalRenders[index]!.state.zoom
            matrix.translate(wxMetalRenders[index]!.state.xPos, y: wxMetalRenders[index]!.state.yPos, z: wxMetalRenders[index]!.state.zPos)
        }
        matrix.rotateAroundX(0, y: 0, z: 0)
        matrix.scale(wxMetalRenders[index]!.state.zoom, y: wxMetalRenders[index]!.state.zoom, z: wxMetalRenders[index]!.state.zoom)
        return matrix
    }
}
