// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcSpcFireOutlook: UIwXViewControllerWithAudio {

    private var bitmap = Bitmap()
    private var html = ""
    private var statusButton = ToolbarIcon()
    private var dayString = ""
    var dayIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        dayString = To.string(dayIndex + 1)
        if dayIndex == 2 {
            dayString = "3-8"
        }
        statusButton = ToolbarIcon("Day " + dayString, self, nil)
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ToolbarItems([
            doneButton,
            statusButton,
            GlobalVariables.flexBarButton,
            playButton,
            playListButton,
            shareButton
        ]).items
        objScrollStackView = ScrollStackView(self)
        getContent()
    }

    override func getContent() {
        getImage()
        getText()
    }

    func getImage() {
        let url = UtilitySpcFireOutlook.urls[dayIndex]
        _ = FutureVoid({ self.bitmap = Bitmap(url) }, display)
    }

    func getText() {
        product = UtilitySpcFireOutlook.products[dayIndex]
        _ = FutureVoid({ self.html = DownloadText.byProduct(self.product) }, display)
    }

    @objc func imageClicked() {
        Route.imageViewer(self, UtilitySpcFireOutlook.urls[dayIndex])
    }

    private func display() {
        statusButton.setText("Day " + dayString)
        boxMain.removeChildren()
        _ = ImageAndText(self, bitmap, html)
    }

    override func shareClicked(sender: UIButton) {
        UtilityShare.image(self, sender, bitmap, html)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in self.display() }
    }
}
