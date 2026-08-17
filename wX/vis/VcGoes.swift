// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcGoes: UIwXViewController {

    private var touchImage = TouchImage()
    private var productButton = ToolbarIcon()
    private var sectorButton = ToolbarIcon()
    private var animateButton = ToolbarIcon()
    var savePrefs = true
    var productCode = ""
    var sectorCode = ""
    var goesFloater = false
    var url = ""
    var goesFloaterUrl = ""
    var objectAnimate: ObjectAnimate!

    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton = ToolbarIcon(self, .done, #selector(doneClicked), forceLight: true)
        productButton = ToolbarIcon(self, #selector(productClicked))
        sectorButton = ToolbarIcon(self, #selector(sectorClicked))
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked), forceLight: true)
        animateButton = ToolbarIcon(self, .play, #selector(animateClicked), forceLight: true)
        toolbar.items = ToolbarItems(
            doneButton,
            GlobalVariables.flexBarButton,
            sectorButton,
            productButton,
            animateButton,
            shareButton).items
        touchImage = TouchImage(self, toolbar)
        touchImage.setMaxScaleFromMinScale(10.0)
        touchImage.setKZoomInFactorFromMinWhenDoubleTap(8.0)

        objectAnimate = ObjectAnimate(self, touchImage, animateButton, downloadForAnimation, [12, 24, 36, 48, 60, 72, 84, 96])

        if url != "" {
            goesFloater = true
            goesFloaterUrl = url
            productCode = "GEOCOLOR"
            sectorCode = goesFloaterUrl
            productButton.title = productCode
        } else {
            deSerializeSettings()
        }
        getContent()
    }

    func serializeSettings() {
        if savePrefs {
            Utility.writePref("GOES16_PROD", productCode)
            Utility.writePref("GOES16_SECTOR", sectorCode)
        }
    }

    func deSerializeSettings() {
        if sectorCode == "" {
            productCode = Utility.readPref("GOES16_PROD", "GEOCOLOR")
            sectorCode = Utility.readPref("GOES16_SECTOR", "cgl")
            productButton.title = productCode
            sectorButton.title = sectorCode
        } else {
            productButton.title = productCode
            sectorButton.title = sectorCode
            savePrefs = false
        }
    }

    override func getContent() {
        animateButton.set(.play)
        if !goesFloater {
            _ = FutureBytes2({ UtilityGoes.getImage(self.productCode, self.sectorCode) }, display)
        } else {
            _ = FutureBytes(UtilityGoes.getImageGoesFloater(goesFloaterUrl, productCode), display)
        }
    }

    private func display(_ bitmap: Bitmap) {
        if !goesFloater {
            productButton.title = bitmap.info
            productCode = bitmap.info
            serializeSettings()
        }
        touchImage.set(bitmap)
    }

    @objc func productClicked() {
        _ = PopUp(self, productButton, UtilityGoes.labels, productChanged)
    }

    @objc func sectorClicked() {
        _ = PopUp(self, title: "Sector Selection", sectorButton, UtilityGoes.sectors, sectorChanged)
    }

    func productChanged(_ index: Int) {
        productCode = UtilityGoes.codes[index]
        productButton.title = productCode
        getContent()
    }

    func sectorChanged(_ sector: String) {
        sectorCode = sector
        sectorButton.title = sector
        getContent()
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.image(self, sender, touchImage.getBitmap())
    }

    @objc func animateClicked() {
        objectAnimate.animateClicked()
    }

    func downloadForAnimation(_ frameCount: Int) {
        if !goesFloater {
            _ = FutureAnimation({ UtilityGoes.getAnimation(self.productCode, self.sectorCode, frameCount) }, touchImage.startAnimating)
        } else {
            _ = FutureAnimation({ UtilityGoes.getAnimationGoesFloater(self.productCode, self.sectorCode, frameCount) }, touchImage.startAnimating)
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in self.touchImage.refresh() }
    }
}
