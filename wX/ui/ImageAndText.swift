// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class ImageAndText {

    //
    // Used in SPC Swo(below), SPC Fireoutlook, and WPC Excessive Rain image/text combo
    //

    init(_ uiv: UIwXViewControllerWithAudio, _ bitmap: Bitmap, _ html: String) {
        var tabletInLandscape = UtilityUI.isTablet() && UtilityUI.isLandscape()
        #if targetEnvironment(macCatalyst)
        tabletInLandscape = true
        #endif
        if tabletInLandscape {
            uiv.boxMain.axis = .horizontal
            uiv.boxMain.alignment = .firstBaseline
        }
        var views = [UIView]()
        let image: Image
        if tabletInLandscape {
            image = Image(
                uiv.boxMain,
                bitmap,
                GestureData(0, uiv, #selector(imageClicked)),
                widthDivider: 2
            )
        } else {
            image = Image(uiv.boxMain, bitmap, GestureData(0, uiv, #selector(imageClicked)))
        }
        image.accessibilityLabel = html
        image.isAccessibilityElement = true
        views.append(image.getView())
        if tabletInLandscape {
            uiv.textMain = Text(uiv.boxMain, html, widthDivider: 2)
        } else {
            uiv.textMain = Text(uiv.boxMain, html)
        }
        uiv.textMain.isAccessibilityElement = true
        views.append(uiv.textMain.get())
        uiv.scrollView.accessibilityElements = views
    }

    // SPC SWO
    init(_ uiv: UIwXViewControllerWithAudio, _ bitmaps: [Bitmap], _ html: String) {
        var imageCount = 0
        var imagesPerRow = 2
        var boxRows = [HBox]()
        if UtilityUI.isTablet() && UtilityUI.isLandscape() {
            imagesPerRow = 4
        }
        #if targetEnvironment(macCatalyst)
        imagesPerRow = 4
        #endif
        if bitmaps.count == 2 { imagesPerRow = 2 }
        bitmaps.enumerated().forEach { imageIndex, image in
            let hbox: HBox
            if imageCount % imagesPerRow == 0 {
                let objectStackView = HBox(.fillEqually)
                boxRows.append(objectStackView)
                hbox = objectStackView
                uiv.boxMain.addLayout(hbox)
            } else {
                hbox = boxRows.last!
            }
            _ = Image(
                hbox,
                image,
                GestureData(imageIndex, uiv, #selector(imageClickedWithIndex)),
                widthDivider: imagesPerRow)
            imageCount += 1
        }
        var views = [UIView]()
        uiv.textMain = Text(uiv.boxMain, html)
        uiv.textMain.constrain(uiv.scrollView)
        uiv.textMain.isAccessibilityElement = true
        views.append(uiv.textMain.get())
        uiv.scrollView.accessibilityElements = views
    }

    @objc func imageClickedWithIndex(sender: GestureData) {}

    @objc func imageClicked() {}
}
