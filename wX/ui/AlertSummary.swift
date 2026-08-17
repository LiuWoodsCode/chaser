// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class AlertSummary {

    private var urls = [String]()
    private var radarSites = [String]()

    convenience init(
        _ uiv: UIwXViewController,
        _ box: VBox,
        _ filter: String,
        _ capAlerts: [CapAlert],
        _ gesture: GestureData
    ) {
        self.init()
        let filterText = Text(box)
        filterText.connect(gesture)
        filterText.constrain(box)
        var index = 0
        var filterBool = true
        var filterLabel = ""
        var stateCountDict = [String: Int]()
        capAlerts.forEach { alert in
            if filter == "" {
                filterBool = (alert.title.contains("Tornado Warning") || alert.title.contains("Severe Thunderstorm Warning") || alert.title.contains("Flash Flood Warning"))
                filterLabel = "Tornado/ThunderStorm/FFW"
            } else {
                filterBool = alert.title.hasPrefix(filter)
                filterLabel = filter
            }
            if filterBool {
                let wfo: String
                let wfoName: String
                if alert.vtec.count > 15 {
                    wfo = alert.vtec.substring(8, 11)
                    wfoName = WfoSites.sites.byCode[wfo]!.fullName  // UtilityLocation.getWfoSiteName(wfo)
                    let state = wfoName.substring(0, 2)
                    if stateCountDict.keys.contains(state) {
                        stateCountDict[state] = (stateCountDict[state]! + 1)
                    } else {
                        stateCountDict[state] = 1
                    }
                } else {
                    wfo = ""
                    wfoName = ""
                }
                radarSites.append(alert.getClosestRadar())
                _ = CardAlertDetail(
                    uiv,
                    box,
                    wfo,
                    wfoName,
                    alert,
                    radarSites.last!
                )
                urls.append(alert.url)
                index += 1
            }
        }
        var stateCount = ""
        stateCountDict.forEach { state, count in
            stateCount += state + ": " + To.string(count) + "  "
        }
        filterText.text = "Total alerts: " + To.string(capAlerts.count) + GlobalVariables.newline + "Filter: " + filterLabel + "(" + To.string(index) + " total)" + GlobalVariables.newline + "State counts: " + stateCount
    }
}
