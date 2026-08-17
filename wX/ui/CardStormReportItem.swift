// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class CardStormReportItem {

    init(_ box: VBox, _ stormReport: StormReport, _ gesture: GestureData) {
        let location = TextLarge(80, "", ColorCompatibility.highlightText)
        let address = TextLarge(80)
        let description = TextSmallGray()
        if stormReport.damageHeader == "" && stormReport.time != "" {
            location.text = stormReport.state + ", " + stormReport.city + " " + stormReport.time
            address.text = stormReport.address
            description.text = stormReport.magnitude + " - " + stormReport.damageReport
            let boxV = VBox(location, address, description)
            let card = Card(boxV)
            box.addWidget(card)
            card.connect(gesture)
        }
    }
}
