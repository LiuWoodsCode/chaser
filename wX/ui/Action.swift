// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class Action {

    let label: String
    let uiAlertAction: UIAlertAction
    private let fn: () -> Void

    init(_ label: String, _ fn: @escaping () -> Void) {
        self.label = label
        self.fn = fn
        uiAlertAction = UIAlertAction(label) { _ in fn() }
    }

    func perform() {
        fn()
    }
}
