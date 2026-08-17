// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class Bitmap {

    let dataBm: Data
    var image: UIImage
    var url = ""
    var info = "" // used in GOES viewer to store additional info

    init() {
        image = Bitmap.imageWithSize(
            size: CGSize(width: 86, height: 86),
            filledWithColor: UIColor.white,
            scale: 1.0,
            opaque: false
        )
        dataBm = image.pngData()!
    }

    init(_ w: Int, _ h: Int) {
        image = Bitmap.imageWithSize(
            size: CGSize(width: w, height: h),
            filledWithColor: UIColor.white,
            scale: 1.0,
            opaque: false
        )
        dataBm = image.pngData()!
    }

    init(_ bm: Data) {
        dataBm = bm
        if let imgTmp = UIImage(data: dataBm) {
            image = imgTmp
        } else {
            image = Bitmap.imageWithSize(
                size: CGSize(width: 3, height: 3),
                filledWithColor: UIColor.white,
                scale: 1.0,
                opaque: false
            )
        }
    }

    init(_ url: String, addWhiteBg: Bool = false) {
        var bitmapLocal = url.getImage()
        if addWhiteBg {
            bitmapLocal = Bitmap(bitmapLocal.image, addWhiteBg: true)
        }
        dataBm = bitmapLocal.dataBm
        image = bitmapLocal.image
        self.url = url
    }

    init(_ image: UIImage, addWhiteBg: Bool = false) {
        if addWhiteBg {
            let whiteImg = UtilityImg.createSolidImage(UIColor.white, CGSize(width: image.size.width, height: image.size.height))
            self.image = UtilityImg.mergeImages(whiteImg, image)
        } else {
            self.image = image
        }
        if let data = image.pngData() {
            dataBm = data
        } else {
            self.image = Bitmap.imageWithSize(
                size: CGSize(width: 86, height: 86),
                filledWithColor: UIColor.white,
                scale: 1.0,
                opaque: false
            )
            dataBm = self.image.pngData()!
        }
    }

    var data: Data { dataBm }

    var width: CGFloat { image.size.width }

    var height: CGFloat { image.size.height }

    var isValid: Bool { width > 100 }

    static func imageWithSize(
        size: CGSize,
        filledWithColor color: UIColor = UIColor.clear,
        scale: CGFloat = 0.0,
        opaque: Bool = false
    ) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let rendererFormat = UIGraphicsImageRendererFormat()
        rendererFormat.opaque = opaque
        rendererFormat.scale = scale
        let renderer = UIGraphicsImageRenderer(size: size, format: rendererFormat)
        let newImage: UIImage = renderer.image { _ in
            color.set()
            UIRectFill(rect)
        }
        return newImage
    }

    static func fromFile(_ filename: String) -> Bitmap {
        UtilityIO.readBitmapResourceFromFile(filename)
    }
}
