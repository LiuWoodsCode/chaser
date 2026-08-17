// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class CardBlackHeaderText {

    init(_ box: VBox, _ text: String) {
        let textLarge = TextLarge(80, text, UIColor.white)
        textLarge.background = UIColor.black
        textLarge.font = FontSize.extraLarge.size
        let card = Card(textLarge)
        card.color = UIColor.black
        box.addWidget(card)
    }
}
