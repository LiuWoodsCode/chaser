// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class Text: Widget {

    private let tv = UITextView()
    var textColor = WXColor()

    init() {
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.font = FontSize.medium.size
        tv.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
    }

    convenience init(_ vbox: VBox) {
        self.init()
        vbox.addWidget(tv)
        constrain(vbox)
    }

    convenience init(_ text: String, zeroSpacing: Bool = true) {
        self.init()
        self.text = text
        tv.isUserInteractionEnabled = false
        if zeroSpacing {
            setZeroSpacing()
        }
    }

    convenience init(
        _ box: Box,
        _ text: String,
        zeroSpacing: Bool = true,
        widthDivider: Int = 1
    ) {
        self.init()
        self.text = text
        box.addWidget(tv)
        if widthDivider == 1 {
            constrain(box)
        } else {
            tv.widthAnchor.constraint(equalTo: box.widthAnchor, multiplier: 1.0 / CGFloat(widthDivider)).isActive = true
        }
        tv.isUserInteractionEnabled = false
        if zeroSpacing {
            setZeroSpacing()
        }
    }

    convenience init(_ vbox: VBox, _ text: String, _ gesture: GestureData) {
        self.init(vbox, text)
        tv.isUserInteractionEnabled = true
        connect(gesture)
    }

    convenience init(_ card: CardHomeScreen, _ text: String, _ font: UIFont, _ color: UIColor) {
        self.init()
        self.text = text
        self.color = color
        self.font = font
        card.addWidget(tv)
        constrain(card)
    }

    convenience init(_ vbox: VBox, _ text: String, _ font: UIFont) {
        self.init(vbox, text)
        self.font = font
    }

    convenience init(_ vbox: VBox, _ text: String, _ font: UIFont, _ gesture: GestureData) {
        self.init(vbox, text, font)
        tv.isUserInteractionEnabled = true
        let padding = CGFloat(10)
        tv.textContainerInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        connect(gesture)
    }

    convenience init(_ vbox: VBox, _ text: String, _ color: WXColor) {
        self.init(vbox, text)
        textColor = color
    }

    func connect(_ gesture: GestureData) {
        tv.addGestureRecognizer(gesture)
    }

    func addSpacing() {
        let padding = CGFloat(10.0)
        tv.textContainerInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }

    var color: UIColor {
        get { tv.textColor! }
        set { tv.textColor = newValue }
    }

    var isAccessibilityElement: Bool {
        get { tv.isAccessibilityElement }
        set { tv.isAccessibilityElement = newValue }
    }

    var accessibilityLabel: String {
        get { tv.accessibilityLabel ?? "" }
        set { tv.accessibilityLabel = newValue }
    }

    var isSelectable: Bool {
        get { tv.isSelectable }
        set { tv.isSelectable = newValue }
    }

    var isUserInteractionEnabled: Bool {
        get { tv.isUserInteractionEnabled }
        set { tv.isUserInteractionEnabled = newValue }
    }

    var isHidden: Bool {
        get { tv.isHidden }
        set { tv.isHidden = newValue }
    }

    var isEditable: Bool {
        get { tv.isEditable }
        set { tv.isEditable = newValue }
    }

    var textAlignment: NSTextAlignment {
        get { tv.textAlignment }
        set { tv.textAlignment = newValue }
    }

    var background: UIColor {
        get { tv.backgroundColor! }
        set { tv.backgroundColor = newValue }
    }

    var font: UIFont {
        get { tv.font! }
        set { tv.font = newValue }
    }

    var text: String {
        get { tv.text }
        set { tv.text = newValue }
    }

    func setZeroSpacing() {
        tv.textContainerInset = UIEdgeInsets.zero
    }

    func constrain(_ scrollView: UIScrollView) {
        tv.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }

    func constrain(_ box: Box) {
        tv.widthAnchor.constraint(equalTo: box.widthAnchor).isActive = true
    }

    func get() -> UITextView {
        tv
    }

    func getView() -> UIView {
        tv
    }
}
