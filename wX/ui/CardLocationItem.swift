// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class CardLocationItem {

    private let tvCurrentConditions: Text

    init(
        _ box: VBox,
        _ location: ObjectLocation,
        _ gesture: GestureData
    ) {
        let name = location.name
        let observation = location.observation
        let latLon = location.latLon.prettyPrint()
        let details = "WFO: " + location.wfo + " Radar: " + location.radarSite + " (" + latLon + ")"
        let boxV = VBox()
        let tvName = TextLarge(0, name, ColorCompatibility.highlightText)
        let tvBottom = TextSmallGray(details)
        tvCurrentConditions = Text(observation, zeroSpacing: true)
        tvCurrentConditions.font = FontSize.small.size
        tvCurrentConditions.color = ColorCompatibility.label
        boxV.addWidget(tvName)
        boxV.addWidget(tvCurrentConditions)
        boxV.addWidget(tvBottom)
        let card = Card(boxV)
        box.addWidget(card)
        card.connect(gesture)
    }

    func setConditions(_ s: String) {
        tvCurrentConditions.text = s
    }
}
