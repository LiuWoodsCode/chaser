// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class CardHazard {

    init(_ box: CardHomeScreen, _ hazard: String, _ gesture: GestureData) {
        let text = Text(box, hazard.uppercased(), FontSize.extraLarge.size, ColorCompatibility.highlightText)
        text.connect(gesture)
        text.isSelectable = false
    }
}
