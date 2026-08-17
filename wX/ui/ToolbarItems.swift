// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class ToolbarItems {

    var items: [UIBarButtonItem]

    init(_ items: UIBarButtonItem...) {
        self.items = items
        items.forEach {
            $0.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: AppColors.toolbarTextColor], for: .normal)
        }
    }

    init(_ items: [UIBarButtonItem]) {
        self.items = items
        items.forEach {
            $0.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: AppColors.toolbarTextColor], for: .normal)
        }
    }

    func insert(_ index: Int, _ button: UIBarButtonItem) {
        items.insert(button, at: index)
        button.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: AppColors.toolbarTextColor], for: .normal)
    }
}
