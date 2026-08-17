// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcNhcStorm: UIwXViewController {

    private var productButton = ToolbarIcon()
    private var goesButton = ToolbarIcon()
    private var html = ""
    private var product = ""
    private var bitmaps = [Bitmap]()
    private var textProducts = [
        "MIATCP: Public Advisory",
        "MIATCM: Forecast Advisory",
        "MIATCD: Forecast Discussion",
        "MIAPWS: Wind Speed Probababilities"
    ]
    private let imageUrls = [
        "_5day_cone_with_line_and_wind_sm2.png",
        "_key_messages.png",
        "WPCQPF_sm2.gif",
        "WPCERO_sm2.gif",
        "_earliest_reasonable_toa_34_sm2.png",
        "_most_likely_toa_34_sm2.png",
        "_wind_probs_34_F120_sm2.png",
        "_wind_probs_50_F120_sm2.png",
        "_wind_probs_64_F120_sm2.png",
        "_peak_surge.png",
        "_wind_history.png"
    ]
    var stormData: NhcStormDetails!
    private var imageSummary: ImageSummary!
    private var boxImages = VBox()
    private var text: Text!
    private var textProductUrl = ""
    private var office = "MIA"
    let lock = NSLock()

    override func viewDidLoad() {
        super.viewDidLoad()
        product = stormData.stormPrefix + stormData.binNumber
        productButton = ToolbarIcon("Text Products", self, #selector(productClicked))
        goesButton = ToolbarIcon(self, .cloud, #selector(goesClicked))
        let shareButton = ToolbarIcon(self, .share, #selector(share))
        toolbar.items = ToolbarItems(
            doneButton,
            GlobalVariables.flexBarButton,
            goesButton,
            productButton,
            shareButton).items
        objScrollStackView = ScrollStackView(self)
        boxMain.addLayout(boxImages)
        text = Text(boxMain)
        text.constrain(scrollView)
        bitmaps = [Bitmap](repeating: Bitmap(), count: imageUrls.count)
        imageSummary = ImageSummary(self, boxImages, bitmaps, imagesPerRowWide: 3)
        textProductUrl = stormData.advisoryNumber
        if textProductUrl.hasPrefix("HFO") {
            office = "HFO"
            textProducts = [
                "HFOTCP: Public Advisory",
                "HFOTCM: Forecast Advisory",
                "HFOTCD: Forecast Discussion",
                "HFOPWS: Wind Speed Probababilities"
            ]
        }
        getContent()
    }

    override func getContent() {
        getImages()
        _ = FutureVoid({ self.html = DownloadText.byProduct(self.product) }, display)
    }

    func getImages() {
        imageUrls.enumerated().forEach { index, imageName in
            var url = stormData.baseUrl
            if imageName == "WPCQPF_sm2.gif" || imageName == "WPCERO_sm2.gif" {
                url = url.replace(ObjectDateTime.getYearString(), ObjectDateTime.getYearShortString())
            }
            _ = FutureVoid({ self.bitmaps[index] = Bitmap(url + imageName) }, display)
        }
    }

    @objc func share(sender: UIButton) {
        UtilityShare.image(self, sender, bitmaps, html)
    }

    @objc func productClicked() {
        _ = PopUp(self, productButton, textProducts, productChanged)
    }

    func productChanged(_ product: String) {
        Route.wpcTextNoSave(self, product + stormData.binNumber.uppercased())
    }

    func display() {
        lock.lock()
        productButton.setText("Text Products")
        boxImages.removeChildren()
        displayImage()
        displayText()
        lock.unlock()
    }

    func displayText() {
        text.text = html
    }

    func displayImage() {
        imageSummary = ImageSummary(self, boxImages, bitmaps, imagesPerRowWide: 3)
        imageUrls.indices.forEach { index in
            imageSummary.disconnect(index)
            imageSummary.connect(index, GestureData(bitmaps[index].url, self, #selector(imageClicked)))
        }
    }

    @objc func imageClicked(sender: GestureData) {
        Route.imageViewer(self, sender.strData)
    }

    @objc func goesClicked(sender: UIButton) {
        Route.visNhc(self, stormData.goesUrl)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in self.display() }
    }
}
