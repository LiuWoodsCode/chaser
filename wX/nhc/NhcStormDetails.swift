// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class NhcStormDetails {

    let center: String
    let classification: String
    let name: String
    let binNumber: String
    let stormId: String
    let dateTime: String
    let movement: String
    let pressure: String
    let intensity: String
    let status: String
    let baseUrl: String
    let goesUrl: String
    var stormPrefix = "MIATCP"
    var advisoryNumber = ""

    init(
        _ name: String,
        _ movementDir: String,
        _ movementSpeed: String,
        _ pressure: String,
        _ binNumber: String,
        _ stormId: String,
        _ lastUpdate: String,
        _ classification: String,
        _ lat: String,
        _ lon: String,
        _ intensity: String,
        _ status: String,
        _ stormPrefix: String,
        _ advisoryUrl: String
    ) {
        self.name = name
        self.pressure = pressure
        self.binNumber = binNumber
        self.stormId = stormId
        self.classification = classification
        self.intensity = intensity
        self.status = status
        self.stormPrefix = stormPrefix
        center = lat + " " + lon
        dateTime = lastUpdate
        movement = UtilityMath.bearingToDirection(To.int(movementDir)) + "(\(movementDir)) at " + movementSpeed + " mph"
        let modBinNumber = stormId.substring(0, 4).uppercased()
        advisoryNumber = advisoryUrl.split("/").last!.replace(".shtml", "")

        // HFO storm used URL https://www.nhc.noaa.gov/storm_graphics/EP09/EP092021_5day_cone_with_line_and_wind_sm2.png
//        "activeStorms": [
//            {
//                "id": "ep092021",
//                "binNumber": "CP2",
//                "name": "Jimena",
//                "classification": "PTC",
//                "intensity": "30",
//                "pressure": "1009",
//                "latitude": "17.9N",
//                "longitude": "140.8W",
//                "latitudeNumeric": 17.9,
//                "longitudeNumeric": -140.8,

        baseUrl = "https://www.nhc.noaa.gov/storm_graphics/" + modBinNumber.replace("AL", "AT") + "/" + stormId.uppercased()
        goesUrl = "https://cdn.star.nesdis.noaa.gov/FLOATER/data/" + stormId.uppercased() + "/GEOCOLOR/latest.jpg"
    }
}
