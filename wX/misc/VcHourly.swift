// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcHourly: UIwXViewControllerWithAudio {

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ToolbarItems(doneButton, GlobalVariables.flexBarButton, shareButton).items
        objScrollStackView = ScrollStackView(self)
        textMain = Text(boxMain, "", FontSize.hourly.size, GestureData(self, #selector(scroll)))
        textMain.constrain(scrollView)
        getContent()
    }

    override func getContent() {
        _ = FutureText("HOURLY", { s in self.textMain.text = s })
    }

    @objc func scroll() {
        scrollView.scrollToTop()
    }

    override func shareClicked(sender: UIButton) {
        UtilityShare.share(self, sender, textMain.text)
    }
}
