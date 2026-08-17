// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class CardDashAlertItem: Widget {

    private let card: Card

    init(
        _ warning: ObjectWarning,
        _ gesture: GestureData,
        _ gestureRadar: GestureData,
        _ gestureRadarText: GestureData
    ) {
        let tvName = TextLarge(80, warning.sender, ColorCompatibility.highlightText)
        tvName.constrain()
        let tvTitle = Text(warning.event)
        let tvStart = Text("Start: " + warning.effective.replace("T", " ").replaceAllRegexp(":00-0[0-9]:00", ""))
        let tvEnd = Text("End: " + warning.expires.replace("T", " ").replaceAllRegexp(":00-0[0-9]:00", ""))
        let tvArea = TextSmallGray(warning.area)
        tvName.isAccessibilityElement = false
        tvTitle.isAccessibilityElement = false
        tvStart.isAccessibilityElement = false
        tvEnd.isAccessibilityElement = false
        tvArea.isAccessibilityElement = false
        // icons
        let radarIcon = ToolbarIcon(.radar, gestureRadar)
        let radarText = Text("Radar")
        radarText.connect(gestureRadarText)
        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        let boxH = HBox(.fillProportionally, 10, [radarIcon, radarText])
        boxH.alignment = .center
        boxH.addWidget(spacerView)
        // end icons
        let boxV = VBox(tvName, tvTitle, tvStart, tvEnd, tvArea)
        boxV.addLayout(boxH)
        if warning.sender == "" {
            tvName.isHidden = true
        }
        if warning.expires == "" {
            tvEnd.isHidden = true
        }
        boxV.isAccessibilityElement = true
        card = Card(boxV)
        card.connect(gesture)
    }

    func getView() -> UIView {
        card.getView()
    }

    @objc func showRadar() {}
}
