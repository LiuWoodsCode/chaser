// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class AppColors {

    static var primaryColorRed = 46.toColor()
    static var primaryColorGreen = 63.toColor()
    static var primaryColorBlue = 89.toColor()
    static var toolbarTextColor = UIColor.white
    static var primaryDarkBlueUIColor = Color.rgbToUIColor(0, 17, 43)
    static var primaryBackgroundBlueUIColor = ColorCompatibility.separator
    static var primaryColorFab = Color.rgbToUIColor(88, 121, 169)

    static func update() {
        var appColor = Utility.readPref("UI_THEME", "blue")
        if UITraitCollection.current.userInterfaceStyle == .dark {
            appColor = "darkMode"
        }
        switch appColor {
        case "darkMode":
            primaryColorRed = 10.toColor()
            primaryColorGreen = 10.toColor()
            primaryColorBlue = 10.toColor()
            primaryDarkBlueUIColor = Color.rgbToUIColor(0, 0, 0)
//            primaryBackgroundBlueUIColor = ColorCompatibility.separator
            primaryBackgroundBlueUIColor = UIColor.black
            primaryColorFab = Color.rgbToUIColor(30, 30, 30)
        case "black":
            primaryColorRed = 30.toColor()
            primaryColorGreen = 30.toColor()
            primaryColorBlue = 30.toColor()
            primaryDarkBlueUIColor = Color.rgbToUIColor(0, 0, 0)
            primaryBackgroundBlueUIColor = ColorCompatibility.separator
            primaryColorFab = Color.rgbToUIColor(100, 100, 100)
        case "green":
            primaryColorRed = 0.toColor()
            primaryColorGreen = 71.toColor()
            primaryColorBlue = 6.toColor()
            primaryDarkBlueUIColor = Color.rgbToUIColor(0, 46, 4)
            primaryBackgroundBlueUIColor = ColorCompatibility.separator
            primaryColorFab = Color.rgbToUIColor(70, 175, 70)
        case "orange":
            primaryColorRed = 255.toColor()
            primaryColorGreen = 142.toColor()
            primaryColorBlue = 3.toColor()
            primaryDarkBlueUIColor = Color.rgbToUIColor(255, 90, 3)
            primaryBackgroundBlueUIColor = ColorCompatibility.separator
            primaryColorFab = Color.rgbToUIColor(255, 110, 37)
        default:
            primaryColorRed = 46.toColor()
            primaryColorGreen = 63.toColor()
            primaryColorBlue = 89.toColor()
            primaryDarkBlueUIColor = Color.rgbToUIColor(46, 63, 89)
            primaryBackgroundBlueUIColor = ColorCompatibility.separator
            primaryColorFab = Color.rgbToUIColor(88, 121, 169)
        }
    }
}
