// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class UtilityRadarMosaic {

    private static let baseUrl = "https://radar.weather.gov/ridge/standard/"

    static func getNearest(_ latLon: LatLon) -> String {
        UtilityLocation.getNearest(latLon, cityToLatLon)
    }

    static func get(_ sector: String) -> String {
        if sector == "CONUS" {
            return  baseUrl + "CONUS-LARGE_0.gif"
        }
        return baseUrl + sector + "_0.gif"
    }

    static func getAnimation(_ sector: String) -> AnimationDrawable {
        var returnList = [String]()
        var add = ""
        if sector == "CONUS" {
            add = "-LARGE"
        }
        stride(from: 9, to: 0, by: -1).forEach {
            returnList.append(baseUrl + sector + add + "_" + To.string($0) + ".gif")
        }
        return UtilityImgAnim.getAnimationDrawableFromUrlList(returnList)
    }

    static let sectors = [
        "CONUS",
        "ALASKA",
        "CARIB",
        "CENTGRLAKES",
        "GUAM",
        "HAWAII",
        "NORTHEAST",
        "NORTHROCKIES",
        "PACNORTHWEST",
        "PACSOUTHWEST",
        "SOUTHEAST",
        "SOUTHMISSVLY",
        "SOUTHPLAINS",
        "SOUTHROCKIES",
        "UPPERMISSVLY"
    ]

    static let labels = [
        "CONUS",
        "ALASKA",
        "CARIB",
        "CENTGRLAKES",
        "GUAM",
        "HAWAII",
        "NORTHEAST",
        "NORTHROCKIES",
        "PACNORTHWEST",
        "PACSOUTHWEST",
        "SOUTHEAST",
        "SOUTHMISSVLY",
        "SOUTHPLAINS",
        "SOUTHROCKIES",
        "UPPERMISSVLY"
    ]

    private static let cityToLatLon = [
        "ALASKA": LatLon(63.8683, -149.3669),
        "CARIB": LatLon(18.356, -69.592),
        "CENTGRLAKES": LatLon(42.4396, -84.7305),
        "GUAM": LatLon(13.4208, 144.7540),
        "HAWAII": LatLon(19.5910, -155.4343),
        "NORTHEAST": LatLon(42.7544, -73.4800),
        "NORTHROCKIES": LatLon(44.0813, -108.1309),
        "PACNORTHWEST": LatLon(43.1995, -118.9174),
        "PACSOUTHWEST": LatLon(35.8313, -119.2245),
        "SOUTHEAST": LatLon(30.2196, -82.1522),
        "SOUTHMISSVLY": LatLon(33.2541, -89.8034),
        "SOUTHPLAINS": LatLon(32.4484, -99.7781),
        "SOUTHROCKIES": LatLon(33.2210, -110.3162),
        "UPPERMISSVLY": LatLon(42.9304, -95.7488)
    ]
}
