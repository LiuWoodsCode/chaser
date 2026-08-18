// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class SevenDayCollection {

    private let uiScrollView: UIScrollView
    var sevenDayCards = [CardSevenDay]()
    // used on the main screen to see if location has been changed
    var locationIndex = 0
    var cardSunRise: CardSunRise?

    init(_ box: VBox, _ scrollView: UIScrollView, _ sevenDay: SevenDay, useHomeScreenRedesign: Bool = false) {
        uiScrollView = scrollView
        let card = CardHomeScreen()
        box.addLayout(card)
        card.setupWithPadding(box, redesign: useHomeScreenRedesign)
        let days = sevenDay.forecastList
        let daysShort = sevenDay.forecastListCondensed
        days.indices.forEach { index in
            if days[index] != "" {
                let cardSevenDay = CardSevenDay(
                    card,
                    index,
                    sevenDay.icons,
                    days,
                    daysShort,
                    useHomeScreenRedesign: useHomeScreenRedesign
                )
                cardSevenDay.connect(
                    GestureData(self, #selector(sevenDayAction)),
                    GestureData(self, #selector(sevenDayAction))
                )
                sevenDayCards.append(cardSevenDay)
            }
        }
        if Location.isUS {
            cardSunRise = CardSunRise(card, sevenDay.latLon, GestureData(self, #selector(sevenDayAction)))
        }
    }

    func resetTextSize() {
        sevenDayCards.forEach {
            $0.resetTextSize()
        }
        cardSunRise?.resetTextSize()
    }

    func update(_ sevenDay: SevenDay) {
        let days = sevenDay.forecastList
        let daysShort = sevenDay.forecastListCondensed
        days.indices.forEach { index in
            if days[index] != "" {
                if sevenDayCards.count > index {
                    sevenDayCards[index].update(index, sevenDay.icons, days, daysShort)
                }
            }
        }
    }

    @objc func sevenDayAction() {
        uiScrollView.scrollToTop()
    }
}
