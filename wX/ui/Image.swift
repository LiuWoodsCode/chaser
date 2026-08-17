// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class Image: Widget {

    private let img = UIImageView()
    private var width: CGFloat = 0.0
    private var widthDivider = 1
    private var bitmap = Bitmap()

    init() {
        img.contentMode = UIView.ContentMode.scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        img.isUserInteractionEnabled = true
        (width, _) = UtilityUI.getScreenBoundsCGFloat()
    }

    convenience init(_ box: Box, _ bitmap: Bitmap, widthDivider: Int = 1) {
        self.init()
        img.image = UIImage(data: bitmap.data) ?? UIImage()
        self.bitmap = bitmap
        self.widthDivider = widthDivider
        setImageAnchors(width / CGFloat(widthDivider) - UIPreferences.stackviewCardSpacing)
        box.addWidget(img)
    }

    convenience init(_ box: Box, _ bitmap: Bitmap, _ gesture: GestureData, widthDivider: Int = 1) {
        self.init(box, bitmap, widthDivider: widthDivider)
        connect(gesture)
    }

    convenience init(_ stackView: CardHomeScreen, _ bitmap: Bitmap, hs: Bool) {
        self.init()
        img.image = bitmap.image
        self.bitmap = bitmap
        stackView.addWidget(img)
        if hs {
            setImageAnchorsForHomeScreen(stackView)
        } else {
            setImageAnchors(width - UIPreferences.stackviewCardSpacing * 2.0)
        }
    }

    convenience init(_ vbox: VBox) {
        self.init()
        vbox.addWidget(img)
    }

    func set(_ bitmap: Bitmap) {
        self.bitmap = bitmap
        img.image = UIImage(data: bitmap.data) ?? UIImage()
        setImageAnchors(width)
    }

    func connect(_ gesture: GestureData) {
        img.addGestureRecognizer(gesture)
    }

    private func setImageAnchors(_ width: CGFloat) {
        img.widthAnchor.constraint(equalToConstant: width).isActive = true
        img.heightAnchor.constraint(equalToConstant: width * (bitmap.height / bitmap.width)).isActive = true
    }

    private func setImageAnchorsForHomeScreen(_ stackView: CardHomeScreen) {
        img.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        img.heightAnchor.constraint(equalTo: img.widthAnchor, multiplier: (bitmap.height / bitmap.width)).isActive = true
    }

    func setImageAnchorsForTiles(_ hbox: HBox, _ iconsPerRow: CGFloat) {
        img.widthAnchor.constraint(equalTo: hbox.widthAnchor, multiplier: 1 / iconsPerRow).isActive = true
        img.heightAnchor.constraint(equalTo: hbox.widthAnchor, multiplier: 1 / iconsPerRow).isActive = true
    }

    func removeGestures() {
        img.gestureRecognizers?.forEach(img.removeGestureRecognizer)
    }

    var tag: Int {
        get { img.tag }
        set { img.tag = newValue }
    }

    var isHidden: Bool {
        get { img.isHidden }
        set { img.isHidden = newValue }
    }

    var accessibilityLabel: String {
        get { img.accessibilityLabel ?? "" }
        set { img.accessibilityLabel = newValue }
    }

    var isAccessibilityElement: Bool {
        get { img.isAccessibilityElement }
        set { img.isAccessibilityElement = newValue }
    }

    func getView() -> UIView {
        img
    }

    func getBitmap() -> Bitmap {
        bitmap
    }
}
