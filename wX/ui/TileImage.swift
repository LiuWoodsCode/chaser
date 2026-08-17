// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class TileImage {

    private var image = Image()

    init(_ hbox: HBox, _ filename: String, _ index: Int, _ iconsPerRow: CGFloat, _ accessibilityLabel: String) {
        let bitmap = Bitmap.fromFile(filename)
        image.tag = index
        image.set(bitmap)
        image.isAccessibilityElement = true
        image.accessibilityLabel = accessibilityLabel
        hbox.addWidget(image)
        image.setImageAnchorsForTiles(hbox, iconsPerRow)
    }

    init(_ hbox: HBox, _ iconsPerRow: CGFloat) {
        hbox.addWidget(image)
        image.setImageAnchorsForTiles(hbox, iconsPerRow)
    }

    func connect(_ gesture: GestureData) {
        image.connect(gesture)
    }
}
