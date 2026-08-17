// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class UtilityRtma {

    static let codes = [
        "2m_temp",
        "10m_wnd",
        "2m_dwpt",
        "ceiling",
        "vis"
    ]

    static let sectors = [
        "alaska",
        "ca",
        "co",
        "fl",
        "guam",
        "gulf-coast",
        "mi",
        "mid-atl",
        "mid-west",
        "mt",
        "nc_sc",
        "nd_sd",
        "new-eng",
        "nw-pacific",
        "ohio-valley",
        "sw_us",
        "tx",
        "wi"
    ]

    // approx based off inspection
    private static let sectorToLatLon = [
        "alaska": LatLon(63.25, -156.5),
        "ca": LatLon(38.0, -118.5),
        "co": LatLon(39.0, -105.25),
        "fl": LatLon(27.5, -83.25),
        "guam": LatLon(13.5, 144.75),
        "gulf-coast": LatLon(32.75, -90.25),
        "mi": LatLon(43.75, -84.75),
        "mid-atl": LatLon(39.75, -75.75),
        "mid-west": LatLon(39.5, -93.0),
        "mt": LatLon(45.0, -109.25),
        "nc_sc": LatLon(34.5, -79.75),
        "nd_sd": LatLon(45.5, -98.25),
        "new-eng": LatLon(43.0, -71.25),
        "nw-pacific": LatLon(45.5, -122.75),
        "ohio-valley": LatLon(39.0, -84.75),
        "sw_us": LatLon(34.5, -104.25),
        "tx": LatLon(32.0, -100.25),
        "wi": LatLon(44.25, -89.75)
    ]

    static func getNearest(_ latLon: LatLon) -> String {
        UtilityLocation.getNearest(latLon, sectorToLatLon)
    }

    static func getTimes() -> [String] {
        let html = "https://mag.ncep.noaa.gov/observation-parameter.php?group=Observations%20and%20Analyses&obstype=RTMA&area=MI&ps=area".getHtml()
        // title="20221116 00 UTC"
        return Array(Set(UtilityString.parseColumn(html, "([0-9]{8} [0-9]{2} UTC)"))).sorted().reversed()
    }

    static func getUrl(_ code: String, _ sector: String, _ runTime: String) -> String {
        let currentRun = Utility.safeGet(runTime.split(" "), 1)
        return "https://mag.ncep.noaa.gov/data/rtma/" + currentRun + "/rtma_" + sector + "_000_" + code + ".gif"
    }

    static func getUrlForHomeScreen(_ product: String) -> String {
        let sector = getNearest(Location.latLon)
        let runTimes = getTimes()
        let runTime = runTimes.first ?? ""
        let currentRun = Utility.safeGet(runTime.split(" "), 1)
        return "https://mag.ncep.noaa.gov/data/rtma/" + currentRun + "/rtma_" + sector + "_000_" + product + ".gif"
    }
}
