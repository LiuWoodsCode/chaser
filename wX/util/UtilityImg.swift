// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class UtilityImg {

    static func resizeImage(_ image: UIImage, _ scale: CGFloat) -> UIImage {
        let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let rendererFormat = UIGraphicsImageRendererFormat()
        rendererFormat.opaque = false
        let renderer = UIGraphicsImageRenderer(size: newSize, format: rendererFormat)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        }
    }

    static func layerDrawableToBitmap(_ layers: [Bitmap]) -> Bitmap {
        var image = UIImage()
        if layers.count == 0 {
            return Bitmap()
        }
        if layers.count < 2 {
            image = layers[0].image
        } else {
            var imgTmp = layers[0].image
            layers.forEach { layer in
                imgTmp = UtilityImg.mergeImages(imgTmp, layer.image)
            }
            image = imgTmp
        }
        return Bitmap(image, addWhiteBg: true)
    }

    static func mergeImages(_ imageA: UIImage, _ imageB: UIImage) -> UIImage {
        let newSize = CGSize(width: imageA.size.width, height: imageA.size.height)
        let rendererFormat = UIGraphicsImageRendererFormat()
        rendererFormat.opaque = false
        let renderer = UIGraphicsImageRenderer(size: newSize, format: rendererFormat)
        return renderer.image { _ in
            imageA.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
            imageB.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        }
    }

    static func mergeImages(_ bitmapA: Bitmap, _ bitmapB: Bitmap) -> UIImage {
        let newSize = CGSize(width: bitmapA.image.size.width, height: bitmapA.image.size.height)
        let rendererFormat = UIGraphicsImageRendererFormat()
        rendererFormat.opaque = false
        let renderer = UIGraphicsImageRenderer(size: newSize, format: rendererFormat)
        return renderer.image { _ in
            bitmapA.image.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
            bitmapB.image.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        }
    }

    static func createSolidImage(_ color: UIColor, _ size: CGSize) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        let rendererFormat = UIGraphicsImageRendererFormat()
        rendererFormat.opaque = false
        rendererFormat.scale = 0.0
        let renderer = UIGraphicsImageRenderer(size: rect.size, format: rendererFormat)
        return renderer.image { _ in
            color.setFill()
            UIRectFill(rect)
        }
    }
}
