// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class ColorPalettes {

    static func initialize() {
        [94, 99, 134, 135, 159, 161, 163, 165, 172].forEach { product in
            ColorPalette.radarColorPalette[product] = Utility.readPref("RADAR_COLOR_PALETTE_" + String(product), "CODENH")
        }
        let cm94 = ColorPalette(94)
        ColorPalette.colorMap[94] = cm94
        ColorPalette.colorMap[94]!.initialize()
        ColorPalette.colorMap[153] = cm94
        ColorPalette.colorMap[2153] = cm94
        ColorPalette.colorMap[180] = cm94
        ColorPalette.colorMap[186] = cm94
        let cm99 = ColorPalette(99)
        ColorPalette.colorMap[99] = cm99
        ColorPalette.colorMap[99]!.initialize()
        ColorPalette.colorMap[154] = cm99
        ColorPalette.colorMap[2154] = cm99
        ColorPalette.colorMap[182] = cm99
        let cm172 = ColorPalette(172)
        ColorPalette.colorMap[172] = cm172
        ColorPalette.colorMap[172]!.initialize()
        ColorPalette.colorMap[170] = cm172
        [19, 30, 41, 56, 134, 135, 159, 161, 163, 165].forEach { productNumber in
            ColorPalette.colorMap[productNumber] = ColorPalette(productNumber)
            ColorPalette.colorMap[productNumber]!.initialize()
        }
        ColorPalette.colorMap[37] = ColorPalette.colorMap[19]
        ColorPalette.colorMap[38] = ColorPalette.colorMap[19]
    }
}
