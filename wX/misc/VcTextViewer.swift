// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcTextViewer: UIwXViewControllerWithAudio {

    var html = ""
    var isFixedWidth = false

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ToolbarItems(doneButton, GlobalVariables.flexBarButton, playButton, shareButton).items
        objScrollStackView = ScrollStackView(self)
        display()
    }

    private func display() {
        if !isFixedWidth {
            textMain = Text(boxMain, html)
        } else {
            textMain = Text(boxMain, html, FontSize.hourly.size)
        }
        textMain.constrain(scrollView)
    }
}
