// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class CardHomeScreen: Box {

    private let uistackView = UIStackView()

    func setup() {
        uistackView.translatesAutoresizingMaskIntoConstraints = false
        uistackView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        uistackView.axis = .vertical
        uistackView.alignment = .center
        uistackView.spacing = 0.0
    }

    func setup(_ box: Box) {
        uistackView.widthAnchor.constraint(equalTo: box.widthAnchor).isActive = true
        setup()
    }

    func setupWithPadding() {
        setup()
        uistackView.spacing = UIPreferences.stackviewCardSpacing
    }

    func setupWithPadding(_ box: Box) {
        setup(box)
        uistackView.spacing = UIPreferences.stackviewCardSpacing
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
