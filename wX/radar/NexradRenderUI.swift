// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class NexradRenderUI {

    static func zoomOutByKey(_ wxMetal: [NexradRender?]) {
        wxMetal.forEach {
            if $0!.state.zoom > NexradRenderSurfaceView.minZoom {
                NexradRenderSurfaceView.setModifiedZoom($0!.state.zoom * 0.8, $0!.state.zoom, $0!)
                $0?.state.zoom *= 0.8
                $0?.setZoom()
                $0?.wxMetalTextObject.refreshTextLabels()
            }
        }
        wxMetal.forEach {
            $0?.demandRender()
        }
    }

    static func zoomInByKey(_ wxMetal: [NexradRender?]) {
        wxMetal.forEach {
            if $0!.state.zoom < NexradRenderSurfaceView.maxZoom {
                NexradRenderSurfaceView.setModifiedZoom($0!.state.zoom * 1.25, $0!.state.zoom, $0!)
                $0?.state.zoom *= 1.25
                $0?.setZoom()
                $0?.wxMetalTextObject.refreshTextLabels()
            }
        }
        wxMetal.forEach {
            $0?.demandRender()
        }
    }

    static func moveByKey(_ wxMetal: [NexradRender?], _ direction: KeyDirections) {
        var xChange: Float = 0.0
        var yChange: Float = 0.0
        let distance: Float = 25.0
        switch direction {
        case .up:
            yChange = -1 * distance
        case .leftUp:
            yChange = -1 * distance
            xChange = distance
        case .rightUp:
            yChange = -1 * distance
            xChange = -1 * distance
        case .leftDown:
            yChange = distance
            xChange = distance
        case .rightDown:
            yChange = distance
            xChange = -1 * distance
        case .down:
            yChange = distance
        case .right:
            xChange = -1 * distance
        case .left:
            xChange = distance
        }
        wxMetal.forEach {
            $0?.state.xPos += xChange
            $0?.state.yPos += yChange
            $0?.wxMetalTextObject.refreshTextLabels()
        }
        wxMetal.forEach {
            $0?.demandRender()
        }
    }

    static func showWarning(_ location: LatLon, _ uiv: UIViewController) {
        let url = Warnings.show(location)
        if url != "" {
            Route.alertDetail(uiv, url)
        }
    }

    static func showNearestWatch(_ type: PolygonEnum, _ location: LatLon, _ uiv: UIViewController) {
        let number = Watch.show(location, type)
        if number != "" {
            Route.spcMcdWatchItem(uiv, type, number)
        }
    }

    static func getMetar(_ site: Site, _ uiv: UIViewController) {
        _ = FutureText2({ Metar.findClosestMetar(site) }, { s in Route.textViewer(uiv, s) })
    }

    static func getMeteogram(_ location: LatLon, _ uiv: UIViewController) {
        let obsSite = Metar.findClosestObservation(location)
        let url =         "https://lamp.mdl.nws.noaa.gov/lamp/meteo.php?BackHour=0&TempBox=Y&DewBox=Y&SkyBox=Y&WindSpdBox=Y&WindDirBox=Y&WindGustBox=Y&CigBox=Y&VisBox=Y&ObvBox=Y&PtypeBox=N&PopoBox=Y&LightningBox=Y&ConvBox=Y&sta=\(obsSite.codeName)"
        Route.imageViewer(uiv, url)
    }

    static func getRadarStatus(_ uiv: UIViewController, _ radarSite: String) {
        _ = FutureText2({ getRadarStatusMessage(radarSite) }, { s in Route.textViewer(uiv, s) })
    }

    static func getRadarStatusMessage(_ radarSite: String) -> String {
        var ridSmall = radarSite
        if radarSite.count == 4 {
            ridSmall.remove(at: radarSite.startIndex)
        }
        let message = DownloadText.byProduct("FTM" + ridSmall.uppercased())
        if message == "" {
            return "The current radar status for " + radarSite + " is not available."
        } else {
            return message
        }
    }

    static func getLatLonFromScreenPosition(
        _ uiv: UIViewController,
        _ wxMetal: NexradRender,
        _ numberOfPanes: Int,
        _ ortInt: Float,
        _ x: CGFloat,
        _ y: CGFloat
    ) -> LatLon {
        let width = Double(uiv.view.bounds.size.width)
        let height = Double(uiv.view.bounds.size.height)
        var yModified = Double(y)
        var xModified = Double(x)
        if numberOfPanes == 2 {
            if !UtilityUI.isLandscape() && !(uiv.view.frame.width > uiv.view.frame.height) {
                if y > uiv.view.frame.height / 2.0 { yModified -= Double(uiv.view.frame.height) / 2.0 }
            } else {
                if x > uiv.view.frame.width / 2.0 { xModified -= Double(uiv.view.frame.width) / 2.0 }
            }
        }
        if numberOfPanes == 4 {
            if y > uiv.view.frame.height / 2.0 { yModified -= Double(uiv.view.frame.height) / 2.0 }
            if x > uiv.view.frame.width / 2.0 { xModified -= Double(uiv.view.frame.width) / 2.0 }
        }
        var density = Double(ortInt * 2) / width
        if numberOfPanes == 4 {
            density = 2.0 * Double(ortInt * 2.0) / width
        }
        var yMiddle = 0.0
        var xMiddle = 0.0
        if numberOfPanes == 1 {
            yMiddle = height / 2.0
        } else {
            yMiddle = height / 4.0
        }
        if numberOfPanes == 4 {
            xMiddle = width / 4.0
        } else {
            xMiddle = width / 2.0
        }
        if numberOfPanes == 2 {
            if !UtilityUI.isLandscape() && !(uiv.view.frame.width > uiv.view.frame.height) {
                xMiddle = width / 2.0
                yMiddle = height / 4.0
            } else {
                xMiddle = width / 4.0
                yMiddle = height / 2.0
            }
        }
        return computeLatLon(density, xMiddle, yMiddle, xModified, yModified,
                             wxMetal.state.projectionNumbers.oneDegreeScaleFactor,
                             wxMetal.state.radarSite,
                             wxMetal.state.zoom,
                             wxMetal.state.xPos,
                             wxMetal.state.yPos)
    }

    // main screen nexrad
    static func getLatLonFromScreenPosition(
        _ uiv: UIStackView,
        _ wxMetal: NexradRender,
        _ numberOfPanes: Int,
        _ ortInt: Float,
        _ x: CGFloat,
        _ y: CGFloat
    ) -> LatLon {
        let width = Double(uiv.bounds.size.width)
        let height = Double(uiv.bounds.size.height)
        var yModified = Double(y)
        var xModified = Double(x)
        if numberOfPanes == 2 {
            if !UtilityUI.isLandscape() && !(uiv.frame.width > uiv.frame.height) {
                if y > uiv.frame.height / 2.0 { yModified -= Double(uiv.frame.height) / 2.0 }
            } else {
                if x > uiv.frame.width / 2.0 { xModified -= Double(uiv.frame.width) / 2.0 }
            }
        }
        if numberOfPanes == 4 {
            if y > uiv.frame.height / 2.0 { yModified -= Double(uiv.frame.height) / 2.0 }
            if x > uiv.frame.width / 2.0 { xModified -= Double(uiv.frame.width) / 2.0 }
        }
        var density = Double(ortInt * 2) / width
        if numberOfPanes == 4 {
            density = 2.0 * Double(ortInt * 2.0) / width
        }
        var yMiddle = 0.0
        var xMiddle = 0.0
        if numberOfPanes == 1 {
            yMiddle = height / 2.0
        } else {
            yMiddle = height / 4.0
        }
        if numberOfPanes == 4 {
            xMiddle = width / 4.0
        } else {
            xMiddle = width / 2.0
        }
        if numberOfPanes == 2 {
            if !UtilityUI.isLandscape() && !(uiv.frame.width > uiv.frame.height) {
                xMiddle = width / 2.0
                yMiddle = height / 4.0
            } else {
                xMiddle = width / 4.0
                yMiddle = height / 2.0
            }
        }
        return computeLatLon(density, xMiddle, yMiddle, xModified, yModified,
                             wxMetal.state.projectionNumbers.oneDegreeScaleFactor,
                             wxMetal.state.radarSite,
                             wxMetal.state.zoom,
                             wxMetal.state.xPos,
                             wxMetal.state.yPos)
    }

    static func computeLatLon(
        _ density: Double,
        _ xMiddle: Double,
        _ yMiddle: Double,
        _ xModified: Double,
        _ yModified: Double,
        _ oneDegreeScaleFactor: Double,
        _ radarSite: String,
        _ zoom: Float,
        _ xPos: Float,
        _ yPos: Float
    ) -> LatLon {
        let diffX = density * (xMiddle - xModified) / Double(zoom)
        let diffY = density * (yMiddle - yModified) / Double(zoom)
        let radarLocation = RadarSites.getLatLon(radarSite).reverse()
        let ppd = oneDegreeScaleFactor
        var newX = radarLocation.lon + (Double(xPos) / Double(zoom) + diffX) / ppd
        let test2 = 180.0 / Double.pi * log(tan(Double.pi / 4 + radarLocation.lat * (Double.pi / 180) / 2.0))
        var newY = test2 + (Double(-1.0 * yPos) / Double(zoom) + diffY) / ppd
        newY = 180.0 / Double.pi * (2 * atan(exp(newY * Double.pi / 180.0)) - Double.pi / 2.0)
        newX *= -1.0
        return LatLon(newY, newX)
    }
}
