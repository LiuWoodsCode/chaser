// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VBox: Box {

    private let uiStackView = UIStackView()

    // for a normal UIStackView:
    // default distribution is .fill
    // default aix is .horizontal
    // default spacing is 0.0

    init(_ widgets: Widget...) {
        uiStackView.distribution = .fill
        uiStackView.axis = .vertical
        uiStackView.spacing = spacing
        widgets.forEach {
            addWidget($0)
        }
    }

    init(_ widgets: [Widget]) {
        uiStackView.distribution = .fill
        uiStackView.axis = .vertical
        uiStackView.spacing = spacing
        widgets.forEach {
            addWidget($0)
        }
    }

    func constrain(_ uiv: UIwXViewController) {
        uiStackView.widthAnchor.constraint(equalTo: uiv.scrollView.widthAnchor).isActive = true
    }

    func constrain(_ hbox: HBox) {
        uiStackView.widthAnchor.constraint(equalTo: hbox.widthAnchor).isActive = true
    }

    func constrain(_ card: CardHomeScreen, _ padding: CGFloat) {
        uiStackView.widthAnchor.constraint(equalTo: card.widthAnchor, constant: padding).isActive = true
    }

    func constrain(_ vbox: VBox, _ padding: CGFloat) {
        uiStackView.widthAnchor.constraint(equalTo: vbox.widthAnchor, constant: padding).isActive = true
    }

    func addWidget(_ w: UIView) {
        uiStackView.addArrangedSubview(w)
    }

    func addWidget(_ w: Widget) {
        uiStackView.addArrangedSubview(w.getView())
    }

    func addLayout(_ layout: Box) {
        uiStackView.addArrangedSubview(layout.getView())
    }

    func connect(_ gesture: GestureData) {
        uiStackView.addGestureRecognizer(gesture)
    }

    func noAutoresizingIntoConstraints() {
        get().translatesAutoresizingMaskIntoConstraints = false
    }

    func removeViews() {
        uiStackView.removeViews()
    }

    func removeChildren() {
        uiStackView.subviews.forEach {
            $0.removeFromSuperview()
        }
    }

    var isAccessibilityElement: Bool {
        get { uiStackView.isAccessibilityElement }
        set { uiStackView.isAccessibilityElement = newValue }
    }

    var isHidden: Bool {
        get { uiStackView.isHidden }
        set { uiStackView.isHidden = newValue }
    }

    var axis: NSLayoutConstraint.Axis {
        get { uiStackView.axis }
        set { uiStackView.axis = newValue }
    }

    var spacing: CGFloat {
        get { uiStackView.spacing }
        set { uiStackView.spacing = newValue }
    }

    var accessibilityLabel: String {
        get { uiStackView.accessibilityLabel ?? "" }
        set { uiStackView.accessibilityLabel = newValue }
    }

    var alignment: UIStackView.Alignment {
        get { uiStackView.alignment }
        set { uiStackView.alignment = newValue }
    }

    var widthAnchor: NSLayoutDimension { uiStackView.widthAnchor }

    func get() -> UIStackView {
        uiStackView
    }

    func getView() -> UIView {
        uiStackView
    }
}
