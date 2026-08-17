// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class ImageSummary {

    //
    // To be used in image based summary for SPC SWO, SPC Tstorm, SPC Fire Outlook, WPC Excessive Rain
    //
    private var images = [Image]()
    private var boxRows = [HBox]()
    var bitmaps = [Bitmap]()

    init(_ uiv: UIwXViewController, _ bitmaps: [Bitmap], imagesPerRowWide: Int = 3) {
        var imageCount = 0
        var imagesPerRow = 2
        self.bitmaps = bitmaps
        boxRows.removeAll()
        images.removeAll()
        if UtilityUI.isTablet() && UtilityUI.isLandscape() {
            imagesPerRow = imagesPerRowWide
        }
        #if targetEnvironment(macCatalyst)
        imagesPerRow = imagesPerRowWide
        #endif
        bitmaps.enumerated().forEach { imageIndex, image in
            let currentRow: HBox
            if imageCount % imagesPerRow == 0 {
                let hbox = HBox(.fillEqually)
                boxRows.append(hbox)
                currentRow = hbox
                uiv.boxMain.addLayout(currentRow)
            } else {
                currentRow = boxRows.last!
            }
            images.append(Image(
                currentRow,
                image,
                GestureData(imageIndex, uiv, #selector(imageClicked)),
                widthDivider: imagesPerRow))
            imageCount += 1
        }
    }

    //
    // NHC and NHC Storm, add stack
    //
    init(_ uiv: UIwXViewController, _ parentBox: VBox, _ bitmaps: [Bitmap], imagesPerRowWide: Int = 3) {
        var imageCount = 0
        var imagesPerRow = 2
        self.bitmaps = bitmaps
        boxRows.removeAll()
        images.removeAll()
        if UtilityUI.isTablet() {
            imagesPerRow = imagesPerRowWide
        }
        #if targetEnvironment(macCatalyst)
        imagesPerRow = imagesPerRowWide
        #endif
        bitmaps.enumerated().forEach { imageIndex, image in
            let currentRow: HBox
            if imageCount % imagesPerRow == 0 {
                let hbox = HBox(.fillEqually)
                boxRows.append(hbox)
                currentRow = hbox
                parentBox.addLayout(currentRow)
            } else {
                currentRow = boxRows.last!
            }
            images.append(Image(
                currentRow,
                image,
                GestureData(imageIndex, uiv, #selector(imageClicked)),
                widthDivider: imagesPerRow))
            if !image.isValid {
                images.last!.isHidden = true
            } else {
                imageCount += 1
            }
        }
    }

    func connect(_ index: Int, _ gestureData: GestureData) {
        images[index].connect(gestureData)
    }

    func disconnect(_ index: Int) {
        images[index].removeGestures()
    }

    func removeChildren() {
        for layout in boxRows {
            layout.removeAllChildren()
        }
    }

    func set(_ index: Int, _ bitmap: Bitmap) {
        images[index].set(bitmap)
        bitmaps[index] = bitmap
    }

    @objc func imageClicked(sender: GestureData) {}
}
