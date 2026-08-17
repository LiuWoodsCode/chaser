// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class UtilityHourlyOldApi {

    static let regexpList = [
        "<temperature type=.hourly.*?>(.*?)</temperature>",
        "<temperature type=.dew point.*?>(.*?)</temperature>",
        "<time-layout.*?>(.*?)</time-layout>",
        "<probability-of-precipitation.*?>(.*?)</probability-of-precipitation>",
        "<cloud-amount type=.total.*?>(.*?)</cloud-amount>"
    ]

    static func getHourlyString(_ locNumber: Int) -> String {
        let latLon = Location.getLatLon(locNumber)
        let html = UtilityDownloadNws.getHourlyOldData(latLon)
        let header = "Time".ljust(10) + " " + "Temp".ljust(7) + "Dew".ljust(5) + "Precip%".ljust(7) + "Cloud%".ljust(6) + GlobalVariables.newline
        return GlobalVariables.newline + header + parseHourly(html)
    }

    static func parseHourly(_ html: String) -> String {
        let rawData = UtilityString.parseXmlExt(regexpList, html)
        let temp2List = UtilityString.parseXmlValue(rawData[0])
        let temp3List = UtilityString.parseXmlValue(rawData[1])
        let time2List = UtilityString.parseXml(rawData[2], "start-valid-time")
        let temp4List = UtilityString.parseXmlValue(rawData[3])
        let temp5List = UtilityString.parseXmlValue(rawData[4])
        var sb = ""
        let temp2Len = temp2List.count
        let temp3Len = temp3List.count
        let temp4Len = temp4List.count
        let temp5Len = temp5List.count
        for j in 1..<temp2Len {
            var temp3Val = "."
            var temp4Val = "."
            var temp5Val = "."
            if temp2Len == temp3Len {
               temp3Val = temp3List[j]
            }
            if temp2Len == temp4Len {
               temp4Val = temp4List[j]
            }
            if temp2Len == temp5Len {
               temp5Val = temp5List[j]
            }
            let time = ObjectDateTime.translateTimeForHourly(time2List[j])
            sb += time.ljust(8)
            sb += "   "
            sb += temp2List[j].ljust(7)
            sb += temp3Val.ljust(5)
            sb += temp4Val.ljust(6)
            sb += temp5Val.ljust(6)
            sb += GlobalVariables.newline
        }
        return sb
    }
}
