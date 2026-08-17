// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class MyApplication {

    static func onCreate() {
        initPreferences()
        Metar.initialize()
        RadarGeometry.initialize()
        GeographyType.regen()
        if Utility.readPref("LOC1_LABEL", "") == "" {
            UtilityStorePreferences.setDefaults()
        }
        Location.refresh()
    }

    static func initPreferences() {
        RadarPreferences.initialize()
        UIPreferences.initialize()
//        Location.setCurrentLocationStr(Utility.readPref("CURRENT_LOC_FRAGMENT", "1"))
        AppColors.update()
        ColorPalettes.initialize()
    }
}
