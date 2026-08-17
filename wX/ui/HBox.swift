// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class HBox: Box {

    private let uiStackView = UIStackView()

    // for a normal UIStackView:
    // default distribution is .fill
    // default aix is .horizontal
    // default spacing is 0.0

    init(
        _ distribution: UIStackView.Distribution,
        _ spacing: CGFloat = 0.0,
        _ widgets: [Widget] = []
    ) {
        uiStackView.distribution = distribution
        uiStackView.axis = .horizontal
        uiStackView.spacing = spacing
        widgets.forEach {
            addWidget($0)
        }
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

    func get() -> UIStackView {
        uiStackView
    }

    func getView() -> UIView {
        uiStackView
    }

    func removeAllChildren() {
        uiStackView.removeViews()
        uiStackView.removeFromSuperview()
    }

    func removeArrangedViews() {
        uiStackView.removeArrangedViews()
    }

    var isHidden: Bool {
        get { uiStackView.isHidden }
        set { uiStackView.isHidden = newValue }
    }

    var alignment: UIStackView.Alignment {
        get { uiStackView.alignment }
        set { uiStackView.alignment = newValue }
    }

    var widthAnchor: NSLayoutDimension { uiStackView.widthAnchor }
}
