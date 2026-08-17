// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class UtilitySpcStormReports {

    static func process(_ lines: [String]) -> [StormReport] {
        var stormReports = [StormReport]()
        lines.forEach { line in
            var lat = ""
            var lon = ""
            var state = ""
            var time = ""
            var address = ""
            var damageReport = ""
            var magnitude = ""
            var city = ""
            var damageHeader = ""
            if line.contains(",F_Scale,") {
                damageHeader = "Tornado Reports"
            } else if line.contains(",Speed,") {
                damageHeader = "Wind Reports"
            } else if line.contains(",Size,") {
                damageHeader = "Hail Reports"
            } else {
                let lineChunks = line.split(",")
                if lineChunks.count > 7 {
                    time = lineChunks[0]
                    magnitude = lineChunks[1]
                    address = lineChunks[2]
                    city = lineChunks[3]
                    state = lineChunks[4]
                    lat = lineChunks[5]
                    lon = lineChunks[6]
                    damageReport = lineChunks[7]
                }
            }
            stormReports.append(StormReport(lat, lon, time, magnitude, address, city, state, damageReport, damageHeader))
        }
        return stormReports
    }
}
