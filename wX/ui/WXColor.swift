// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class WXColor {

    var uiLabel = ""
    var prefVar = ""
    var defaultRed: UInt8 = 0
    var defaultGreen: UInt8 = 0
    var defaultBlue: UInt8 = 0
    var alpha = 1.0
    var colorsCurrent: (red: UInt8, green: UInt8, blue: UInt8) = (red: 0, green: 0, blue: 0)

    var uiColorDefault: UIColor {
        Color.rgbToUIColor(defaultRed, defaultGreen, defaultBlue)
    }

    var uiColorCurrent: UIColor {
        Color.rgbToUIColor(colorsCurrent.red, colorsCurrent.green, colorsCurrent.blue, alpha)
    }

    convenience init(_ color: Int, _ alpha: CGFloat = 1.0) {
        self.init()
        self.alpha = alpha
        colorsCurrent = Color.intToRgb(color)
    }

    convenience init(_ uiLabel: String, _ prefVar: String, _ defaultRed: UInt8, _ defaultGreen: UInt8, _ defaultBlue: UInt8) {
        self.init()
        self.uiLabel = uiLabel
        self.prefVar = prefVar
        self.defaultRed = defaultRed
        self.defaultGreen = defaultGreen
        self.defaultBlue = defaultBlue
        regenCurrentColor()
    }

    convenience init(_ uiLabel: String, _ prefVar: String, _ defaultColor: Int) {
        self.init()
        self.uiLabel = uiLabel
        self.prefVar = prefVar
        let (red, green, blue) = Color.intToRgb(defaultColor)
        defaultRed = red
        defaultGreen = green
        defaultBlue = blue
        regenCurrentColor()
    }

    private func regenCurrentColor() {
        colorsCurrent = Color.intToRgb(Utility.readPrefInt(prefVar, Color.rgb(defaultRed, defaultGreen, defaultBlue)))
    }

    func saveNewColor(_ newRed: UInt8, _ newGreen: UInt8, _ newBlue: UInt8) {
        Utility.writePrefInt(prefVar, Color.rgb(newRed, newGreen, newBlue))
        regenCurrentColor()
    }

    func saveDefaultColor() {
        Utility.writePrefInt(prefVar, Color.rgb(defaultRed, defaultGreen, defaultBlue))
        regenCurrentColor()
    }
}
