// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class ObjectMetar {

    private let decodeIcon = true
    var condition = ""
    var temperature: String
    var dewPoint: String
    let windDirection: String
    var windSpeed: String
    var windGust: String
    var seaLevelPressure: String
    let visibility: String
    let relativeHumidity: String
    var windChill: String
    var heatIndex: String
    var conditionsTimeString = ""
    var timeStringUtc = ""
    var icon = ""
    private let metarSkyCondition: String
    private let metarWeatherCondition: String
    var obsClosest: Site

    init(_ location: LatLon, _ index: Int = 0) {
        obsClosest = Metar.findClosestObservation(location, index)
        if !decodeIcon {
            let observationData = ("https://api.weather.gov/stations/" + obsClosest.codeName + "/observations/current").getNwsHtml()
            icon = observationData.parseFirst("\"icon\": \"(.*?)\",")
            condition = observationData.parseFirst("\"textDescription\": \"(.*?)\",")
        }
        let metarData = (GlobalVariables.tgftpSitePrefix + "/data/observations/metar/decoded/" + obsClosest.codeName + ".TXT").getHtmlWithRetry(200)
        temperature = metarData.parseFirst("Temperature: (.*?) F")
        dewPoint = metarData.parseFirst("Dew Point: (.*?) F")
        windDirection = metarData.parseFirst("Wind: from the (.*?) \\(.*? degrees\\) at .*? MPH ")
        windSpeed = metarData.parseFirst("Wind: from the .*? \\(.*? degrees\\) at (.*?) MPH ")
        windGust = metarData.parseFirst("Wind: from the .*? \\(.*? degrees\\) at .*? " + "MPH \\(.*? KT\\) gusting to (.*?) MPH")
        seaLevelPressure = metarData.parseFirst("Pressure \\(altimeter\\): .*? in. Hg \\((.*?) hPa\\)")
        visibility = metarData.parseFirst("Visibility: (.*?) mile")
        relativeHumidity = metarData.parseFirst("Relative Humidity: (.*?)%")
        windChill = metarData.parseFirst("Windchill: (.*?) F")
        heatIndex = UtilityMath.heatIndex(temperature, relativeHumidity)
        // rawMetar = metarData.parseFirst("ob: (.*?)" + GlobalVariables.newline)
        metarSkyCondition = metarData.parseFirst("Sky conditions: (.*?)" + GlobalVariables.newline).capitalized
        metarWeatherCondition = metarData.parseFirst("Weather: (.*?)" + GlobalVariables.newline).capitalized
        if decodeIcon {
            if metarWeatherCondition == "" || metarWeatherCondition.contains("Inches Of Snow On Ground") {
                condition = metarSkyCondition
            } else {
                condition = metarWeatherCondition
            }
            condition = condition.replace("; Lightning Observed", "")
            condition = condition.replace("; Cumulonimbus Clouds, Lightning Observed", "")
            if condition == "Mist" {
                condition = "Fog/Mist"
            }
            icon = decodeIconFromMetar(condition, obsClosest)
            condition = condition.replace(";", " and")
        }

        // METAR Condition Icon
        // SCT Partly Cloudy sct
        // FEW Mostly Clear few
        // OVC Overcast (Cloudy) ovc
        // CLR Clear skc
        // -RA BR Overcast Light Rain; Mist (Light Rain and Fog/Mist)  rain
        // -SN BR Obscured Light Snow; Mist (Light Snow) snow

        let metarDataList = metarData.split(GlobalVariables.newline)
        if metarDataList.count > 2 {
            let localStatus = metarDataList[1].split("/")
            if localStatus.count > 1 {
                conditionsTimeString = ObjectDateTime.convertFromUTCForMetar(localStatus[1].replace(" UTC", ""))
                timeStringUtc = localStatus[1].trim()
            }
        }
        seaLevelPressure = changePressureUnits(seaLevelPressure)
        temperature = changeDegreeUnits(temperature)
        dewPoint = changeDegreeUnits(dewPoint)
        windChill = changeDegreeUnits(windChill)
        heatIndex = changeDegreeUnits(heatIndex)
        if windSpeed == "" {
            windSpeed = "0"
        }
        if condition == "" {
            condition = "NA"
        }
    }

    func changeDegreeUnits(_ value: String) -> String {
        if value != "" {
            let tempD = To.double(value)
            if UIPreferences.unitsF {
                return tempD.roundToString()
            } else {
                return UtilityMath.fahrenheitToCelsius(tempD)
            }
        } else {
            return "NA"
        }
    }

    func changePressureUnits(_ value: String) -> String {
        if !UIPreferences.unitsM {
            return UtilityMath.pressureMBtoIn(value)
        } else {
            return value + " mb"
        }
    }

    func decodeIconFromMetar(_ condition: String, _ obs: Site) -> String {
        // https://api.weather.gov/icons/land/day/ovc?size=medium
        let sunTimes = UtilityTimeSunMoon.getSunriseSunsetFromObs(obs)
        let currentTime = Date()
        let fallsBetween = (sunTimes.0 ... sunTimes.1).contains(currentTime)
        let currentTimeTomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        let fallsBetweenTomorrow = (sunTimes.0 ... sunTimes.1).contains(currentTimeTomorrow!)
        let timeOfDay = fallsBetween || fallsBetweenTomorrow ? "day" : "night"
        let conditionModified = condition.split(";")[0]
        let shortCondition = UtilityMetarConditions.iconFromCondition[conditionModified] ?? ""
        return GlobalVariables.nwsApiUrl + "/icons/land/" + timeOfDay + "/" + shortCondition + "?size=medium"
    }
}
