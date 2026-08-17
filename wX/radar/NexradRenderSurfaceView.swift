// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class NexradRenderSurfaceView {

    var cities = [TextViewMetal]()
    var countyLabels = [TextViewMetal]()
    var observations = [TextViewMetal]()
    var spottersLabels = [TextViewMetal]()
    var pressureCenterLabels = [TextViewMetal]()
    static let maxZoom: Float = 45.0
    static let minZoom: Float = 0.015

    static func setModifiedZoom(_ newZoom: Float, _ oldZoom: Float, _ wxMetal: NexradRender) {
        let zoomDifference = newZoom / oldZoom
        wxMetal.state.xPos *= zoomDifference
        wxMetal.state.yPos *= zoomDifference
    }

    static func gesturePan(_ uiv: UIViewController, _ wxMetal: [NexradRender?], _ textObj: NexradRenderTextObject, _ gestureRecognizer: UIPanGestureRecognizer) {
        let panSensitivity: Float = wxMetal[0]!.state.numberOfPanes == 4 ? 1000.0 : 500.0
        let location = gestureRecognizer.location(in: uiv.view)
        let radarIndex = tapInPane(location, uiv, wxMetal[0]!)
        if RadarPreferences.dualpaneshareposn {
            wxMetal.forEach {
                if gestureRecognizer.state == UIGestureRecognizer.State.changed {
                    let pointInView = gestureRecognizer.location(in: uiv.view)
                    let xDelta = Float(($0!.lastPanLocation.x - pointInView.x) / uiv.view.bounds.width) * panSensitivity
                    let yDelta = Float(($0!.lastPanLocation.y - pointInView.y) / uiv.view.bounds.height) * panSensitivity
                    $0!.state.xPos -= xDelta
                    $0!.state.yPos += yDelta * Float((uiv.view.bounds.height / uiv.view.bounds.width))
                    $0!.lastPanLocation = pointInView
                } else if gestureRecognizer.state == UIGestureRecognizer.State.began {
                    $0!.lastPanLocation = gestureRecognizer.location(in: uiv.view)
                }
            }
        } else {
            if gestureRecognizer.state == UIGestureRecognizer.State.changed {
                let pointInView = gestureRecognizer.location(in: uiv.view)
                let xDelta = Float((wxMetal[radarIndex]!.lastPanLocation.x - pointInView.x) / uiv.view.bounds.width) * panSensitivity
                let yDelta = Float((wxMetal[radarIndex]!.lastPanLocation.y - pointInView.y) / uiv.view.bounds.height) * panSensitivity
                wxMetal[radarIndex]!.state.xPos -= xDelta
                wxMetal[radarIndex]!.state.yPos += yDelta
                wxMetal[radarIndex]!.lastPanLocation = pointInView
            } else if gestureRecognizer.state == UIGestureRecognizer.State.began {
                wxMetal[radarIndex]!.lastPanLocation = gestureRecognizer.location(in: uiv.view)
            }
        }
        gestureRecognizer.setTranslation(CGPoint.zero, in: uiv.view)
        switch gestureRecognizer.state {
        case .began:
            textObj.removeTextLabels()
            wxMetal.forEach {
                $0!.state.displayHold = true
            }
        case .ended:
            textObj.addTextLabels()
            wxMetal.forEach {
                $0!.state.displayHold = false
            }
        default:
            break
        }
        wxMetal.forEach { $0!.demandRender() }
    }

    // bottom left 0,600
    // bottom right 350,600
    // top left 0,0
    // top right 350,0
    static func tapInPane(_ location: CGPoint, _ uiv: UIViewController, _ wxMetal: NexradRender) -> Int {
        if wxMetal.state.numberOfPanes == 1 {
            return 0
        } else if wxMetal.state.numberOfPanes == 2 {
            if !UtilityUI.isLandscape() && !(uiv.view.frame.width > uiv.view.frame.height) {
                if location.y < uiv.view.frame.height / 2.0 {
                    return 0
                } else {
                    return 1
                }
            } else {
                if location.x < uiv.view.frame.width / 2.0 {
                    return 0
                } else {
                    return 1
                }
            }
        } else { // 4 pane
            if location.y < uiv.view.frame.height / 2.0 {
                if location.x < uiv.view.frame.width / 2.0 {
                    return 0 // top left
                } else {
                    return 1 // top right
                }
            } else {
                if location.x < uiv.view.frame.width / 2.0 {
                    return 2 // bottom left
                } else {
                    return 3 // bottom right
                }
            }
        }
    }

    static func singleTap(_ uiv: UIViewController, _ wxMetal: [NexradRender?], _ textObj: NexradRenderTextObject, _ gestureRecognizer: GestureData) {
        let location = gestureRecognizer.location(in: uiv.view)
        let radarIndex = tapInPane(location, uiv, wxMetal[0]!)
        if RadarPreferences.dualpaneshareposn {
            wxMetal.forEach {
                if $0!.state.zoom * 0.5 > minZoom {
                    setModifiedZoom($0!.state.zoom * 0.5, $0!.state.zoom, $0!)
                    $0!.state.zoom *= 0.5
                    $0!.setZoom()
                }
            }
        } else {
            if wxMetal[radarIndex]!.state.zoom * 0.5 > minZoom {
                setModifiedZoom(wxMetal[radarIndex]!.state.zoom * 0.5, wxMetal[radarIndex]!.state.zoom, wxMetal[radarIndex]!)
                wxMetal[radarIndex]!.state.zoom *= 0.5
                wxMetal[radarIndex]!.setZoom()
            }
        }
        textObj.refreshTextLabels()
    }

    static func doubleTap(
        _ uiv: UIViewController,
        _ wxMetal: [NexradRender?],
        _ textObj: NexradRenderTextObject,
        _ numberOfPanes: Int,
        _ gestureRecognizer: GestureData
    ) {
        let location = gestureRecognizer.location(in: uiv.view)
        let radarIndex = tapInPane(location, uiv, wxMetal[0]!)
        let bounds = UtilityUI.getScreenBoundsNoCatalyst()
        var width = Float(uiv.view.bounds.size.width)
        var density: Float = -(width / bounds.0)
        #if targetEnvironment(macCatalyst)
        let boundsOrig = UtilityUI.getScreenBounds()
        width = boundsOrig.0
        density *= 0.25
        #endif
        if numberOfPanes == 4 {
            density *= 2.0
        }
        density /= Float(UIScreen.main.scale)
        var xMiddle = Float(uiv.view.frame.width / 2.0)
        var yMiddle = Float(uiv.view.frame.height / 2.0)
        if numberOfPanes == 2 {
            if !UtilityUI.isLandscape() {
                if radarIndex == 0 {
                    yMiddle *= 0.5
                } else {
                    yMiddle *= 1.5
                }
            } else {
                if radarIndex == 0 {
                    xMiddle *= 0.5
                } else {
                    xMiddle *= 1.5
                }
            }
        }
        if numberOfPanes == 4 {
            if radarIndex == 0 {
                xMiddle *= 0.5
                yMiddle *= 0.5
            } else if radarIndex == 1 {
                xMiddle *= 1.5
                yMiddle *= 0.5
            } else if radarIndex == 2 {
                xMiddle *= 0.5
                yMiddle *= 1.5
            } else if radarIndex == 3 {
                xMiddle *= 1.5
                yMiddle *= 1.5
            }
        }
        if RadarPreferences.dualpaneshareposn {
            wxMetal.forEach {
                if $0!.state.zoom * 2.0 < maxZoom {
                    $0!.state.xPos += ((Float(location.x) - xMiddle) * density)
                    $0!.state.yPos += ((yMiddle - Float(location.y)) * density)
                    setModifiedZoom($0!.state.zoom * 2.0, $0!.state.zoom, $0!)
                    $0!.state.zoom *= 2.0
                    $0!.setZoom()
                }
            }
        } else {
            if wxMetal[radarIndex]!.state.zoom * 2.0 < maxZoom {
                wxMetal[radarIndex]!.state.xPos += (Float(location.x) - xMiddle) * density
                wxMetal[radarIndex]!.state.yPos += (yMiddle - Float(location.y)) * density
                setModifiedZoom(wxMetal[radarIndex]!.state.zoom * 2.0, wxMetal[radarIndex]!.state.zoom, wxMetal[radarIndex]!)
                wxMetal[radarIndex]!.state.zoom *= 2.0
                wxMetal[radarIndex]!.setZoom()
            }
        }
        textObj.refreshTextLabels()
    }

    static func gestureLongPress(
        _ uiv: UIViewController,
        _ wxMetal: [NexradRender?],
        _ longPressCount: Int,
        _ fn: (CGFloat, CGFloat, Int) -> Void,
        _ gestureRecognizer: UILongPressGestureRecognizer
    ) -> Int {
        let location = gestureRecognizer.location(in: uiv.view)
        var longPressCountLocal = longPressCount
        let radarIndex = tapInPane(location, uiv, wxMetal[0]!)
        longPressCountLocal += 1
        if longPressCountLocal % 2 != 0 {
            fn(location.x, location.y, radarIndex)
        }
        return longPressCountLocal
    }

    // Used by nexrad on main screen
    // removed as option , _ wxMetal: [NexradRender?]
    static func gestureLongPress(_ uiv: UIStackView, _ longPressCount: Int, _ fn: (CGFloat, CGFloat, Int) -> Void, _ gestureRecognizer: UILongPressGestureRecognizer) -> Int {
        let location = gestureRecognizer.location(in: uiv)
        var longPressCountLocal = longPressCount
        let radarIndex = 0
        longPressCountLocal += 1
        if longPressCountLocal % 2 != 0 {
            fn(location.x, location.y, radarIndex)
        }
        return longPressCountLocal
    }

    static func gestureZoom(_ uiv: UIViewController, _ wxMetal: [NexradRender?], _ textObj: NexradRenderTextObject, _ gestureRecognizer: UIPinchGestureRecognizer) {
        let location = gestureRecognizer.location(in: uiv.view)
        let radarIndex = tapInPane(location, uiv, wxMetal[0]!)
        let slowItDown: Float = 1.0
        let fudge: Float = 0.01
        if RadarPreferences.dualpaneshareposn {
            wxMetal.forEach {
                if gestureRecognizer.state == UIGestureRecognizer.State.changed
                    && $0!.state.zoom < maxZoom
                    && $0!.state.zoom > minZoom {
                    setModifiedZoom($0!.state.zoom / ((1.0 / Float(gestureRecognizer.scale)) * slowItDown), $0!.state.zoom, $0!)
                    $0!.state.zoom /= ((1.0 / Float(gestureRecognizer.scale)) * slowItDown)
                    if $0!.state.zoom < minZoom {
                        setModifiedZoom(minZoom + fudge / 10.0, $0!.state.zoom, $0!)
                        $0!.state.zoom = minZoom + fudge / 10.0
                    }
                    if $0!.state.zoom > maxZoom {
                        setModifiedZoom(maxZoom - fudge, $0!.state.zoom, $0!)
                        $0!.state.zoom = maxZoom - fudge
                    }
                }
                $0!.setZoom()
            }
        } else {
            if gestureRecognizer.state == UIGestureRecognizer.State.changed
                && wxMetal[radarIndex]!.state.zoom < maxZoom
                && wxMetal[radarIndex]!.state.zoom > minZoom {
                setModifiedZoom(
                    wxMetal[radarIndex]!.state.zoom / ((1.0 / Float(gestureRecognizer.scale)) * slowItDown),
                    wxMetal[radarIndex]!.state.zoom,
                    wxMetal[radarIndex]!
                )
                wxMetal[radarIndex]!.state.zoom /= ((1.0 / Float(gestureRecognizer.scale)) * slowItDown)
                if wxMetal[radarIndex]!.state.zoom < minZoom {
                    setModifiedZoom(minZoom + fudge / 10.0, wxMetal[radarIndex]!.state.zoom, wxMetal[radarIndex]!)
                    wxMetal[radarIndex]!.state.zoom = minZoom + fudge / 10.0
                }
                if wxMetal[radarIndex]!.state.zoom > maxZoom {
                    setModifiedZoom(maxZoom - fudge, wxMetal[radarIndex]!.state.zoom, wxMetal[radarIndex]!)
                    wxMetal[radarIndex]!.state.zoom = maxZoom - fudge
                }
            }
            wxMetal[radarIndex]!.setZoom()
        }
        gestureRecognizer.scale = 1
        switch gestureRecognizer.state {
        case .began:
            textObj.removeTextLabels()
            wxMetal.forEach {
                $0!.state.displayHold = true
            }
        case .ended:
            textObj.addTextLabels()
            wxMetal.forEach {
                $0!.state.displayHold = false
            }
        default:
            break
        }
        wxMetal.forEach {
            $0!.demandRender()
        }
    }
}
