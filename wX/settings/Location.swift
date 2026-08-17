// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class Location {

    static var locations = [ObjectLocation]()
    private static var numberOfLocations = 1
    // as implied by initial values currentLocation is an index starting at 0
    // while Str version is starting at "1"
    private static var currentLocation = 0
    static var listOf = [String]()

    static var numLocations: Int {
        get { numberOfLocations }
        set {
            numberOfLocations = newValue
            Utility.writePrefInt("LOC_NUM_INT", newValue)
        }
    }

    static func us(_ xStr: String) -> Bool {
        !xStr.contains("CANADA")
    }

    static func checkCurrentLocationValidity() {
        if getCurrentLocation() >= locations.count {
            setCurrentLocationStr(To.string(currentLocation + 1))
        }
    }

    static func initNumLocations() {
        numLocations = Utility.readPrefInt("LOC_NUM_INT", 1)
    }

    private static func setNumLocations(_ numberOfLocations1: Int) {
        numLocations = numberOfLocations1
        // Utility.writePrefInt("LOC_NUM_INT", numberOfLocations)
    }

    static func getCurrentLocation() -> Int {
        currentLocation
    }

    static var currentLocationStr: String { To.string(currentLocation + 1) }

    static var wfo: String { locations[getCurrentLocation()].wfo }

    static var radarSite: String { locations[getCurrentLocation()].radarSite }

    static var x: String { locations[getCurrentLocation()].lat }

    static var y: String { locations[getCurrentLocation()].lon }

    static var latLon: LatLon { locations[getCurrentLocation()].latLon }

    static var name: String { locations[getCurrentLocation()].name }

    static func getName(_ locNum: Int) -> String { locations[locNum].name }

    static func getX(_ locNum: Int) -> String { locations[locNum].lat }

    static func getY(_ locNum: Int) -> String { locations[locNum].lon }

    static func getObservation(_ locNum: Int) -> String { locations[locNum].observation }

    static func getLatLon(_ locNum: Int) -> LatLon { locations[locNum].latLon }

    static func isUS(_ locationNumber: Int) -> Bool {
        if locationNumber == -1 {
            return true
        }
        return locations[locationNumber].isUS
    }

    static var isUS: Bool { locations[getCurrentLocation()].isUS }

    static func refresh() {
        initNumLocations()
        locations.removeAll()
        listOf.removeAll()
        (0..<numLocations).forEach { index in
            locations.append(ObjectLocation(index))
        }
        listOf.append(contentsOf: locations.map { $0.name })
        setCurrentLocationStr(Utility.readPref("CURRENT_LOC_FRAGMENT", "1"))
        checkCurrentLocationValidity()
    }

    static private func getWfoRadarSiteFromPoint(_ latLon: LatLon) -> [String] {
        let pointData = UtilityDownloadNws.getLocationPointData(latLon)
        // "cwa": "IWX",
        // "radarStation": "KGRR"
        let wfo = pointData.parse("\"cwa\": \"(.*?)\"")
        var radarStation = pointData.parse("\"radarStation\": \"(.*?)\"")
        radarStation = UtilityString.getLastXChars(radarStation, 3)
        return [wfo, radarStation]
    }

    // used in adhoc location
    static func save(_ latLon: LatLon, _ name: String) -> String {
        save(To.string(Location.numLocations + 1), latLon, name)
    }

    static func save(_ locNum: String, _ latLon: LatLon, _ labelStr: String) -> String {
        let locNumInt = To.int(locNum)
        let locNumToSave = locNumInt == (Location.numLocations + 1) ? locNumInt : Location.numLocations
        Utility.writePref("LOC" + locNum + "_X", latLon.latString)
        Utility.writePref("LOC" + locNum + "_Y", latLon.lonString)
        Utility.writePref("LOC" + locNum + "_LABEL", labelStr)
        var wfo: String
        var radarSite: String
        setNumLocations(locNumToSave)
        let wfoAndRadar = getWfoRadarSiteFromPoint(latLon)
        wfo = wfoAndRadar[0].uppercased()
        radarSite = wfoAndRadar[1].uppercased()
        if wfo == "" {
            wfo = WfoSites.sites.getNearest(latLon).uppercased()
        }
        if radarSite == "" || radarSite == "LIX" {
            radarSite = RadarSites.getNearestCode(latLon, includeTdwr: false).uppercased()
        }
        Utility.writePref("RID" + locNum, radarSite)
        Utility.writePref("NWS" + locNum, wfo)

        Location.refresh()
        Location.setCurrentLocationStr(locNum)
        return "Saving location \(locNum) as \(labelStr) (\(latLon.latForNws),\(latLon.lonForNws)) / \(wfo)(\(radarSite))"
    }

    static func setCurrentLocationStr(_ currentLocationStr: String) {
        currentLocation = To.int(currentLocationStr) - 1
        Utility.writePref("CURRENT_LOC_FRAGMENT", currentLocationStr)
    }

    static func delete(_ locToDeleteStr: String) {
        let locToDeleteInt = To.int(locToDeleteStr)
        let locNumIntCurrent = Location.numLocations
        if locToDeleteInt > locNumIntCurrent {
            return
        }
        if locToDeleteInt == locNumIntCurrent {
            setNumLocations(locNumIntCurrent - 1)
        } else {
            (locToDeleteInt..<locNumIntCurrent).forEach { index in
                let jIndex = index + 1
                let jStr = String(jIndex)
                let iStr = String(index)
                let locObsCurrent = Utility.readPref("LOC" + jStr + "_OBSERVATION", "")
                let locXCurrent = Utility.readPref("LOC" + jStr + "_X", "")
                let locYCurrent = Utility.readPref("LOC" + jStr + "_Y", "")
                let locLabelCurrent = Utility.readPref("LOC" + jStr + "_LABEL", "")
                let nwsCurrent = Utility.readPref("NWS" + jStr, "")
                let ridCurrent = Utility.readPref("RID" + jStr, "")
                Utility.writePref("LOC" + iStr + "_OBSERVATION", locObsCurrent)
                Utility.writePref("LOC" + iStr + "_X", locXCurrent)
                Utility.writePref("LOC" + iStr + "_Y", locYCurrent)
                Utility.writePref("LOC" + iStr + "_LABEL", locLabelCurrent)
                Utility.writePref("NWS" + iStr, nwsCurrent)
                Utility.writePref("RID" + iStr, ridCurrent)
                Location.numLocations = locNumIntCurrent - 1
                setNumLocations(locNumIntCurrent - 1)
            }
        }
        let locFragCurrentInt = Location.getCurrentLocation() + 1
        if locToDeleteInt == locFragCurrentInt {
            Location.setCurrentLocationStr("1")
        } else if locFragCurrentInt > locToDeleteInt {
            let shiftNum = String(locFragCurrentInt - 1)
            Location.setCurrentLocationStr(shiftNum)
        }
        let widgetLocNum = Utility.readPref("WIDGET_LOCATION", "1")
        let widgetLocNumInt = To.int(widgetLocNum)
        if locToDeleteInt == widgetLocNumInt {
            Utility.writePref("WIDGET_LOCATION", "1")
        } else if widgetLocNumInt > locToDeleteInt {
            let shiftNum = String(widgetLocNumInt - 1)
            Utility.writePref("WIDGET_LOCATION", shiftNum)
        }
        Location.refresh()
    }

    static func updateObservation(_ index: Int, _ obs: String) {
        locations[index].updateObservation(obs)
    }
}
