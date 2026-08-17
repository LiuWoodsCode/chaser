// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class SevenDay {

    var icons = [String]()
    private var shortForecasts = [String]()
    private var detailedForecasts = [String]()
    // used on the main screen to see if location has been changed
    var locationIndex = 0
    var latLon = LatLon()

    convenience init(_ latLon: LatLon) {
        self.init()
        self.latLon = latLon
        let html = UtilityDownloadNws.get7DayData(latLon)
        process(html)
    }

    func process(_ html: String) {
        if UIPreferences.useNwsApi {
            var forecasts = [Forecast]()
            let names = html.parseColumn("\"name\": \"(.*?)\",")
            let temperatures = html.parseColumn("\"temperature\": (.*?),")
            let windSpeeds = html.parseColumn("\"windSpeed\": \"(.*?)\",")
            let windDirections = html.parseColumn("\"windDirection\": \"(.*?)\",")
            let detailedLocalForecasts = html.parseColumn("\"detailedForecast\": \"(.*?)\"")
            icons = html.parseColumn("\"icon\": \"(.*?)\",")
            let shortLocalForecasts = html.parseColumn("\"shortForecast\": \"(.*?)\",")
            names.indices.forEach { index in
                let name = Utility.safeGet(names, index)
                let temperature = Utility.safeGet(temperatures, index)
                let windSpeed = Utility.safeGet(windSpeeds, index)
                let windDirection = Utility.safeGet(windDirections, index)
                let icon = Utility.safeGet(icons, index)
                let shortForecast = Utility.safeGet(shortLocalForecasts, index)
                let detailedForecast = Utility.safeGet(detailedLocalForecasts, index)
                forecasts.append(Forecast(name, temperature, windSpeed, windDirection, icon, shortForecast, detailedForecast))
            }
            forecasts.forEach { forecast in
                detailedForecasts.append(forecast.name + ": " + forecast.detailedForecast)
                shortForecasts.append(forecast.name + ": " + forecast.shortForecast)
            }
        } else {
            var forecasts = [Forecast]()
            let forecastStringList = UtilityUS.getCurrentConditionsUS(html)
            let forecastString = forecastStringList[1]
            let iconString = forecastStringList[0]
            let forecastStrings = forecastString.split("\n")
            icons = UtilityString.parseColumn(iconString, "<icon-link>(.*?)</icon-link>")
            var forecast = GlobalVariables.newline + GlobalVariables.newline
            forecastStrings.enumerated().forEach { index, s in
                if s != "" {
                    detailedForecasts.append(s.trim())
                    shortForecasts.append(s.trim())
                    forecast += s.trim()
                    forecast += GlobalVariables.newline + GlobalVariables.newline
                    // not in kotlin
                    let stringList = s.trim().split(":")
                    let time = stringList[0].replace("\"", "")
                    var fcst = " "
                    if stringList.count > 1 {
                        fcst = stringList[1]
                    }
                    let icon = Utility.safeGet(icons, index)
                    if fcst != " " {
                        forecasts.append(Forecast(time, "", "", "", icon, "short", fcst))
                    }
                }
            }
        }
    }

    var forecastList: [String] { detailedForecasts }

    var forecastListCondensed: [String] { shortForecasts }
}
