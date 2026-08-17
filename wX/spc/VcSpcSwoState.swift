// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcSpcSwoState: UIwXViewController {

    private var state = ""
    private var stateButton = ToolbarIcon()
    var day = ""
    private var bitmaps = [Bitmap]()
    private var urls = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        stateButton = ToolbarIcon(self, #selector(stateClicked))
        toolbar.items = ToolbarItems(doneButton, GlobalVariables.flexBarButton, stateButton, shareButton).items
        objScrollStackView = ScrollStackView(self)
        getContent(WfoSites.getState(Location.wfo))
    }

    func getContent(_ state: String) {
        self.state = state
        if self.state == "AK" || self.state == "HI" || self.state == "" {
            self.state = "AL"
        }
        stateButton.setText(self.state)
        urls.removeAll()
        bitmaps.removeAll()
        urls = UtilitySpcSwo.getSwoStateUrl(state, day)
        bitmaps = [Bitmap](repeating: Bitmap(), count: urls.count)
        for (index, url) in urls.enumerated() {
            _ = FutureVoid({ self.bitmaps[index] = Bitmap(url) }, display)
        }
    }

    private func display() {
        boxMain.removeChildren()
        _ = ImageSummary(self, bitmaps, imagesPerRowWide: 2)
    }

    @objc func imageClicked(sender: GestureData) {
        Route.imageViewer(self, bitmaps[sender.data].url)
    }

    @objc func stateClicked(sender: ToolbarIcon) {
        _ = PopUp(self, title: "State Selection", sender, GlobalArrays.states.filter { !$0.hasPrefix("AK") && !$0.hasPrefix("HI") }, getContent)
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.image(self, sender, bitmaps)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in self.display() }
    }
}
