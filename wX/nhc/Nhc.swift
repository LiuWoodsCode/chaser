// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class Nhc {

    var stormDataList = [NhcStormDetails]()
    private var ids = [String]()
    private var binNumbers = [String]()
    private var names = [String]()
    private var classifications = [String]()
    private var intensities = [String]()
    private var pressures = [String]()
    private var latitudes = [String]()
    private var longitudes = [String]()
    private var movementDirs = [String]()
    private var movementSpeeds = [String]()
    private var lastUpdates = [String]()
    private var statusList = [String]()
    private var publicAdvisoriesChunk = [String]()
    private var forecastAdvisoriesChunk = [String]()
    private var forecastDiscussionsChunk = [String]()
    private var windSpeedProbabilitiesChunk = [String]()
    private var publicAdvisories = [String]()
    private var forecastAdvisories = [String]()
    private var forecastDiscussions = [String]()
    private var windSpeedProbabilities = [String]()
    private var urls = [String]()
    private var stormPrefixList = [String]()
    var regionMap = [NhcOceanEnum: NhcRegionSummary]()

    init() {
        NhcOceanEnum.allCases.forEach {
            regionMap[$0] = NhcRegionSummary($0)
        }
    }

    func getTextData() {
        statusList.removeAll()
        stormDataList.removeAll()
        let url = GlobalVariables.nwsNhcWebsitePrefix + "/CurrentStorms.json"
        // let url = "https://www.nhc.noaa.gov/productexamples/NHC_JSON_Sample.json"
        let html = url.getHtml()
        ids = html.parseColumn("\"id\": \"(.*?)\"")
        binNumbers = html.parseColumn("\"binNumber\": \"(.*?)\"")
        names = html.parseColumn("\"name\": \"(.*?)\"")
        classifications = html.parseColumn("\"classification\": \"(.*?)\"")
        intensities = html.parseColumn("\"intensity\": \"(.*?)\"")
        pressures = html.parseColumn("\"pressure\": \"(.*?)\"")
        urls = html.parseColumn("\"url\": \"(.*?)\"")
        // sample data not quoted for these two
        // intensities = html.parseColumn("\"intensity\": (.*?),");
        // pressures = html.parseColumn("\"pressure\": (.*?),");
        latitudes = html.parseColumn("\"latitude\": \"(.*?)\"")
        longitudes = html.parseColumn("\"longitude\": \"(.*?)\"")
        movementDirs = html.parseColumn("\"movementDir\": (.*?),")
        movementSpeeds = html.parseColumn("\"movementSpeed\": (.*?),")
        lastUpdates = html.parseColumn("\"lastUpdate\": \"(.*?)\"")
        publicAdvisoriesChunk = UtilityString.parseColumn(html, "\"publicAdvisory\": \\{(.*?)\\}")
        forecastAdvisoriesChunk = UtilityString.parseColumn(html, "\"forecastAdvisory\": \\{(.*?)\\}")
        forecastDiscussionsChunk = UtilityString.parseColumn(html, "\"forecastDiscussion\": \\{(.*?)\\}")
        windSpeedProbabilitiesChunk = UtilityString.parseColumn(html, "\"windSpeedProbabilities\": \\{(.*?)\\}")
        for chunk in publicAdvisoriesChunk {
            let token = UtilityString.parse(chunk, "\"url\": \"(.*?)\"")
            publicAdvisories.append(token)
        }
        for chunk in forecastAdvisoriesChunk {
            let token = UtilityString.parse(chunk, "\"url\": \"(.*?)\"")
            forecastAdvisories.append(token)
        }
        for chunk in forecastDiscussionsChunk {
            let token = UtilityString.parse(chunk, "\"url\": \"(.*?)\"")
            forecastDiscussions.append(token)
        }
        for chunk in windSpeedProbabilitiesChunk {
            let token = UtilityString.parse(chunk, "\"url\": \"(.*?)\"")
            windSpeedProbabilities.append(token)
        }
        for adv in publicAdvisories {
            let productToken = adv.split("/").last!.replace(".shtml", "")
            let text = DownloadText.byProduct(productToken)
            let status = text.replace("\n", " ").parseFirst("BULLETIN.*?" + ObjectDateTime.getYearString() + " (.*?)SUMMARY OF ")
            statusList.append(status)
        }
        let forecastDiscussions = html.parseColumn("\"forecastDiscussion\": \\{(.*?)\\}")
        forecastDiscussions.forEach {
            var nhcPrefix = "MIATCP"
            if $0.contains("/HFOTCD") {
                nhcPrefix = "HFOTCP"
            }
            stormPrefixList.append(nhcPrefix)
        }
    }

    func showTextData() {
        ids.indices.forEach { index in
            stormDataList.append(NhcStormDetails(
                names[index],
                movementDirs[index],
                movementSpeeds[index],
                pressures[index],
                binNumbers[index],
                ids[index],
                lastUpdates[index],
                classifications[index],
                latitudes[index],
                longitudes[index],
                intensities[index],
                Utility.safeGet(statusList, index),
//                statusList[index],
                stormPrefixList[index],
                Utility.safeGet(publicAdvisories, index)
//                Utility.safeGet(forecastAdvisories, index),
//                Utility.safeGet(forecastDiscussions, index),
//                Utility.safeGet(windSpeedProbabilities, index)
            ))
        }
    }
}
