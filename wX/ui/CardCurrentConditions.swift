// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class CardCurrentConditions {

    private let cardImage: CardImage
    private let topText = TextLarge(80)
    private let middleText = TextSmallGray()
    private let condenseScale: CGFloat = 0.50
    private let card: Card

    init(_ box: VBox, _ currentConditions: CurrentConditions) {
        if UIPreferences.mainScreenCondense {
            cardImage = CardImage(sizeFactor: condenseScale)
        } else {
            cardImage = CardImage(sizeFactor: 1.0)
        }
        let boxV = VBox(topText, middleText)
        boxV.alignment = .top
        topText.isAccessibilityElement = false
        middleText.isAccessibilityElement = false
        card = Card([cardImage.getView(), boxV.get()])
        card.isAccessibilityElement = true
        box.addWidget(card)
        card.constrain(box)
        let padding = CGFloat(-1 * UIPreferences.nwsIconSize - 6)
        boxV.constrain(box, padding)
        update(currentConditions)
    }

    func update(_ currentConditions: CurrentConditions) {
        setImage(currentConditions)
        setText(currentConditions)
    }

    private func setImage(_ currentConditions: CurrentConditions) {
        if Location.isUS {
            let bitmap = UtilityForecastIcon.getIcon(currentConditions.iconUrl)
            if !UIPreferences.mainScreenCondense {
                cardImage.setBitmap(bitmap)
            } else {
                cardImage.setImage(UtilityImg.resizeImage(bitmap.image, condenseScale))
            }
        }
    }

    private func setText(_ currentConditions: CurrentConditions) {
        topText.text = currentConditions.topLine.trimnl()
        middleText.text = currentConditions.middleLine.trim()
        card.accessibilityLabel = currentConditions.spokenText
    }

    func resetTextSize() {
        topText.resetTextSize()
        middleText.resetTextSize()
    }

    func connect(_ gesture1: GestureData, _ gesture2: GestureData, _ gesture3: GestureData) {
        cardImage.connect(gesture1)
        topText.connect(gesture2)
        middleText.connect(gesture3)
    }
}
