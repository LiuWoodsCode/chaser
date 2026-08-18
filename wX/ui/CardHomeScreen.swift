// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class CardHomeScreen: Box {

    private let uistackView = UIStackView()

    func setup(redesign: Bool = false) {
        uistackView.translatesAutoresizingMaskIntoConstraints = false
        uistackView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        uistackView.axis = .vertical
        uistackView.alignment = .center
        uistackView.spacing = 0.0
        applyHomeScreenWidgetStyle(redesign)
    }

    func setup(_ box: Box, horizontalPadding: CGFloat = 0.0, redesign: Bool = false) {
        uistackView.widthAnchor.constraint(equalTo: box.widthAnchor, constant: -2.0 * horizontalPadding).isActive = true
        setup(redesign: redesign)
    }

    func setupWithPadding(redesign: Bool = false) {
        setup(redesign: redesign)
        uistackView.spacing = UIPreferences.stackviewCardSpacing
    }

    func setupWithPadding(_ box: Box, horizontalPadding: CGFloat = 0.0, redesign: Bool = false) {
        setup(box, horizontalPadding: horizontalPadding, redesign: redesign)
        uistackView.spacing = UIPreferences.stackviewCardSpacing
    }

    private func applyHomeScreenWidgetStyle(_ redesign: Bool) {
        uistackView.backgroundColor = redesign ? ColorCompatibility.systemGray5 : .clear
        uistackView.layer.cornerRadius = redesign ? 8.0 : 0.0
        uistackView.layer.masksToBounds = redesign
    }

    func addWidget(_ w: UIView) {
        uistackView.addArrangedSubview(w)
    }

    func addWidget(_ w: Widget) {
        uistackView.addArrangedSubview(w.getView())
    }

    func connect(_ gesture: UIGestureRecognizer) {
        uistackView.addGestureRecognizer(gesture)
    }

    func removeFromSuperview() {
        uistackView.removeFromSuperview()
    }

    var widthAnchor: NSLayoutDimension { uistackView.widthAnchor }

    func get() -> UIStackView {
        uistackView
    }

    func getView() -> UIView {
        uistackView
    }
}
