// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class CardPlayListItem {

    init(
        _ box: VBox,
        _ product: String,
        _ middleLine: String,
        _ bottomLines: String,
        _ gesture: GestureData
    ) {
        let tvProduct = TextLarge(0, product, ColorCompatibility.highlightText)
        let tvMiddle = Text(middleLine)
        let tvBottom = TextSmallGray(bottomLines.replaceAll(GlobalVariables.newline, " "))
        let boxV = VBox(tvProduct, tvMiddle, tvBottom)
        box.addWidget(Card(boxV))
        boxV.connect(gesture)
    }
}
