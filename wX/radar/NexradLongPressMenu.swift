// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class NexradLongPressMenu {

    let uiv: UIViewController
    let nexradState: NexradState
    let nexradSubmenu: NexradSubmenu
    let showTiltMenu: () -> Void
    let radarSiteChanged: (String, Int) -> Void

    init(
        _ uiv: UIViewController,
        _ nexradState: NexradState,
        _ nexradSubmenu: NexradSubmenu,
        _ showTiltMenu: @escaping () -> Void,
        _ radarSiteChanged: @escaping (String, Int) -> Void
    ) {
        self.uiv = uiv
        self.nexradState = nexradState
        self.nexradSubmenu = nexradSubmenu
        self.showTiltMenu = showTiltMenu
        self.radarSiteChanged = radarSiteChanged
    }

    func longPressAction(
        _ x: CGFloat,
        _ y: CGFloat,
        _ index: Int
    ) {
        let pointerLocation = NexradRenderUI.getLatLonFromScreenPosition(
                uiv,
                nexradState.wxMetalRenders[index]!,
                nexradState.numberOfPanes,
                nexradState.ortInt,
                x,
                y
            )
        let nearByRadars = RadarSites.getNearest(pointerLocation, 5)
        // determine if GPS is in use, if so show location to that
        var locationString = "location"
        var location = Location.latLon
        if nexradState.wxMetalRenders[index]!.state.gpsLocation.latString != "0.0" && nexradState.wxMetalRenders[index]!.state.gpsLocation.lonString != "0.0" {
            locationString = "GPS"
            location = nexradState.wxMetalRenders[index]!.state.gpsLocation.reverse()
        }
        let dist = LatLon.distance(location, pointerLocation)
        let radarLatLon = RadarSites.getLatLon(nexradState.wxMetalRenders[index]!.state.radarSite)
        let distRid = LatLon.distance(radarLatLon, pointerLocation)
        let distRidKm = LatLon.distance(radarLatLon, pointerLocation, .K)
        let radarInfo = nexradState.wxMetalRenders[0]!.data.radarBuffers.levelData.radarInfo
        var alertMessage = radarInfo + GlobalVariables.newline
            + To.stringFromD(dist.roundTo(places: 2)) + " miles from " + locationString + GlobalVariables.newline
            + To.stringFromD(distRid.roundTo(places: 2)) + " miles from "
            + nexradState.wxMetalRenders[index]!.state.radarSite
        if nexradState.wxMetalRenders[index]!.state.gpsLocation.latString != "0.0" && nexradState.wxMetalRenders[index]!.state.gpsLocation.lonString != "0.0" {
            alertMessage += GlobalVariables.newline + "GPS: " + nexradState.wxMetalRenders[index]!.state.gpsLocation.prettyPrintNexrad()
        }
        let heightAgl = Int(UtilityMath.getRadarBeamHeight(nexradState.wxMetalRenders[index]!.data.radarBuffers.levelData.degree, distRidKm))
        let heightMsl = Int(nexradState.wxMetalRenders[index]!.data.radarBuffers.levelData.radarHeight) + heightAgl
        alertMessage += GlobalVariables.newline + "Beam Height MSL: " + To.string(heightMsl) + " ft, AGL: " + To.string(heightAgl) + " ft"
        if RadarPreferences.wpcFronts {
            var wpcFrontsTimeStamp = Utility.readPref("WPC_FRONTS_TIMESTAMP", "")
            wpcFrontsTimeStamp = wpcFrontsTimeStamp.replace(To.string(ObjectDateTime.getYear()), "")
            wpcFrontsTimeStamp = wpcFrontsTimeStamp.insert(4, " ")
            alertMessage += GlobalVariables.newline + "WPC Fronts: " + wpcFrontsTimeStamp
        }
        let popupButton: UIBarButtonItem
        if RadarPreferences.dualpaneshareposn || nexradState.numberOfPanes == 1 {
            popupButton = nexradSubmenu.radarSiteButton
        } else {
            popupButton = nexradSubmenu.siteButton[0]
        }
        let popUp = PopUp(uiv, popupButton, "", alertMessage)
        nearByRadars.forEach { site in
            let bearingToRadar = LatLon.calculateDirection(pointerLocation, site.latLon)
            let radarDescription = "\(site.codeName) \(RadarSites.getName(site.codeName)) \(site.distance) mi \(bearingToRadar)"
            popUp.add(Action(radarDescription) { self.radarSiteChanged(site.codeName, index) })
        }
        if NexradUtil.canTilt(nexradState.wxMetalRenders[index]!.state.product) {
            popUp.add(Action("Change Tilt") { self.showTiltMenu() })
        }
        if RadarPreferences.warnings || PolygonWarning.areAnyEnabled() { // took out && warningCount > 0
            popUp.add(Action("Show Warning") { NexradRenderUI.showWarning(pointerLocation, self.uiv) })
        }
        if RadarPreferences.watMcd && PolygonWatch.byType[PolygonEnum.SPCWAT]!.numberList.getValue() != "" {
            popUp.add(Action("Show Watch") { NexradRenderUI.showNearestWatch(.SPCWAT, pointerLocation, self.uiv) })
        }
        if RadarPreferences.watMcd && PolygonWatch.byType[PolygonEnum.SPCMCD]!.numberList.getValue()  != "" {
            popUp.add(Action("Show MCD") { NexradRenderUI.showNearestWatch(.SPCMCD, pointerLocation, self.uiv) })
        }
        if RadarPreferences.mpd && PolygonWatch.byType[PolygonEnum.WPCMPD]!.numberList.getValue()  != "" {
            popUp.add(Action("Show MPD") { NexradRenderUI.showNearestWatch(.WPCMPD, pointerLocation, self.uiv) })
        }
        let obsSite = Metar.findClosestObservation(pointerLocation)
        let obsSiteDirection = LatLon.calculateDirection(pointerLocation, obsSite.latLon)
        popUp.add(Action("Observation: \(obsSite.codeName) \(obsSite.fullName) \(obsSite.distance) mi \(obsSiteDirection)") {
            NexradRenderUI.getMetar(obsSite, self.uiv) })
        popUp.add(Action("Forecast: \(pointerLocation.prettyPrint())") { Route.getForecast(self.uiv, pointerLocation) })
        popUp.add(Action("Meteogram: \(obsSite.codeName)") { NexradRenderUI.getMeteogram(pointerLocation, self.uiv) })
        popUp.add(Action("Radar status message: \(nearByRadars.first!.codeName)") { NexradRenderUI.getRadarStatus(self.uiv, nearByRadars.first!.codeName) })

        let nearestSoundingCode = SoundingSites.sites.getNearest(pointerLocation)
        let nearestSoundingLatLon = SoundingSites.sites.byCode[nearestSoundingCode]!.latLon
        let bearingToSounding = LatLon.calculateDirection(pointerLocation, nearestSoundingLatLon)
        popUp.add(Action("Sounding: \(SoundingSites.sites.getNearest(pointerLocation)) " + To.string(SoundingSites.sites.getNearestInMiles(pointerLocation)) + " mi \(bearingToSounding)") { Route.spcSounding(self.uiv, SoundingSites.sites.getNearest(pointerLocation)) })

        let nearestVisCode = UtilityGoes.getNearest(pointerLocation)
        let actionVis = Action("Vis Sat: \(nearestVisCode)") { Route.visBySector(self.uiv, nearestVisCode) }
        popUp.add(actionVis)

        let nearestWfo = WfoSites.sites.getNearest(pointerLocation)
        let nearestWfoLatLon = WfoSites.sites.byCode[nearestWfo]!.latLon
        let bearingToWfo = LatLon.calculateDirection(pointerLocation, nearestWfoLatLon)
        let actionWfo = Action("AFD: \(nearestWfo) \(WfoSites.sites.getNearestInMiles(pointerLocation)) mi \(bearingToWfo)") {
            Route.wfoTextBySector(self.uiv, nearestWfo)
        }
        popUp.add(actionWfo)

        let nearestSpcMeso = UtilitySpcMeso.getNearest(pointerLocation)
        let actionSpcMeso = Action("Spc Meso: \(UtilitySpcMeso.sectorMap[nearestSpcMeso]!)") {
            Route.spcMesoBySector(self.uiv, nearestSpcMeso)
        }
        popUp.add(actionSpcMeso)

        popUp.finish()
    }
}
