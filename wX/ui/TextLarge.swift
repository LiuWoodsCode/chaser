// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class TextLarge: Widget {

    private let tv = UILabelInset()

    init(
        _ textPadding: Int,
        _ text: String = "",
        _ color: UIColor = ColorCompatibility.label,
        constrainToScreenWidth: Bool = true
    ) {
        self.text = text
        tv.translatesAutoresizingMaskIntoConstraints = false
        if constrainToScreenWidth {
            let (width, _) = UtilityUI.getScreenBoundsCGFloat()
            tv.widthAnchor.constraint(equalToConstant: width - CGFloat(textPadding)).isActive = true
        }
        tv.font = FontSize.medium.size
        tv.adjustsFontSizeToFitWidth = true
        tv.textColor = color
        tv.isUserInteractionEnabled = false
    }

    func constrain() {
        let bounds = UtilityUI.getScreenBoundsCGFloat()
        tv.widthAnchor.constraint(equalToConstant: bounds.0).isActive = true
    }

    func resetTextSize() {
        tv.font = FontSize.medium.size
    }

    func connect(_ gesture: GestureData) {
        tv.addGestureRecognizer(gesture)
    }

    var text: String {
        get { tv.text! }
        set { tv.text = newValue }
    }

    var font: UIFont {
        get { tv.font! }
        set { tv.font = newValue }
    }

    var background: UIColor {
        get { tv.backgroundColor! }
        set { tv.backgroundColor = newValue }
    }

    var color: UIColor {
        get { tv.textColor! }
        set { tv.textColor = newValue }
    }

    var isAccessibilityElement: Bool {
        get { tv.isAccessibilityElement }
        set { tv.isAccessibilityElement = newValue }
    }

    var isHidden: Bool {
        get { tv.isHidden }
        set { tv.isHidden = newValue }
    }

    func get() -> UILabelInset {
        tv
    }

    func getView() -> UIView {
        tv
    }
}
