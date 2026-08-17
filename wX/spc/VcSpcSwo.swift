// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcSpcSwo: UIwXViewControllerWithAudio {

    private var bitmaps = [Bitmap]()
    private var urls = [String]()
    private var html = ""
    private var statusButton = ToolbarIcon()
    private var stateButton = ToolbarIcon()
    var spcSwoDay = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = UIPreferences.screenOnForTts
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        statusButton = ToolbarIcon("Day " + spcSwoDay, self, nil)
        stateButton = ToolbarIcon("STATE", self, #selector(stateClicked))
        toolbar.items = ToolbarItems(
            doneButton,
            statusButton,
            GlobalVariables.flexBarButton,
            stateButton,
            playButton,
            playListButton,
            shareButton).items
        objScrollStackView = ScrollStackView(self)
        getText()
        getImage()
    }

    override func doneClicked() {
        UIApplication.shared.isIdleTimerDisabled = false
        super.doneClicked()
    }

    func getText() {
        if spcSwoDay == "48" {
            product = "SWOD" + spcSwoDay
        } else {
            product = "SWODY" + spcSwoDay
        }
        _ = FutureVoid({ self.html = DownloadText.byProduct(self.product) }, display)
    }

    func getImage() {
        _ = FutureVoid({ self.urls = UtilitySpcSwo.getUrls(self.spcSwoDay) }, getBitmaps)
    }

    private func getBitmaps() {
        bitmaps = [Bitmap](repeating: Bitmap(), count: urls.count)
        for (index, url) in urls.enumerated() {
            _ = FutureVoid({ self.bitmaps[index] = Bitmap(url) }, display)
        }
    }

    private func display() {
        boxMain.removeChildren()
        statusButton.setText("Day " + spcSwoDay)
        stateButton.setText("STATE")
        _ = ImageAndText(self, bitmaps, html)
    }

    @objc func imageClickedWithIndex(sender: GestureData) {
        Route.imageViewer(self, bitmaps[sender.data].url)
    }

    override func shareClicked(sender: UIButton) {
        UtilityShare.image(self, sender, bitmaps, html)
    }

    @objc func stateClicked() {
        Route.swoState(self, spcSwoDay)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in self.display() }
    }
}
