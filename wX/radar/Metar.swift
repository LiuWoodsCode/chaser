// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class Metar {

    static var sites: Sites!

    static func initialize() {
        var name = [String: String]()
        var lat = [String: String]()
        var lon = [String: String]()
        let lines = UtilityIO.rawFileToStringArray(R.Raw.obs_all)
        for line in lines {
            let items = line.trim().split(",")
            if items.count > 2 {
                name[items[0]] = items[1] + ", " + items[2]
                lat[items[0]] = items[3]
                lon[items[0]] = items[4]
            }
        }
        sites = Sites(name, lat, lon, false)
    }

    static func getStateMetarArrayForWXOGL(_ radarSite: String, _ fileStorage: FileStorage) {
        if fileStorage.obsDownloadTimer.isRefreshNeeded() || radarSite != fileStorage.obsOldRadarSite {
            var obsAl = [String]()
            var obsAlExt = [String]()
            var obsAlWb = [String]()
            var obsAlWbGust = [String]()
            var obsAlX = [Double]()
            var obsAlY = [Double]()
            var obsAlAviationColor = [Int]()
            fileStorage.obsOldRadarSite = radarSite
            let obsList = getNearbyObsSites(radarSite)
            // https://aviationweather.gov/data/api/#changes
            let html = ("https://www.aviationweather.gov/api/data/metar?ids=" + obsList).getHtml()
            let metars = condense(html.split(GlobalVariables.newline))
            metars.forEach { metar in
                var validWind = false
                var validWindGust = false
                if (metar.hasPrefix("K") || metar.hasPrefix("P") || metar.hasPrefix("T")) && !metar.contains("NIL") {
                    let metarItems = metar.split(" ")
                    let TDArr = metar.parse(".*? (M?../M?..) .*?").split("/")
                    let timeBlob = metarItems.count > 1 ? metarItems[1] : ""
                    var pressureBlob = metar.parse(".*? A([0-9]{4})")
                    var windBlob = metar.parse("AUTO ([0-9].*?KT) .*?")
                    if windBlob == "" {
                        windBlob = metar.parse("Z ([0-9].*?KT) .*?")
                    }
                    let conditionsBlob = metar.parse("SM (.*?) M?[0-9]{2}/")
                    var visBlob = metar.parse(" ([0-9].*?SM) ")
                    let visBlobArr = visBlob.split(" ")
                    let visBlobDisplay = visBlobArr[visBlobArr.count - 1]
                    visBlob = visBlobArr[visBlobArr.count - 1].replace("SM", "")
                    var visInt = 0
                    if visBlob.contains("/") {
                        visInt = 0
                    } else if visBlob != "" {
                        visInt = To.int(visBlob)
                    } else {
                        visInt = 20000
                    }
                    var ovcStr = conditionsBlob.parse("OVC([0-9]{3})")
                    var bknStr = conditionsBlob.parse("BKN([0-9]{3})")
                    var ovcInt = 100000
                    var bknInt = 100000
                    if ovcStr != "" {
                        ovcStr += "00"
                        ovcInt = To.int(ovcStr)
                    }
                    if bknStr != "" {
                        bknStr += "00"
                        bknInt = To.int(bknStr)
                    }
                    let lowestCig = bknInt < ovcInt ? bknInt : ovcInt
                    var aviationColor = Color.GREEN
                    if visInt > 5 && lowestCig > 3000 {
                        aviationColor = Color.GREEN
                    }
                    if (visInt >= 3 && visInt <= 5) || ( lowestCig >= 1000 && lowestCig <= 3000) {
                        aviationColor = Color.rgb(0, 100, 255)
                    }
                    if (visInt >= 1 && visInt < 3) || ( lowestCig >= 500 && lowestCig < 1000) {
                        aviationColor = Color.RED
                    }
                    if visInt < 1 || lowestCig < 500 {
                        aviationColor = Color.MAGENTA
                    }
                    if pressureBlob.count == 4 {
                        pressureBlob = pressureBlob.insert(pressureBlob.count - 2, ".")
                        pressureBlob = UtilityMath.unitsPressure(pressureBlob)
                    }
                    var windDir = ""
                    var windInKt = ""
                    var windGustInKt = ""
                    var windDirInt = 0
                    if windBlob.contains("KT") && windBlob.count == 7 {
                        validWind = true
                        windDir = windBlob.substring(0, 3)
                        windInKt = windBlob.substring(3, 5)
                        windDirInt = To.int(windDir)
                        windBlob = windDir + " (" + UtilityMath.bearingToDirection(windDirInt) + ") " + windInKt + " kt"
                    } else if windBlob.contains("KT") && windBlob.count == 10 {
                        validWind = true
                        validWindGust = true
                        windDir = windBlob.substring(0, 3)
                        windInKt = windBlob.substring(3, 5)
                        windGustInKt = windBlob.substring(6, 8)
                        windDirInt = To.int(windDir)
                        windBlob = windDir + " (" + UtilityMath.bearingToDirection(windDirInt) + ") " + windInKt + " G " + windGustInKt + " kt"
                    }
                    if TDArr.count > 1 {
                        var temperature = TDArr[0]
                        var dewPoint = TDArr[1]
                        temperature = UtilityMath.celsiusToFahrenheit(temperature.replace("M", "-")).replace(".0", "")
                        dewPoint = UtilityMath.celsiusToFahrenheit(dewPoint.replace("M", "-")).replace(".0", "")
                        let obsSite = metarItems[0]
                        var latlon = Metar.sites.byCode[obsSite]?.latLon ?? LatLon()
                        latlon.lonString = latlon.lonString.replace("-0", "-")
                        obsAl.append(latlon.latString + ":" + latlon.lonString + ":" + temperature + "/" + dewPoint)
                        obsAlExt.append(latlon.latString + ":" + latlon.lonString + ":" + temperature
                            + "/" + dewPoint + " (" + obsSite + ")" + GlobalVariables.newline + pressureBlob
                            + " - " + visBlobDisplay + GlobalVariables.newline + windBlob + GlobalVariables.newline
                            + conditionsBlob + GlobalVariables.newline + timeBlob)
                        if validWind {
                            obsAlWb.append(latlon.latString + ":" + latlon.lonString + ":" + windDir + ":" + windInKt)
                            obsAlX.append(latlon.lat)
                            obsAlY.append(latlon.lon * -1.0)
                            obsAlAviationColor.append(aviationColor)
                        }
                        if validWindGust {
                            obsAlWbGust.append(latlon.latString
                                + ":"
                                + latlon.lonString
                                + ":"
                                + windDir
                                + ":"
                                + windGustInKt)
                        }
                    }
                }
            }
            fileStorage.obsArr = obsAl
            fileStorage.obsArrExt = obsAlExt
            fileStorage.obsArrWb = obsAlWb
            fileStorage.obsArrWbGust = obsAlWbGust
            fileStorage.obsArrX = obsAlX
            fileStorage.obsArrY = obsAlY
            fileStorage.obsArrAviationColor = obsAlAviationColor
        }
    }

    static func findClosestMetar(_ site: Site) -> String {
        (GlobalVariables.tgftpSitePrefix + "/data/observations/metar/decoded/" + site.codeName + ".TXT").getHtml()
    }

    static func findClosestObservation(_ latLon: LatLon, _ order: Int = 0) -> Site {
        sites.getNearestSite(latLon, order)
    }

    //
    // Returns a comma separated list of the closest obs to a particular radar site
    // obs site must be within 200 miles of location
    // Used only within this class in one spot
    // Used for nexrad radar when obs site is turn on
    //
    static func getNearbyObsSites(_ radarSite: String) -> String {
        var obsListSb = ""
        let radarLatLon = RadarSites.getLatLon(radarSite)
        sites.sites.forEach { site in
            if LatLon.distance(radarLatLon, site.latLon) < 200.0 {
                obsListSb += site.codeName + ","
            }
        }
        return String(obsListSb.dropLast())
    }

    // used to condense a list of metar that contains multiple entries for one site,
    // newest is first so simply grab first/append
    private static func condense(_ list: [String]) -> [String] {
        var siteMap = [String: Bool]()
        var goodObsList = [String]()
        list.forEach {
            let line = $0.replace("METAR ", "").replace("SPECI ", "")
            let items = line.split(" ")
            if items.count > 3 {
                if siteMap[items[0]] != true {
                    siteMap[items[0]] = true
                    goodObsList.append(line)
                }
            }
        }
        return goodObsList
    }
}
