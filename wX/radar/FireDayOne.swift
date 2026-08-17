// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class FireDayOne {

    private static let timer = DownloadTimer("FIRE")
    static var polygonBy = [String: [Double]]()
    static let colors = [
        "ELEV": Color.rgb(255, 128, 0),
        "CRIT": Color.rgb(255, 0, 0),
        "EXTM": Color.rgb(255, 128, 255)
    ]
    private static let threatList = [
        "ELEV",
        "CRIT",
        "EXTM"
    ]

    static func get() {
        if timer.isRefreshNeeded() {
            let mainHtml = "https://www.spc.noaa.gov/products/fire_wx/fwdy1.html".getHtml()
            // CLICK FOR <a href="/products/fire_wx/2025/250111_1200_day1pts.txt">DAY 1 FIREWX AREAL OUTLINE PRODUCT (KWNSPFWFD1)</a>
            let arealOutlineUrl = UtilityString.parse(
                mainHtml,
                "a href=.(/products/fire_wx/[0-9]{4}/[0-9]{6}_[0-9]{4}_day1pts.txt).>DAY 1 FIREWX AREAL OUTLINE PRODUCT"
            )
            let html = (GlobalVariables.nwsSPCwebsitePrefix + arealOutlineUrl).getHtml()
            let htmlChunk = html.parse("... CATEGORICAL ...(.*?&)&")
            //
            // each threat level will have a string of numbers, each string has lat lon pairs (no neg for lon, will be handled later)
            // seperated by ":" to support multiple polygons in the same string
            //
            threatList.forEach { threat in
                var data = ""
                let htmlList = htmlChunk.parseColumn(threat.substring(1) + "(.*?)[A-Z&]")
                var warningList = [Double]()
                htmlList.forEach { polygon in
                    let coordinates = polygon.parseColumn("([0-9]{8}).*?")
                    coordinates.forEach { data += LatLon($0).printSpaceSeparated() }
                    data += ":"
                    data = data.replace(" :", ":")
                }
                let polygons = data.split(":")
                //
                // for each polygon parse apart the numbers and then add even numbers to one list and odd numbers to the other list
                // from there transform into the normal dataset needed for drawing lines in the graphic renderer
                //
                if polygons.count > 1 {
                    polygons.forEach { polygon in
                        if polygon != "" {
                            let numbers = polygon.split(" ")
                            let x = numbers.enumerated().filter { index, _ in index & 1 == 0 }.map { _, value in To.double(value) }
                            let y = numbers.enumerated().filter { index, _ in index & 1 != 0 }.map { _, value in To.double(value) * -1.0 }
                            if x.count > 0 && y.count > 0 {
                                warningList += [x[0], y[0]]
                                (1..<x.count - 1).forEach { j in
                                    if x[j] < 99.0 {
                                        warningList += [x[j], y[j], x[j], y[j]]
                                    } else {
                                        warningList += [x[j - 1], y[j - 1], x[j + 1], y[j + 1]]
                                    }
                                }
                                warningList += [x[x.count - 1], y[x.count - 1]]
                            }
                            polygonBy[threat] = warningList
                        }
                    }
                } else {
                    polygonBy[threat] = []
                }
            }
        }
    }
}
