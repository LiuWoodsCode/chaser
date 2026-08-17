// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class ObjectLocation {

    let lat: String
    let lon: String
    let name: String
    let wfo: String
    let radarSite: String
    let isUS: Bool
    var observation: String
    private let prefNumberString: String

    init(_ locNumAsInt: Int) {
        let locNumAsString = To.string(locNumAsInt + 1)
        prefNumberString = locNumAsString
        lat = Utility.readPref("LOC" + locNumAsString + "_X", "")
        lon = Utility.readPref("LOC" + locNumAsString + "_Y", "")
        name = Utility.readPref("LOC" + locNumAsString + "_LABEL", "")
        wfo = Utility.readPref("NWS" + locNumAsString, "")
        radarSite = Utility.readPref("RID" + locNumAsString, "")
        observation = Utility.readPref("LOC" + locNumAsString + "_OBSERVATION", "")
        isUS = Location.us(lat)
    }

    func saveToNewSlot(_ newLocNumInt: Int) {
        let locNumAsString = To.string(newLocNumInt + 1)
        Utility.writePref("LOC" + locNumAsString + "_X", lat)
        Utility.writePref("LOC" + locNumAsString + "_Y", lon)
        Utility.writePref("LOC" + locNumAsString + "_LABEL", name)
        Utility.writePref("NWS" + locNumAsString, wfo)
        Utility.writePref("RID" + locNumAsString, radarSite)
        Utility.writePref("LOC" + locNumAsString + "_OBSERVATION", observation)
        Location.refresh()
    }

    func updateObservation(_ observation: String) {
        self.observation = observation
        Utility.writePref("LOC" + prefNumberString + "_OBSERVATION", observation)
    }

    var latLon: LatLon { LatLon(lat, lon) }
}
