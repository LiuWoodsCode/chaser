// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class CardAlertDetail {

    init(
        _ uiv: UIwXViewController,
        _ box: VBox,
        _ wfo: String,
        _ wfoName: String,
        _ alert: CapAlert,
        _ radarSite: String
    ) {
        // start icons
        let radarIcon = ToolbarIcon(.radar, GestureData(radarSite, uiv, #selector(goToRadar)))
        let radarText = Text("Radar")
        radarText.connect(GestureData(radarSite, uiv, #selector(goToRadar)))
        radarText.isSelectable = false
        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        let boxH = HBox(.fillProportionally, 10, [radarIcon, radarText])
        boxH.alignment = .center
        boxH.addWidget(spacerView)
        // end icons
        let (title, startTime, endTime) = AlertDetail.condenseTime(alert)
        let tvName = TextLarge(0, wfo + " (" + wfoName + ")", ColorCompatibility.highlightText)
        let tvTitle = Text(title)
        let tvStart = Text("Start: " + startTime)
        let tvEnd = Text("End: " + endTime)
        let tvArea = TextSmallGray(alert.area)
        tvName.isAccessibilityElement = false
        tvTitle.isAccessibilityElement = false
        tvStart.isAccessibilityElement = false
        tvEnd.isAccessibilityElement = false
        tvArea.isAccessibilityElement = false
        let boxV = VBox(tvName, tvTitle, tvStart, tvEnd, tvArea)
        boxV.addLayout(boxH)
        if wfoName == "" {
            tvName.isHidden = true
        }
        if endTime == "" {
            tvEnd.isHidden = true
        }
        if radarSite == "" {
            boxH.isHidden = true
        }
        boxV.isAccessibilityElement = true
        boxV.accessibilityLabel = title + "Start: " + startTime + "End: " + endTime + alert.area
        let card = Card(boxV)
        box.addWidget(card)
        card.connect(GestureData(alert.url, uiv, #selector(warningSelected)))
    }

    @objc func warningSelected(sender: GestureData) {}

    @objc func goToRadar(sender: GestureData) {}
}
