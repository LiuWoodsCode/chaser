// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class Card: Widget {

    private let stackView: StackView

    init(_ arrangedSubviews: [UIView]) {
        stackView = StackView(arrangedSubviews: arrangedSubviews)
        setup()
    }

    init(_ vbox: VBox) {
        stackView = StackView(arrangedSubviews: [vbox.get()])
        setup()
    }

    init(_ widget: Widget) {
        stackView = StackView(arrangedSubviews: [widget.getView()])
        setup()
    }

    private func setup() {
        let padding: CGFloat = 3.0
        stackView.backgroundColor = ColorCompatibility.systemBackground
        stackView.distribution = .fill
        stackView.alignment = .top
        stackView.axis = .horizontal
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
    }

    func constrain(_ box: Box) {
        box.widthAnchor.constraint(equalTo: box.widthAnchor).isActive = true
    }

    func constrain(_ size: CGFloat) {
        stackView.widthAnchor.constraint(equalToConstant: size).isActive = true
    }

    func connect(_ gesture: GestureData) {
        stackView.addGestureRecognizer(gesture)
    }

    func addCustomSpacing(_ spacing: CGFloat, _ arrangedSubview: UIView) {
        stackView.setCustomSpacing(spacing, after: arrangedSubview)
    }

    var color: UIColor {
        get { stackView.backgroundColor! }
        set { stackView.backgroundColor = newValue }
    }

    var isAccessibilityElement: Bool {
        get { stackView.isAccessibilityElement }
        set { stackView.isAccessibilityElement = newValue }
    }

    var accessibilityLabel: String {
        get { stackView.accessibilityLabel ?? "" }
        set { stackView.accessibilityLabel = newValue }
    }

    var axis: NSLayoutConstraint.Axis {
        get { stackView.axis }
        set { stackView.axis = newValue }
    }

    var alignment: UIStackView.Alignment {
        get { stackView.alignment }
        set { stackView.alignment = newValue }
    }

    func getView() -> UIView {
        stackView
    }
}
