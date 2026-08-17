// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcSettingsExperimental: UIwXViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbar.items = ToolbarItems(doneButton, GlobalVariables.flexBarButton).items
        objScrollStackView = ScrollStackView(self)
        boxMain.constrain(self)
        display()
    }

    override func doneClicked() {
        MyApplication.initPreferences()
        super.doneClicked()
    }

    private func display() {
        let text = Text(
            boxMain,
            "No experimental settings yet.",
            FontSize.large.size
        )
        text.isSelectable = false
    }
}
