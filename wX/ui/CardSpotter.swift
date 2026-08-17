// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class CardSpotter {

    init(_ box: VBox, _ spotter: Spotter, _ gesture: GestureData) {
        let boxV = VBox()
        let topLine = spotter.lastName + ", " + spotter.firstName
        let textTopLine = Text(boxV, topLine)
        let textMiddleLine = Text(boxV, spotter.reportedAt)
        textTopLine.font = FontSize.medium.size
        textMiddleLine.font = FontSize.small.size
        textTopLine.color = ColorCompatibility.highlightText
        textMiddleLine.color = ColorCompatibility.label
        box.addWidget(Card(boxV))
        boxV.connect(gesture)
    }
}
