// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class Color {

    static let RED = -65536
    static let GREEN = -16711936
    static let YELLOW = -256
    static let MAGENTA = -65281

    // changed to | from +
    static func rgb(_ red: Int, _ green: Int, _ blue: Int) -> Int {
        (0xFF << 24) | (red << 16) | (green << 8) | blue
    }

    static func rgb(_ red: UInt8, _ green: UInt8, _ blue: UInt8) -> Int {
        (Int(0xFF) << 24) | (Int(red) << 16) | (Int(green) << 8) | Int(blue)
    }

    static func red(_ color: Int) -> UInt8 {
        UInt8((color >> 16) & 0xFF)
    }

    static func green(_ color: Int) -> UInt8 {
        UInt8((color >> 8) & 0xFF)
    }

    static func blue(_ color: Int) -> UInt8 {
        UInt8(color & 0xFF)
    }

    static func rgbToUIColor(_ newRed: UInt8, _ newGreen: UInt8, _ newBlue: UInt8, _ alpha: CGFloat = 1.0) -> UIColor {
        UIColor(red: newRed.toColor(), green: newGreen.toColor(), blue: newBlue.toColor(), alpha: alpha)
    }

    static func intToRgb(_ colorInt: Int) -> (red: UInt8, green: UInt8, blue: UInt8) {
        (Color.red(colorInt), Color.green(colorInt), Color.blue(colorInt))
    }

    static func colorToHsv(_ color: Int) -> [Double] {
        let redInt: Int = ((color >> 16) & 0xFF)
        let greenInt: Int = ((color >> 8) & 0xFF)
        let blueInt: Int = (color & 0xFF)
        let redDouble = Double(redInt) / 255.0
        let greenDouble = Double(greenInt) / 255.0
        let blueDouble = Double(blueInt) / 255.0
        let color = UIColor(red: CGFloat(redDouble), green: CGFloat(greenDouble), blue: CGFloat(blueDouble), alpha: 1.0)
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return [Double(hue), Double(saturation), Double(brightness)]
    }

    static func hsvToColor(_ hsv: [Double]) -> Int {
        let color = UIColor(hue: CGFloat(hsv[0]), saturation: CGFloat(hsv[1]), brightness: CGFloat(hsv[2]), alpha: CGFloat(1.0))
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return Color.rgb(Int(red * 255), Int(green * 255), Int(blue * 255))
    }
}
