// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class CardSevenDay {

    private let card: Card
    private let topText: TextLarge
    private let bottomText = TextSmallGray()
    private let cardImage: CardImage
    private let condenseScale: CGFloat = 0.50

    init(
        _ box: CardHomeScreen,
        _ index: Int,
        _ urls: [String],
        _ days: [String],
        _ daysShort: [String],
        useHomeScreenRedesign: Bool = false
    ) {
        topText = TextLarge(80, constrainToScreenWidth: !useHomeScreenRedesign)
        if UIPreferences.mainScreenCondense {
            cardImage = CardImage(sizeFactor: condenseScale)
        } else {
            cardImage = CardImage(sizeFactor: 1)
        }
        topText.get().setContentHuggingPriority(.defaultLow, for: .vertical)
        let boxV = VBox(topText, bottomText)
        bottomText.constrain(boxV)
        boxV.alignment = .top
        topText.isAccessibilityElement = false
        bottomText.isAccessibilityElement = false
        card = Card([cardImage.getView(), boxV.get()])
        card.isAccessibilityElement = true
        box.addWidget(card)
        card.constrain(box)
        let padding = CGFloat(-1.0 * UIPreferences.nwsIconSize - 6)
        boxV.constrain(box, padding)
        update(index, urls, days, daysShort)
    }

    func update(_ index: Int, _ urls: [String], _ days: [String], _ daysShort: [String]) {
        setImage(index, urls)
        setTextFields(format(days[index].replace("</text>", ""), daysShort[index].replace("</text>", "")))
    }

    private func setTextFields(_ labels: (top: String, bottom: String)) {
        topText.text = labels.top.replace("\"", "")
        bottomText.text = labels.bottom.trimnl()
        card.accessibilityLabel = labels.top + labels.bottom.trimnl()
    }

    func resetTextSize() {
        topText.resetTextSize()
        bottomText.resetTextSize()
    }

    private func setImage(_ index: Int, _ urls: [String]) {
        if urls.count > index {
            if !UIPreferences.mainScreenCondense {
                cardImage.setBitmap(UtilityForecastIcon.getIcon(urls[index]))
            } else {
                cardImage.setImage(UtilityImg.resizeImage(UtilityForecastIcon.getIcon(urls[index]).image, condenseScale))
            }
        }
    }

    private func format(_ dayStr: String, _ dayStrShort: String) -> (String, String) {
        let items = dayStr.split(": ")
        let itemsShort = dayStrShort.split(": ")
        let s: String
        if !UIPreferences.mainScreenCondense || !Location.isUS {
            if items.count > 1 {
                if Location.isUS {
                    s = items[0].replace(":", " ") + " (" + UtilityLocationFragment.extractTemp(items[1])
                        + GlobalVariables.degreeSymbol
                        + UtilityLocationFragment.extractWindDirection(items[1].substring(1))
                        + UtilityLocationFragment.extract7DayMetrics(items[1].substring(1))
                        + ")" + GlobalVariables.newline
                } else {
                    s = items[0].replace(":", " ") + " (" + GlobalVariables.degreeSymbol + ")" + GlobalVariables.newline
                }
                return (s, items[1])
            } else {
                return ("", "")
            }
        } else {
            if itemsShort.count > 1 {
                if Location.isUS {
                    s = items[0].replace(":", " ") + " (" + UtilityLocationFragment.extractTemp(items[1])
                        + GlobalVariables.degreeSymbol
                        + UtilityLocationFragment.extractWindDirection(items[1].substring(1))
                        + UtilityLocationFragment.extract7DayMetrics(items[1].substring(1))
                        + ")" + GlobalVariables.newline
                } else {
                    s = items[0].replace(":", " ") + " (" + GlobalVariables.degreeSymbol + ")" + GlobalVariables.newline
                }
                return (s, itemsShort[1])
            } else {
                return ("", "")
            }
        }
    }

    func connect(_ gesture1: GestureData, _ gesture2: GestureData) {
        card.connect(gesture1)
        bottomText.connect(gesture2)
    }
}
