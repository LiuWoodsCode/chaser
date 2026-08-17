// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcSpcTstormSummary: UIwXViewController {

    private var bitmaps = [Bitmap]()
    private var urls = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ToolbarItems(doneButton, GlobalVariables.flexBarButton, shareButton).items
        objScrollStackView = ScrollStackView(self)
        getContent()
    }

    override func getContent() {
        urls.removeAll()
        bitmaps.removeAll()
        _ = FutureVoid(downloadHtml, downloadImages)
    }

    private func downloadHtml() {
        urls = UtilitySpc.getTstormOutlookUrls()
    }

    private func downloadImages() {
        bitmaps = [Bitmap](repeating: Bitmap(), count: urls.count)
        for (index, url) in urls.enumerated() {
            _ = FutureVoid({ self.bitmaps[index] = Bitmap(url) }, display)
        }
    }

    private func display() {
        boxMain.removeChildren()
        _ = ImageSummary(self, bitmaps, imagesPerRowWide: bitmaps.count)
    }

    @objc func imageClicked(sender: GestureData) {
        Route.imageViewer(self, bitmaps[sender.data].url)
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.image(self, sender, bitmaps)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in self.display() }
    }
}
