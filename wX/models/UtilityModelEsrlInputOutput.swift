// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class UtilityModelEsrlInputOutput {

    static let pattern1 = "<option selected>([0-9]{2} \\w{3} [0-9]{4} - [0-9]{2}Z)<.option>"
    static let pattern2 = "<option>([0-9]{2} \\w{3} [0-9]{4} - [0-9]{2}Z)<.option>"
    static let pattern3 = "[0-9]{2} \\w{3} ([0-9]{4}) - [0-9]{2}Z"
    static let pattern4 = "([0-9]{2}) \\w{3} [0-9]{4} - [0-9]{2}Z"
    static let pattern5 = "[0-9]{2} \\w{3} [0-9]{4} - ([0-9]{2})Z"
    static let pattern6 = "[0-9]{2} (\\w{3}) [0-9]{4} - [0-9]{2}Z"

    static func getRunTime(_ om: ObjectModel) -> RunTimeData {
        let runData = RunTimeData()
        let htmlRunStatus: String
        switch om.model {
        case "HRRR_AK":
            htmlRunStatus = "https://rapidrefresh.noaa.gov/alaska/".getHtmlUtf8()
        case "RAP_NCEP":
            htmlRunStatus = ("https://rapidrefresh.noaa.gov/RAP/Welcome.cgi?dsKey=" + om.model.lowercased() + "_jet&domain=full").getHtmlUtf8()
        case "RAP":
            htmlRunStatus = "httpss://rapidrefresh.noaa.gov/RAP/".getHtmlUtf8()
        case "HRRR_NCEP":
            htmlRunStatus = ("https://rapidrefresh.noaa.gov/hrrr/HRRR/Welcome.cgi?dsKey=" + om.model.lowercased() + "_jet&domain=full").getHtmlUtf8()
        default:
            htmlRunStatus = ("https://rapidrefresh.noaa.gov/" + om.model.lowercased() + "/" + om.model + "/Welcome.cgi?dsKey=" + om.model.lowercased() + "_jet&domain=full").getHtmlUtf8()
        }
        var html = htmlRunStatus.parse(pattern1)
        let oldRunTimes = htmlRunStatus.parseColumn(pattern2)
        let year = html.parse(pattern3)
        let day = html.parse(pattern4)
        let hour = html.parse(pattern5)
        let monthStr = monthWordToNumber(html.parse(pattern6))
        html = year + monthStr + day + hour
        runData.appendListRun(html)
        runData.mostRecentRun = html
        runData.imageCompleteInt = UtilityString.parseAndCount(htmlRunStatus, ".(allfields).") - 1
        runData.imageCompleteStr = String(runData.imageCompleteInt)
        if html != "" {
            (0...12).forEach { index in
                let year = oldRunTimes[index].parse(pattern3)
                let day = oldRunTimes[index].parse(pattern4)
                let hour = oldRunTimes[index].parse(pattern5)
                let monthStr = monthWordToNumber(oldRunTimes[index].parse(pattern6))
                runData.appendListRun(year + monthStr + day + hour)
            }
            runData.timeStringConversion = html.parse("([0-9]{2})$")
        }
        return runData
    }

    static func getImage(_ om: ObjectModel) -> Bitmap {
        var parentModel = ""
        switch om.model {
        case "RAP_NCEP":
            parentModel = "RAP"
        case "HRRR_NCEP":
            parentModel = "HRRR"
        default:
            break
        }
        var imgUrl: String
        var onDemandUrl: String
        var sectorLocal = om.sector.replace(" ", "")
        sectorLocal = sectorLocal.replace("Full", "full")
        sectorLocal = sectorLocal.replace("CONUS", "conus")
        let param = om.param.replace("_full_", "_" + sectorLocal + "_")
        if parentModel.contains("RAP") {
            imgUrl = "https://rapidrefresh.noaa.gov/" + parentModel + "/for_web/" + om.model.lowercased()
                + "_jet/" + om.run.replaceAll("Z", "")+"/"+sectorLocal + "/" + param + "_f" + om.time + ".png"
            onDemandUrl = "https://rapidrefresh.noaa.gov/" + parentModel + "/" + "displayMapUpdated"
                + ".cgi?keys=" + om.model.lowercased() + "_jet:&runtime=" + om.run.replaceAll("Z", "")
                + "&plot_type=" + param + "&fcst=" + om.time
                + "&time_inc=60&num_times=16&model=" + om.model.lowercased()
                + "&ptitle=" + om.model + "%20Model%20Fields%20-%20Experimental&maxFcstLen=15&fcstStrLen=-1&domain="
                + sectorLocal + "&adtfn=1"
        } else {
            imgUrl = "https://rapidrefresh.noaa.gov/hrrr/" + parentModel.uppercased() + "/for_web/"
                + om.model.lowercased() + "_jet/"
                + om.run.replaceAll("Z", "") + "/"
                + sectorLocal + "/" + param + "_f" + om.time + ".png"
            onDemandUrl = "https://rapidrefresh.noaa.gov/hrrr/" + parentModel.uppercased()
                + "/" + "displayMapUpdated"
                + ".cgi?keys=" + om.model.lowercased()+"_jet:&runtime="
                + om.run.replaceAll("Z", "") + "&plot_type=" + param + "&fcst="
                + om.time + "&time_inc=60&num_times=16&model=" + om.model.lowercased()
                + "&ptitle=" + om.model + "%20Model%20Fields%20-%20Experimental&maxFcstLen=15&fcstStrLen=-1&domain="
                + sectorLocal + "&adtfn=1"
        }
        _ = onDemandUrl.getHtml()
        return Bitmap(imgUrl)
    }

    static func monthWordToNumber(_ month: String) -> String {
        month.replaceAll("Jan", "01")
            .replaceAll("Feb", "02")
            .replaceAll("Mar", "03")
            .replaceAll("Apr", "04")
            .replaceAll("May", "05")
            .replaceAll("Jun", "06")
            .replaceAll("Jul", "07")
            .replaceAll("Aug", "08")
            .replaceAll("Sep", "09")
            .replaceAll("Oct", "10")
            .replaceAll("Nov", "11")
            .replaceAll("Dec", "12")
    }
}
