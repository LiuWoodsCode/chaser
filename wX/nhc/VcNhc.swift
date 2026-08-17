// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcNhc: UIwXViewController {

    private var textProductButton = ToolbarIcon()
    private var imageProductButton = ToolbarIcon()
    private var nhc: Nhc!
    private var imageSummary: ImageSummary!
    private var bitmaps = [Bitmap]()
    private var urls = [String]()
    private var boxText = VBox()
    private var boxImages = VBox()
    private var downloadTimer = DownloadTimer("NHC_ACTIVITY")

    override func viewDidLoad() {
        super.viewDidLoad()
        textProductButton = ToolbarIcon("Text Products", self, #selector(textProductClicked))
        imageProductButton = ToolbarIcon("Images", self, #selector(imageProductClicked))
        toolbar.items = ToolbarItems(
            doneButton,
            GlobalVariables.flexBarButton,
            imageProductButton,
            textProductButton).items
        boxText.spacing = 1.0
        objScrollStackView = ScrollStackView(self)
        boxMain.addLayout(boxText)
        boxMain.addLayout(boxImages)
        nhc = Nhc()
        bitmaps = [Bitmap](repeating: Bitmap(), count: 9)
        imageSummary = ImageSummary(self, boxImages, bitmaps, imagesPerRowWide: 3)
        for region in NhcOceanEnum.allCases {
            urls += nhc.regionMap[region]!.urls
        }
        getContent()
    }

    override func getContent() {
        if downloadTimer.isRefreshNeeded() {
            _ = FutureVoid(nhc.getTextData, displayText)
            for (index, url) in urls.enumerated() {
                _ = FutureVoid({ self.bitmaps[index] = Bitmap(url) }, { self.imageSummary.set(index, self.bitmaps[index]); self.display() })
            }
        }
    }

    private func displayText() {
        boxText.removeChildren()
        nhc.showTextData()
        nhc.stormDataList.enumerated().forEach { index, s in
            boxText.addWidget(CardNhcStormReportItem(s, GestureData(index, self, #selector(gotoNhcStorm))))
        }
    }

    private func display() {
        textProductButton.setText("Text Products")
        imageProductButton.setText("Images")
        imageSummary.removeChildren()
        imageSummary = ImageSummary(self, bitmaps, imagesPerRowWide: 3)
        urls.enumerated().forEach { index, url in
            imageSummary.connect(index, GestureData(url, self, #selector(imageClicked)))
        }
    }

    @objc func gotoNhcStorm(sender: GestureData) {
        Route.nhcStorm(self, nhc.stormDataList[sender.data])
    }

    @objc func textProductClicked() {
        _ = PopUp(self, title: "", textProductButton, UtilityNhc.textProductLabels, textProductChanged)
    }

    func textProductChanged(_ index: Int) {
        Route.wpcText(self, UtilityNhc.textProductCodes[index])
    }

    @objc func imageProductClicked() {
        _ = PopUp(self, title: "", imageProductButton, UtilityNhc.imageTitles, imageProductChanged)
    }

    @objc func imageClicked(sender: GestureData) {
        Route.imageViewer(self, sender.strData)
    }

    func imageProductChanged(_ index: Int) {
        Route.imageViewer(self, UtilityNhc.imageUrls[index])
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in self.display() }
    }
}
