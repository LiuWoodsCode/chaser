// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit
import Metal
import CoreLocation
import MapKit
import simd

final class VcNexradRadar: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {

    private var lastFrameTimestamp: CFTimeInterval = 0.0
    //
    // arguments for class (set in Route.swift)
    //
    // set to the number of Panes as a String
    var numberOfPanes = 1
    var calledFromTimeButton = false
    var radarSiteOverride = ""
    // override in severe dash and us-alerts as preferences should not be saved
    var savePreferences = true
    //
    private var nexradState = NexradState()
    private var nexradUI = NexradUI()
    private var nexradAnimation: NexradAnimation!
    private var nexradSubmenu: NexradSubmenu!
    private var nexradColorLegend = NexradColorLegend()
    private var nexradLayerDownload: NexradLayerDownload!
    private var nexradLongPress: NexradLongPressMenu!

    override func viewDidLoad() {
        super.viewDidLoad()
        let toolbarTop = Toolbar()
        nexradUI.setupUIInitial(self, nexradState, numberOfPanes)
        nexradSubmenu = NexradSubmenu(nexradState)
        nexradSubmenu.setupToolbar(self,
                                   toolbarTop,
                                   #selector(radarSiteClicked(sender:)),
                                   #selector(timeClicked),
                                   #selector(warningClicked))
        nexradLayerDownload = NexradLayerDownload(nexradState, nexradSubmenu)
        nexradUI.setupObservers(self, #selector(invalidateGps), #selector(onPause), #selector(onResume))
        nexradSubmenu.setupButtons(self,
                                   #selector(doneClicked),
                                   #selector(productClicked),
                                   #selector(radarSiteClicked),
                                   #selector(animateClicked))
        nexradState.setupMetalLayer()
        nexradState.setPaneSize(UtilityUI.getScreenBoundsCGSize())
        nexradState.setupRenders(view, radarSiteOverride, nexradSubmenu)
        nexradAnimation = NexradAnimation(nexradUI, nexradState.wxMetalRenders, nexradSubmenu, nexradLayerDownload)
        nexradLongPress = NexradLongPressMenu(self, nexradState, nexradSubmenu, showTiltMenu, radarSiteChanged)
        nexradUI.setupMetal(self, nexradState, render, #selector(newFrame(displayLink:)))
        setupGestures()
        nexradUI.setupGps(self)
        nexradState.setupTextObject(self)
        nexradState.wxMetalRenders.forEach {
            $0?.getRadar("")
        }
        nexradLayerDownload.getPolygonWarnings()
        nexradColorLegend.updateColorLegend(view, nexradState)
        nexradUI.setupAutoRefresh(self, #selector(getRadarEveryMinute))
        view.bringSubviewToFront(nexradSubmenu.toolbar)
        view.bringSubviewToFront(toolbarTop)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        nexradState.setPaneSize(size)
        nexradState.paneRange.indices.forEach {
            render($0)
        }
        coordinator.animate(alongsideTransition: nil) { _ in
            self.nexradUI.map.setupLocations(RadarSites.nexradRadars() + RadarSites.tdwrRadars())
            self.nexradState.resetTextObject(self)
        }
    }

    @objc func onPause() {
        nexradAnimation.stop()
    }

    func render(_ index: Int) {
        guard let drawable = nexradState.metalLayer[index]!.nextDrawable() else { return }
        nexradState.wxMetalRenders[index]?.render(
            commandQueue: nexradState.commandQueue,
            pipelineState: nexradState.pipelineState,
            drawable: drawable,
            parentModelViewMatrix: nexradState.modelMatrix(index),
            projectionMatrix: nexradState.projectionMatrix
            // clearColor: MTLClearColorMake(0.0, 0.0, 0.0, 1.0)
            // clearColor: nil
        )
    }

    // needed for continuous
    @objc func newFrame(displayLink: CADisplayLink) {
         if lastFrameTimestamp == 0.0 {
            lastFrameTimestamp = displayLink.timestamp
         }
         let elapsed: CFTimeInterval = displayLink.timestamp - lastFrameTimestamp
         lastFrameTimestamp = displayLink.timestamp
         radarLoop(timeSinceLastUpdate: elapsed)
     }

    // needed for continuous
    func radarLoop(timeSinceLastUpdate: CFTimeInterval) {
         autoreleasepool {
             for (index, wxMetal) in nexradState.wxMetalRenders.enumerated() {
                if wxMetal != nil {
                    render(index)
                }
            }
         }
     }

    func setupGestures() {
        let gestureRecognizerSingleTap = GestureData(self, #selector(tapGesture))
        gestureRecognizerSingleTap.numberOfTapsRequired = 1
        gestureRecognizerSingleTap.delegate = self
        let gestureRecognizerDoubleTap = GestureData(self, #selector(tapGestureDouble))
        gestureRecognizerDoubleTap.numberOfTapsRequired = 2
        gestureRecognizerDoubleTap.delegate = self
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gesturePan)))
        view.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(gestureZoom)))
        view.addGestureRecognizer(gestureRecognizerSingleTap)
        view.addGestureRecognizer(gestureRecognizerDoubleTap)
        gestureRecognizerSingleTap.require(toFail: gestureRecognizerDoubleTap)
        gestureRecognizerSingleTap.delaysTouchesBegan = true
        gestureRecognizerDoubleTap.delaysTouchesBegan = true
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(gestureLongPress)))
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        touch.view == gestureRecognizer.view
    }

    @objc func tapGesture(_ gestureRecognizer: GestureData) {
        if !nexradUI.map.isShown {
            NexradRenderSurfaceView.singleTap(self, nexradState.wxMetalRenders, nexradState.wxMetalTextObject, gestureRecognizer)
        }
    }

    @objc func tapGestureDouble(_ gestureRecognizer: GestureData) {
        NexradRenderSurfaceView.doubleTap(self, nexradState.wxMetalRenders, nexradState.wxMetalTextObject, nexradState.numberOfPanes, gestureRecognizer)
    }

    @objc func gestureZoom(_ gestureRecognizer: UIPinchGestureRecognizer) {
        NexradRenderSurfaceView.gestureZoom(self, nexradState.wxMetalRenders, nexradState.wxMetalTextObject, gestureRecognizer)
    }

    @objc func gesturePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        NexradRenderSurfaceView.gesturePan(self, nexradState.wxMetalRenders, nexradState.wxMetalTextObject, gestureRecognizer)
    }

    @objc func gestureLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        nexradUI.longPressCount = NexradRenderSurfaceView.gestureLongPress(
            self,
            nexradState.wxMetalRenders,
            nexradUI.longPressCount,
            nexradLongPress.longPressAction,
            gestureRecognizer
        )
    }

    @objc func doneClicked() {
        if nexradUI.map.isShown {
            nexradUI.hideMap(self)
        } else {
            if presentedViewController == nil && nexradState.wxMetalRenders[0] != nil {
                // Don't disable screen being left on if one goes from single pane to dual pane via time
                // button and back
                if calledFromTimeButton && RadarPreferences.wxoglRadarAutorefresh {
                    calledFromTimeButton = false
                } else {
                    UIApplication.shared.isIdleTimerDisabled = false
                }
                if RadarPreferences.wxoglRadarAutorefresh {
                    nexradUI.oneMinRadarFetch.invalidate()
                    nexradUI.oneMinRadarFetch = Timer()
                }
                nexradUI.stopGps()
                nexradAnimation.stop()
                if savePreferences {
                    nexradState.wxMetalRenders.forEach {
                        $0!.state.writePreferences()
                    }
                }
                nexradState.wxMetalRenders.forEach {
                    $0!.data.cleanup()
                }
                nexradState.device = nil
                nexradState.wxMetalTextObject.wxMetalRender = nil
                nexradState.metalLayer.indices.forEach {
                    nexradState.metalLayer[$0] = nil
                }
                nexradState.wxMetalRenders.indices.forEach {
                    nexradState.wxMetalRenders[$0]?.data = NexradRenderData()
                    nexradState.wxMetalRenders[$0] = nil
                }
                nexradState.commandQueue = nil
                nexradState.pipelineState = nil
                nexradUI.timer = nil
                nexradState.wxMetalTextObject = NexradRenderTextObject()
            }
            dismiss(animated: UIPreferences.backButtonAnimation) {}
        }
    }

    @objc func productClicked(sender: ToolbarIcon) {
        let popUp = PopUp(self, nexradSubmenu.productButton[sender.tag], "")
        if NexradUtil.isRidTdwr(nexradState.wxMetalRenders[sender.tag]!.state.radarSite) {
            NexradUtil.radarProductListTdwr.forEach { product in
                popUp.add(Action(product) { self.productChanged(sender.tag, product.split(":")[0]) })
            }
        } else {
            nexradState.wxMetalRenders[sender.tag]!.state.radarProductList.forEach { product in
                popUp.add(Action(product) { self.productChanged(sender.tag, product.split(":")[0]) })
            }
        }
        popUp.finish()
    }

    @objc func timeClicked() {
        nexradState.wxMetalRenders.forEach {
            $0!.state.writePreferences()
        }
        if numberOfPanes == 1 {
            nexradState.wxMetalRenders[0]?.state.writePreferencesForSingleToDualPaneTransition()
            Route.radarFromTimeButton(self, 2)
        } else if numberOfPanes == 2 {
            nexradState.wxMetalRenders[0]?.state.writePreferencesForDualToQuadPaneTransition()
            Route.radarFromTimeButton(self, 4)
        }
    }

    @objc func warningClicked() {
        Route.severeDashboard(self)
    }

    func productChanged(_ index: Int, _ product: String) {
        nexradAnimation.stop()
        nexradState.wxMetalRenders[index]!.changeProduct(product)
        nexradColorLegend.updateColorLegend(view, nexradState)
        nexradLayerDownload.getPolygonWarnings()
    }

    @objc func onResume() {
        if RadarPreferences.locdotFollowsGps {
            nexradUI.resumeGps()
        }
        // stopAnimate()
        if nexradState.wxMetalRenders[0] != nil {
            nexradState.wxMetalRenders.forEach {
                $0!.updateTimeToolbar()
            }
            nexradState.wxMetalRenders.forEach {
                $0!.getRadar("")
            }
            nexradLayerDownload.getPolygonWarnings()
        }
    }

    @objc func radarSiteClicked(sender: ToolbarIcon) {
        nexradUI.mapIndex = sender.tag
        nexradUI.hideMap(self)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        nexradUI.map.mapView(annotation)
    }

    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        nexradUI.map.isShown = nexradUI.map.mapViewExtra(annotationView, control, mapCall)
    }

    func mapCall(annotationView: MKAnnotationView) {
        radarSiteChanged((annotationView.annotation!.title!)!, nexradUI.mapIndex)
    }

    func radarSiteChanged(_ radarSite: String, _ index: Int) {
        nexradAnimation.stop()
        UtilityFileManagement.deleteAllFiles()
        nexradState.wxMetalRenders[index]!.fileStorage.memoryBuffer = MemoryBuffer()
        if nexradState.numberOfPanes > 1 {
            nexradSubmenu.siteButton[index].title = radarSite
        } else {
            nexradSubmenu.radarSiteButton.title = radarSite
        }
        nexradLayerDownload.getPolygonWarnings()
        if RadarPreferences.dualpaneshareposn {
            nexradState.wxMetalRenders.forEach {
                $0!.resetRadarSiteAndGetData(radarSite)
            }
        } else {
            nexradState.wxMetalRenders[index]!.resetRadarSiteAndGetData(radarSite)
        }
        nexradState.resetTextObject(self)
    }

    @objc func animateClicked() {
        if !nexradUI.inOglAnim {
            _ = PopUp(
                    self,
                    title: "Select number of animation frames:",
                    nexradSubmenu.animateButton,
                    [5, 10, 20, 30, 40, 50, 60],
                    nexradAnimation.start)
        } else {
            nexradAnimation.stop()
        }
    }

    @objc func invalidateGps() {
        nexradUI.stopGps()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locValue = manager.location?.coordinate { // type CLLocationCoordinate2D
            if nexradState.wxMetalRenders[0] != nil {
                nexradState.wxMetalRenders.forEach {
                    $0!.state.gpsLocation = LatLon(Double(locValue.latitude), Double(locValue.longitude)).reverse()
                    $0!.construct.locationDot($0!.data.locdotBuffers, $0!.data.locCircleBuffers, $0!.setZoom)
                }
            }
        }
    }

    @objc func getRadarEveryMinute() {
        nexradState.wxMetalRenders.forEach {
            $0!.getRadar("")
        }
        nexradLayerDownload.getPolygonWarnings()
    }

    func showTiltMenu() {
        var tilts = ["Tilt 1", "Tilt 2", "Tilt 3", "Tilt 4"]
        if nexradState.wxMetalRenders[0]!.state.isTdwr {
            tilts = ["Tilt 1", "Tilt 2", "Tilt 3"]
        }
        _ = PopUp(self, title: "Tilt Selection", nexradSubmenu.productButton[0], tilts, changeTilt)
    }

    func changeTilt(_ tilt: Int) {
        nexradState.wxMetalRenders.forEach {
            $0!.state.tilt = tilt
            $0!.getRadar("")
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle && UIApplication.shared.applicationState == .inactive {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                AppColors.update()
            } else {
                AppColors.update()
            }
        }
    }

    override var keyCommands: [UIKeyCommand]? {
         [
            UIKeyCommand(input: "4", modifierFlags: .numericPad, action: #selector(keyLeftArrow)),
            UIKeyCommand(input: "8", modifierFlags: .numericPad, action: #selector(keyUpArrow)),
            UIKeyCommand(input: "6", modifierFlags: .numericPad, action: #selector(keyRightArrow)),
            UIKeyCommand(input: "2", modifierFlags: .numericPad, action: #selector(keyDownArrow)),
            UIKeyCommand(input: "7", modifierFlags: .numericPad, action: #selector(keyLeftUpArrow)),
            UIKeyCommand(input: "9", modifierFlags: .numericPad, action: #selector(keyRightUpArrow)),
            UIKeyCommand(input: "3", modifierFlags: .numericPad, action: #selector(keyRightDownArrow)),
            UIKeyCommand(input: "1", modifierFlags: .numericPad, action: #selector(keyLeftDownArrow)),
            UIKeyCommand(input: "5", modifierFlags: .numericPad, action: #selector(keyZoomOut)),
            UIKeyCommand(input: "0", modifierFlags: .numericPad, action: #selector(keyZoomIn)),
            UIKeyCommand(input: UIKeyCommand.inputRightArrow, modifierFlags: [], action: #selector(keyRightArrow)),
            UIKeyCommand(input: UIKeyCommand.inputLeftArrow, modifierFlags: [], action: #selector(keyLeftArrow)),
            UIKeyCommand(input: UIKeyCommand.inputUpArrow, modifierFlags: [], action: #selector(keyUpArrow)),
            UIKeyCommand(input: UIKeyCommand.inputDownArrow, modifierFlags: [], action: #selector(keyDownArrow)),
            UIKeyCommand(input: UIKeyCommand.inputUpArrow, modifierFlags: .alternate, action: #selector(keyZoomOut)),
            UIKeyCommand(input: UIKeyCommand.inputDownArrow, modifierFlags: .alternate, action: #selector(keyZoomIn))
        ]
    }

    @objc func keyRightArrow() {
        NexradRenderUI.moveByKey(nexradState.wxMetalRenders, .right)
    }

    @objc func keyLeftArrow() {
        NexradRenderUI.moveByKey(nexradState.wxMetalRenders, .left)
    }

    @objc func keyUpArrow() {
        NexradRenderUI.moveByKey(nexradState.wxMetalRenders, .up)
    }

    @objc func keyDownArrow() {
        NexradRenderUI.moveByKey(nexradState.wxMetalRenders, .down)
    }

    @objc func keyRightUpArrow() {
        NexradRenderUI.moveByKey(nexradState.wxMetalRenders, .rightUp)
    }

    @objc func keyRightDownArrow() {
        NexradRenderUI.moveByKey(nexradState.wxMetalRenders, .rightDown)
    }

    @objc func keyLeftUpArrow() {
        NexradRenderUI.moveByKey(nexradState.wxMetalRenders, .leftUp)
    }

    @objc func keyLeftDownArrow() {
        NexradRenderUI.moveByKey(nexradState.wxMetalRenders, .leftDown)
    }

    @objc func keyZoomIn() {
        NexradRenderUI.zoomInByKey(nexradState.wxMetalRenders)
    }

    @objc func keyZoomOut() {
        NexradRenderUI.zoomOutByKey(nexradState.wxMetalRenders)
    }
}
