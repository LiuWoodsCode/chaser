// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit
import Metal
import simd

final class NexradTabLongPressMenu {

    let uiv: VcTabLocation
    let nexradStateHS: NexradStateHS
    let radarSiteChanged: (String) -> Void

    init(
        _ uiv: VcTabLocation,
        _ nexradStateHS: NexradStateHS,
        _ radarSiteChanged: @escaping (String) -> Void
    ) {
        self.uiv = uiv
        self.nexradStateHS = nexradStateHS
        self.radarSiteChanged = radarSiteChanged
    }

    func longPressAction(
        _ x: CGFloat,
        _ y: CGFloat,
        _ index: Int
    ) {
        let pointerLocation = NexradRenderUI.getLatLonFromScreenPosition(
                uiv.cardRadar.get(),
                nexradStateHS.wxMetal[index]!,
                nexradStateHS.numberOfPanes,
                nexradStateHS.ortInt,
                x,
                y
            )
        let nearByRadars = RadarSites.getNearest(pointerLocation, 5)
        let dist = LatLon.distance(Location.latLon, pointerLocation)
        let radarLatLon = RadarSites.getLatLon(nexradStateHS.wxMetal[index]!.state.radarSite)
        let distRid = LatLon.distance(radarLatLon, pointerLocation)
        let radarInfo = nexradStateHS.wxMetal[0]!.data.radarBuffers.levelData.radarInfo
        var alertMessage = radarInfo + GlobalVariables.newline
            + String(dist.roundTo(places: 2)) + " miles from location" + GlobalVariables.newline
            + String(distRid.roundTo(places: 2)) + " miles from "
        + nexradStateHS.wxMetal[index]!.state.radarSite
        if nexradStateHS.wxMetal[index]!.state.gpsLocation.latString != "0.0" && nexradStateHS.wxMetal[index]!.state.gpsLocation.lonString != "0.0" {
            alertMessage += GlobalVariables.newline + "GPS: " + nexradStateHS.wxMetal[index]!.state.gpsLocation.prettyPrintNexrad()
        }
        let popUp = PopUp(uiv, uiv.menuButton, "", alertMessage, prefersCatalystList: true)
        nearByRadars.forEach { site in
            let radarDescription = site.codeName + " " + RadarSites.getName(site.codeName) + " \(site.distance) mi"
            popUp.add(Action(radarDescription) { self.radarSiteChanged(site.codeName) })
        }
        if RadarPreferences.warnings || PolygonWarning.areAnyEnabled() {
            popUp.add(Action("Show Warning") { NexradRenderUI.showWarning(pointerLocation, self.uiv) })
        }
        if RadarPreferences.watMcd && PolygonWatch.byType[PolygonEnum.SPCWAT]!.numberList.getValue() != "" {
            popUp.add(Action("Show Watch") { NexradRenderUI.showNearestWatch(.SPCWAT, pointerLocation, self.uiv) })
            popUp.add(Action("Show MCD") { NexradRenderUI.showNearestWatch(.SPCMCD, pointerLocation, self.uiv) })
        }
        if RadarPreferences.mpd && PolygonWatch.byType[PolygonEnum.WPCMPD]!.numberList.getValue()  != "" {
            popUp.add(Action("Show MPD") { NexradRenderUI.showNearestWatch(.WPCMPD, pointerLocation, self.uiv) })
        }
        let obsSite = Metar.findClosestObservation(pointerLocation)
        let obsSiteDirection = LatLon.calculateDirection(pointerLocation, obsSite.latLon)
        popUp.add(Action("Observation: \(obsSite.codeName) \(obsSite.fullName) \(obsSite.distance) mi \(obsSiteDirection)") { NexradRenderUI.getMetar(obsSite, self.uiv) })
        popUp.add(Action(
            "Forecast: " + pointerLocation.latForNws + ", " + pointerLocation.lonForNws) {
                Route.getForecast(self.uiv, pointerLocation)})

        popUp.add(Action("Meteogram: " + obsSite.codeName) { NexradRenderUI.getMeteogram(pointerLocation, self.uiv) })
        popUp.add(Action("Radar status message: " + nearByRadars.first!.codeName) { NexradRenderUI.getRadarStatus(self.uiv, nearByRadars.first!.codeName) })

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
