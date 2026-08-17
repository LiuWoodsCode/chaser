// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation
import UIKit

final class UtilityModelNsslWrfInputOutput {

    static let baseUrl = "https://cams.nssl.noaa.gov"

    static func getRunTime(_ om: ObjectModel) -> RunTimeData {
        let runData = RunTimeData()
        var modelCode = ""
        if om.model == "WRF" {
            modelCode = "wrf_nssl"
        } else if om.model == "WRF_3KM" {
            modelCode = "wrf_nssl_3km"
        } else if om.model == "HRRRV3" {
            modelCode = "hrrrv3"
        } else if om.model == "FV3" {
            modelCode = "fv3_nssl"
        }
        let htmlRunStatus = (baseUrl + "/?model=" + modelCode).getHtml()
        let html = htmlRunStatus.parse("\\{model: \"" + modelCode + "\",(rd: .[0-9]{8}\",rt: .[0-9]{4}\",)")
        let day = html.parse("rd:.(.*?),.*?").replaceAll("\"", "")
        let time = html.parse("rt:.(.*?)00.,.*?").replaceAll("\"", "")
        let mostRecentRun = day + time
        runData.appendListRun(mostRecentRun)
        runData.appendListRun(ObjectDateTime.generateModelRuns(mostRecentRun, 24, "yyyyMMddHH"))
        runData.mostRecentRun = mostRecentRun
        return runData
    }

    static func getImage(_ om: ObjectModel) -> Bitmap {
        let sectorIndex = UtilityModelNsslWrfInterface.sectorsLong.firstIndex(of: om.sector) ?? 0
        let sector = UtilityModelNsslWrfInterface.sectors[sectorIndex]
        let baseLayerUrl = "https://cams.nssl.noaa.gov/graphics/blank_maps/spc_" + sector + ".png"
        var modelPostfix = "_nssl"
        var model = om.model.lowercased()
        if om.model == "HRRRV3" {
            modelPostfix = ""
        }
        if om.model == "WRF_3KM" {
            model = "wrf_nssl_3km"
            modelPostfix = ""
        }
        let year = om.run.substring(0, 4)
        let month = om.run.substring(4, 6)
        let day = om.run.substring(6, 8)
        let hour = om.run.substring(8, 10)
        let url = baseUrl + "/graphics/models/" + model + modelPostfix + "/" + year + "/" + month
            + "/" + day + "/" + hour + "00/f0" + om.time + "00/" + om.param + ".spc_"
            + sector.lowercased() + ".f0" + om.time + "00.png"
        let baseLayer = Bitmap(baseLayerUrl)
        let prodLayer = Bitmap(url)
        return Bitmap(UtilityImg.mergeImages(prodLayer, baseLayer), addWhiteBg: true)
    }
}
