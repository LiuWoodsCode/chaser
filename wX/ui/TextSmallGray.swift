// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class TextSmallGray: Widget {

    private let tv = UITextView()

    init(_ text: String = "") {
        self.text = text
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.font = FontSize.small.size
        tv.textContainerInset = UIEdgeInsets.zero
        tv.textColor = ColorCompatibility.secondaryLabel
        tv.isUserInteractionEnabled = false
    }

    func constrain(_ vbox: VBox) {
        tv.widthAnchor.constraint(equalTo: vbox.widthAnchor).isActive = true
    }

    func resetTextSize() {
        tv.font = FontSize.medium.size
    }

    func connect(_ gesture: GestureData) {
         tv.addGestureRecognizer(gesture)
    }

    var text: String {
        get { tv.text }
        set { tv.text = newValue }
    }

    var isAccessibilityElement: Bool {
        get { tv.isAccessibilityElement }
        set { tv.isAccessibilityElement = newValue }
    }

    func getView() -> UIView {
        tv
    }
}
