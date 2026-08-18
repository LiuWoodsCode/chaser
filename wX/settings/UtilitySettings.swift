// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class UtilitySettings {

    static func isRadarInHomeScreen() -> Bool {
        if UtilityHomeScreen.usesTwoPaneRedesign {
            let paneFavorites = UtilityHomeScreen.getPaneFavorites()
            return paneFavorites.left.contains("METAL-RADAR") || paneFavorites.right.contains("METAL-RADAR")
        }
        return UtilityHomeScreen.getFavorites().contains("METAL-RADAR")
    }
}
