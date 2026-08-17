// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class ForecastIcon {

    private let dimensions = 86
    private let halfWidth = 41
    private let middlePoint = 45
    private let numHeight = 15
    private let yText = 71  // was 70
    private var newImage = UIImage()
    private var bitmap: Bitmap
    private var bitmapRight = Bitmap()
    private var textFontAttributes: [NSAttributedString.Key: Any]?
    private let textFont = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.bold)
    private let textColor = WXColor(UIPreferences.nwsIconTextColor).uiColorCurrent

    init(_ weatherCondition: String) {
        textFontAttributes = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): textFont,
            NSAttributedString.Key.foregroundColor: textColor
            ] as [NSAttributedString.Key: Any]?
        if let fileName = UtilityNwsIcon.iconMap[weatherCondition + ".png"] {
            bitmap = UtilityIO.readBitmapResourceFromFile(fileName)
            newImage = bitmap.image
        } else {
            bitmap = Bitmap()
        }
    }

    init(_ leftWeatherCondition: String, _ rightWeatherCondition: String) {
        textFontAttributes = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): textFont,
            NSAttributedString.Key.foregroundColor: textColor
            ] as [NSAttributedString.Key: Any]?
        let leftCropA = leftWeatherCondition.contains("fg") ? middlePoint : 4
        let leftCropB = rightWeatherCondition.contains("fg") ? middlePoint : 4
        if let fileNameLeft = UtilityNwsIcon.iconMap[leftWeatherCondition + ".png"] {
            bitmap = UtilityIO.readBitmapResourceFromFile(fileNameLeft)
        } else {
            bitmap = Bitmap()
        }
        if let fileNameRight = UtilityNwsIcon.iconMap[rightWeatherCondition + ".png"] {
            bitmapRight = UtilityIO.readBitmapResourceFromFile(fileNameRight)
        } else {
            bitmapRight = Bitmap()
        }
        let rect = CGRect(x: leftCropA, y: 0, width: halfWidth, height: dimensions)
        let imageRef = bitmap.image.cgImage!.cropping(to: rect)!
        bitmap.image = UIImage(cgImage: imageRef)

        let rectB = CGRect(x: leftCropB, y: 0, width: halfWidth, height: dimensions)
        let imageRefB = bitmapRight.image.cgImage!.cropping(to: rectB)!
        bitmapRight.image = UIImage(cgImage: imageRefB)
    }

    func drawLeftText(_ leftNumber: String, _ rightNumber: String) {
        let size = CGSize(width: dimensions, height: dimensions)
        let rendererFormat = UIGraphicsImageRendererFormat()
        rendererFormat.opaque = true
        let renderer = UIGraphicsImageRenderer(size: size, format: rendererFormat)
        newImage = renderer.image { _ in
            let bgRect = CGRect(x: 0, y: 0, width: dimensions, height: dimensions)
            UIColor.white.setFill()
            UIRectFill(bgRect)

            let aSize = CGRect(x: 0, y: 0, width: halfWidth, height: dimensions)
            bitmap.image.draw(in: aSize)

            let bSize = CGRect(x: middlePoint, y: 0, width: halfWidth, height: dimensions)
            bitmapRight.image.draw(in: bSize, blendMode: .normal, alpha: 1.0)

            let xText = 56  // was 58
            let xTextLeft = 2
            let fillColor = WXColor(UIPreferences.nwsIconBottomColor, 0.785).uiColorCurrent
            if leftNumber != "" && leftNumber != "0" {
                let rectangle = CGRect(x: 0, y: dimensions - numHeight, width: halfWidth, height: dimensions)
                fillColor.setFill()
                UIRectFill(rectangle)
                let rect = CGRect(x: xTextLeft, y: yText, width: dimensions, height: dimensions)
                let strToDraw = leftNumber + "%"
                strToDraw.draw(in: rect, withAttributes: textFontAttributes)
            }
            if rightNumber != "" && rightNumber != "0" {
                let rectangle = CGRect(x: middlePoint, y: dimensions - numHeight, width: halfWidth, height: dimensions)
                fillColor.setFill()
                UIRectFill(rectangle)
                let rect = CGRect(x: xText, y: yText, width: dimensions, height: dimensions)
                let strToDraw = rightNumber + "%"
                strToDraw.draw(in: rect, withAttributes: textFontAttributes)
            }
        }
    }

    func drawSingleText(_ number: String) {
        let imageSize = bitmap.image.size
        let xText = number == "100" ? 50 : 56
        let rendererFormat = UIGraphicsImageRendererFormat()
        rendererFormat.opaque = true
        let renderer = UIGraphicsImageRenderer(size: imageSize, format: rendererFormat)
        newImage = renderer.image { _ in
            bitmap.image.draw(at: CGPoint.zero)
            if number != "" {
                let rectangle = CGRect(x: 0, y: dimensions - numHeight, width: dimensions, height: dimensions)
                let fillColor = WXColor(UIPreferences.nwsIconBottomColor, 0.785).uiColorCurrent
                fillColor.setFill()
                UIRectFill(rectangle)
                let rect = CGRect(x: xText, y: yText, width: dimensions, height: dimensions)
                let strToDraw = number + "%"
                strToDraw.draw(in: rect, withAttributes: textFontAttributes)
            }
        }
    }

    func get() -> Bitmap {
        Bitmap(newImage)
    }

    static func blankBitmap() -> Bitmap {
        Bitmap()
    }
}
