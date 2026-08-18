// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class CardHazards {

    private static var uiv: UIViewController?

    static func get(_ uiv: UIViewController, _ box: VBox, _ hazards: Hazards, useHomeScreenRedesign: Bool = false) {
        CardHazards.uiv = uiv
        let card = CardHomeScreen()
        card.setupWithPadding(redesign: useHomeScreenRedesign)
        let ids = hazards.data.parseColumn("\"id\": \"(http.*?)\"")
        let hazardTitles = hazards.data.parseColumn("\"event\": \"(.*?)\"")
        hazardTitles.enumerated().forEach { index, hazard in
            _ = CardHazard(
                card,
                hazard,
                GestureData(ids[index], self, #selector(action(sender:)))
            )
        }
        if hazardTitles.count > 0 {
            box.isHidden = false
            box.addLayout(card)
        } else {
            box.isHidden = true
        }
    }

    @objc private static func action(sender: GestureData) {
        Route.alertDetail(uiv!, sender.strData)
    }
}
