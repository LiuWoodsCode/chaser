// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class UtilityLocationFragment {

    static let nws7dayTemp1 = "with a low around (-?[0-9]{1,3})\\."
    static let nws7dayTemp2 = "with a high near (-?[0-9]{1,3})\\."
    static let nws7dayTemp3 = "teady temperature around (-?[0-9]{1,3})\\."
    static let nws7dayTemp4 = "Low around (-?[0-9]{1,3})\\."
    static let nws7dayTemp5 = "High near (-?[0-9]{1,3})\\."
    static let nws7dayTemp6 = "emperature falling to around (-?[0-9]{1,3}) "
    static let nws7dayTemp7 = "emperature rising to around (-?[0-9]{1,3}) "
    static let nws7dayTemp8 = "emperature falling to near (-?[0-9]{1,3}) "
    static let nws7dayTemp9 = "emperature rising to near (-?[0-9]{1,3}) "
    static let nws7dayTemp10 = "High near (-?[0-9]{1,3}),"
    static let nws7dayTemp11 = "Low around (-?[0-9]{1,3}),"
    static let sevenDayWind1 = "wind ([0-9]*) to ([0-9]*) mph"
    static let sevenDayWind2 = "wind around ([0-9]*) mph"
    static let sevenDayWind3 = "with gusts as high as ([0-9]*) mph"
    static let sevenDayWind4 = " ([0-9]*) to ([0-9]*) mph after"
    static let sevenDayWind5 = " around ([0-9]*) mph after "
    static let sevenDayWind6 = " ([0-9]*) to ([0-9]*) mph in "
    static let sevenDayWind7 = "around ([0-9]*) mph"
    static let sevenDayWind8 = "Winds could gust as high as ([0-9]*) mph\\."
    static let sevenDayWind9 = " ([0-9]*) to ([0-9]*) mph."

    static func extract7DayMetrics(_ chunk: String) -> String {
        let spacing = " "
        // wind 24 to 29 mph
        let wind = chunk.parseMultiple(sevenDayWind1)
        // wind around 9 mph
        let wind2 = chunk.parse(sevenDayWind2)
        // 5 to 10 mph after
        let wind3 = chunk.parseMultiple(sevenDayWind4)
        // around 5 mph after
        let wind4 = chunk.parse(sevenDayWind5)
        // 5 to 7 mph in
        let wind5 = chunk.parseMultiple(sevenDayWind6)
        // around 6 mph.
        let wind7 = chunk.parse(sevenDayWind7)
        // with gusts as high as 21 mph
        var gust = chunk.parse(sevenDayWind3)
        // 5 to 7 mph.
        let wind9 = chunk.parseMultiple(sevenDayWind9)
        // Winds could gusts as high as 21 mph.
        if gust == "" { gust = chunk.parse(sevenDayWind8) }
        if gust != "" {
            gust = " G " + gust + " mph"
        } else {
            gust = " mph"
        }
        if wind.count > 1 {
            return spacing + wind[0] + "-" + wind[1] + gust
        } else if wind2 != "" {
            return spacing + wind2 + gust
        } else if wind3.count > 1 {
            return spacing + wind3[0] + "-" + wind3[1] + gust
        } else if wind4 != "" {
            return spacing + wind4 + gust
        } else if wind5.count > 1 {
            return spacing + wind5[0] + "-" + wind5[1] + gust
        } else if wind7 != "" {
            return spacing + wind7 + gust
        } else if wind9.count > 1 {
            return spacing + wind9[0] + "-" + wind9[1] + gust
        } else {
            return ""
        }
    }

    static let windDir = [
        "north": "N",
        "north northeast": "NNE",
        "northeast": "NE",
        "east northeast": "ENE",
        "east": "E",
        "east southeast": "ESE",
        "south southeast": "SSE",
        "southeast": "SE",
        "south": "S",
        "south southwest": "SSW",
        "southwest": "SW",
        "west southwest": "WSW",
        "west": "W",
        "west northwest": "WNW",
        "northwest": "NW",
        "north northwest": "NNW"
    ]

    static let windCodeToLong = [
        "N": "north",
        "NNE": "north northeast",
        "NE": "northeast",
        "ENE": "east northeast",
        "E": "east",
        "ESE": "east southeast",
        "SSE": "south southeast",
        "SE": "southeast",
        "S": "south",
        "SSW": "south southwest",
        "SW": "southwest",
        "WSW": "west southwest",
        "W": "west",
        "WNW": "west northwest",
        "NW": "northwest",
        "NNW": "north northwest"
    ]

    static func windCodeToSpoken(_ code: String) -> String {
        windCodeToLong[code] ?? ""
    }

    static let patterns = [
        "Light (.*?) wind increasing",
        "Breezy, with a[n]? (.*?) wind",
        "wind becoming (\\w+\\s?\\w*) around",
        "wind becoming (.*?) [0-9]",
        "\\. (\\w+\\s?\\w*) wind ",
        "Windy, with an? (.*?) wind",
        "Blustery, with an? (.*?) wind",
        "Light (.*?) wind"
    ]

    static func extractWindDirection(_ chunk: String) -> String {
        var windResults = [String]()
        patterns.forEach { windResults.append(chunk.parseLastMatch($0)) }
        var retStr = ""
        for windToken in windResults where windToken != "" {
            retStr = windToken
            break
        }
        if retStr == "" {
            return ""
        } else {
            if let ret = windDir[retStr.lowercased()] {
                return " " + ret + ""
            } else {
                return ""
            }
        }
    }

    static func extractTemp(_ blob: String) -> String {
        let regexps = [
            nws7dayTemp1,
            nws7dayTemp2,
            nws7dayTemp3,
            nws7dayTemp4,
            nws7dayTemp5,
            nws7dayTemp6,
            nws7dayTemp7,
            nws7dayTemp8,
            nws7dayTemp9,
            nws7dayTemp10,
            nws7dayTemp11
        ]
        for regexp in regexps {
            let temp = blob.parse(regexp)
            if temp != "" {
                // return temp
                if UIPreferences.unitsF {
                    return temp
                } else {
                    return UtilityMath.fahrenheitToCelsius(To.double(temp))
                }
            }
        }
        return ""
    }
}
