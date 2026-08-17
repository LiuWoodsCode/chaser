// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class CardNhcStormReportItem: Widget {

    private let card: Card

    init(_ stormData: NhcStormDetails, _ gesture: GestureData) {
        let textViewTop = TextLarge(80,
            stormData.name + " (" + stormData.classification + ") " + stormData.center,
            ColorCompatibility.highlightText
        )
        let textViewTime = Text(stormData.dateTime.replaceAll("T", " ").replaceAll(":00.000Z", "Z"))
        let textViewMovement = Text("Moving: " + stormData.movement)
        let textViewPressure = Text("Min pressure: " + stormData.pressure + " mb")
        let textViewWindSpeed = Text("Max sustained: " + UtilityMath.knotsToMph(stormData.intensity) + " mph")
        let textViewBottom = TextSmallGray(stormData.status + " " + stormData.binNumber + " " + stormData.stormId.uppercased())
        [textViewTime, textViewMovement, textViewPressure, textViewWindSpeed].forEach {
            $0.isAccessibilityElement = false
        }
        textViewTop.isAccessibilityElement = false
        textViewBottom.isAccessibilityElement = false
        let vbox = VBox(
            textViewTop,
            textViewTime,
            textViewMovement,
            textViewPressure,
            textViewWindSpeed,
            textViewBottom
        )
        vbox.isAccessibilityElement = true
        card = Card(vbox)
        card.connect(gesture)
    }

    func getView() -> UIView {
        card.getView()
    }
}
