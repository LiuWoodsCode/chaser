// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class UtilityHourly {

    static let abbreviations = [
        "Showers And Thunderstorms": "Sh/Tst",
        "Chance": "Chc",
        "Slight": "Slt",
        "Light": "Lgt",
        "Scattered": "Sct",
        "Rain": "Rn",
        "Snow": "Sn",
        "Rn And Sn": "Rn/Sn",
        "Freezing": "Frz",
        "Drizzle": "Dz",
        "Isolated": "Iso",
        "Likely": "Lkly",
        "T-storms": "Tst",
        "Showers": "Shwr",
        "Thunderstorms": "Tst"
    ]

    static func getFooter() -> String {
        var footer = GlobalVariables.newline
        abbreviations.keys.sorted().forEach { k in
            footer += abbreviations[k]! + ": " + k + GlobalVariables.newline
        }
        return footer
    }

    static func get(_ locationNumber: Int) -> [String] {
        if UIPreferences.useNwsApiForHourly {
            return UtilityHourly.getHourlyString(locationNumber)
        }
        let data = UtilityHourlyOldApi.getHourlyString(locationNumber)
        return [data, data]
    }

    static func getHourlyString(_ locationNumber: Int) -> [String] {
        let html = UtilityDownloadNws.getHourlyData(Location.getLatLon(locationNumber))
        var timePadding = 7
        if UIPreferences.hourlyShowAMPM {
            timePadding = 11
        }
        let header = "Time".ljust(timePadding) // was 7 before am/pm
            + "T".ljust(3)
            + "Wind".ljust(7)
            + "Dir".ljust(6)
            + GlobalVariables.newline
        let footer = getFooter()
        return [header + parse(html) + footer, html]
    }

    static func parse(_ html: String) -> String {
        let startTimes = html.parseColumn("\"startTime\": \"(.*?)\",")
        let temperatures = html.parseColumn("\"temperature\": (.*?),")
        let windSpeeds = html.parseColumn("\"windSpeed\": \"(.*?)\"")
        let windDirections = html.parseColumn("\"windDirection\": \"(.*?)\"")
        let shortForecasts = html.parseColumn("\"shortForecast\": \"(.*?)\"")
        var timePadding = 7
        if UIPreferences.hourlyShowAMPM {
            timePadding = 11
        }
        var s = ""
        startTimes.indices.forEach { index in
            let time = ObjectDateTime.translateTimeForHourly(startTimes[index])
            let temperature = Utility.safeGet(temperatures, index).replace("\"", "")
            let windSpeed = Utility.safeGet(windSpeeds, index).replace(" to ", "-")
            let windDirection = Utility.safeGet(windDirections, index)
            let shortForecast = Utility.safeGet(shortForecasts, index)
            s += time.fixedLengthString(timePadding)
            s += temperature.fixedLengthString(3)
            s += windSpeed.fixedLengthString(7)
            s += windDirection.fixedLengthString(4)
            s += shortenConditions(shortForecast).fixedLengthString(18)
            s += GlobalVariables.newline
        }
        return s
    }

    static func shortenConditions(_ string: String) -> String {
        var hourly = string
        abbreviations.keys.sorted().forEach { k in
            hourly = hourly.replaceAll(k, abbreviations[k]!)
        }
        return hourly
    }
}
