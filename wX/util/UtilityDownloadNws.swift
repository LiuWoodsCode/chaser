// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class UtilityDownloadNws {

    static func getCap(_ sector: String) -> String {
        if sector == "us" {
            return getStringFromUrlXml("https://api.weather.gov/alerts/active?region_type=land")
        } else {
            return getStringFromUrlXml("https://api.weather.gov/alerts/active?state=" + sector.uppercased())
        }
    }

    static func getStringFromUrl(_ url: String) -> String {
        UtilityLog.d("UtilityDownloadNws.getStringFromUrl: " + url)
        let myJustDefaults = JustSessionDefaults(headers: ["User-Agent": "IOS "
            + GlobalVariables.appName
            + " " + GlobalVariables.appCreatorEmail])
        let just = JustOf<HTTP>(defaults: myJustDefaults)
        let result = just.get(url)
        return result.text ?? ""

        // https://github.com/JustHTTP/Just
        // http://docs.justhttp.net/QuickStart.html
        // is the request successful?
        // r.ok
        // r.statusCode
        // what did the server return?
        // r.headers       // response headers
        // r.content       // response body as NSData?
        // r.text          // response body as text?
        // r.json          // response body parsed by NSJSONSerielization
        // r.url           // the URL, as NSURL
        // r.isRedirect    // is this a redirect response
    }

    static func getStringFromUrlXml(_ url: String) -> String {
        UtilityLog.d("UtilityDownloadNws.getStringFromUrlXml: " + url)
        let myJustDefaults = JustSessionDefaults(
            headers: [
                "User-Agent": "IOS " + GlobalVariables.appName + " " + GlobalVariables.appCreatorEmail,
                "Accept": "application/atom+xml"
            ]
        )
        let just = JustOf<HTTP>(defaults: myJustDefaults)
        let result = just.get(url)
        return result.text ?? ""
    }

    static func getHourlyData(_ latLon: LatLon) -> String {
        let pointsData = getLocationPointData(latLon)
        let hourlyUrl = pointsData.parse("\"forecastHourly\": \"(.*?)\"")
        return hourlyUrl.getNwsHtmlWithRetry(1000)
    }

    static func getHourlyOldData(_ latLon: LatLon) -> String {
        return UtilityIO.getHtml("https://forecast.weather.gov/MapClick.php?lat=" +
                                 latLon.latForNws + "&lon=" +
                                 latLon.lonForNws + "&FcstType=digitalDWML")
    }

    static func get7DayData(_ latLon: LatLon) -> String {
        if UIPreferences.useNwsApi {
            let pointsData = getLocationPointData(latLon)
            let forecastUrl = pointsData.parse("\"forecast\": \"(.*?)\"")
            return forecastUrl.getNwsHtmlWithRetry(3000)
        } else {
            return getLocationHtml(latLon)
        }
    }

    static func getLocationPointData(_ latLon: LatLon) -> String {
        (GlobalVariables.nwsApiUrl + "/points/" + latLon.latForNws + "," + latLon.lonForNws).getNwsHtml()
    }

    static func getLocationHtml(_ latLon: LatLon) -> String {
        let html = ("https://forecast.weather.gov/MapClick.php?lat=" + latLon.latForNws + "&lon=" + latLon.lonForNws + "&unit=0&lg=english&FcstType=dwml").getHtml()
        return html.replace("\n", " ")
    }
}
