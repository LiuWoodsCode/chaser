// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcWpcText: UIwXViewControllerWithAudio {

    private var productButton = ToolbarIcon()
    private let menuData = MenuData(UtilityWpcText.titles, UtilityWpcText.labelsWithCodes, UtilityWpcText.getLabels())
    var wpcTextProduct = ""
    var savePrefs = true

    override func viewDidLoad() {
        super.viewDidLoad()
        product = "PMDSPD"
        UIApplication.shared.isIdleTimerDisabled = UIPreferences.screenOnForTts
        productButton = ToolbarIcon(self, #selector(showProductMenu))
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ToolbarItems(
            doneButton,
            GlobalVariables.flexBarButton,
            productButton,
            playButton,
            playListButton,
            shareButton).items
        objScrollStackView = ScrollStackView(self)
        textMain = Text(boxMain)
        textMain.constrain(scrollView)
        if wpcTextProduct == "" {
            product = Utility.readPref("WPCTEXT_PARAM_LAST_USED", product)
        } else {
            product = wpcTextProduct
            wpcTextProduct = ""
        }
        getContent()
    }

    @objc override func doneClicked() {
        UIApplication.shared.isIdleTimerDisabled = false
        super.doneClicked()
    }

    override func getContent() {
        // qos was .background
        // userInitiated
        // https://www.raywenderlich.com/148513/grand-central-dispatch-tutorial-swift-3-part-1
        // https://developer.apple.com/videos/play/wwdc2016/720/
//        DispatchQueue.global(qos: .userInitiated).async {
//            let html = UtilityDownload.getTextProduct(self.product.uppercased())
//            DispatchQueue.main.async { self.display(html) }
//        }
        _ = FutureText(product.uppercased(), display)
    }

    private func display(_ html: String) {
        textMain.text = html
        if UtilityWpcText.needsFixedWidthFont(product.uppercased()) {
            textMain.font = FontSize.hourly.size
        } else {
            textMain.font = FontSize.medium.size
        }
        productButton.setText(product.uppercased())
        if savePrefs {
            Utility.writePref("WPCTEXT_PARAM_LAST_USED", product)
        }
    }

    @objc func showProductMenu() {
        _ = PopUp(self, "Product Selection", productButton, menuData.objTitles, showSubMenu)
    }

    func showSubMenu(_ index: Int) {
        _ = PopUp(self, productButton, menuData.objTitles, index, menuData, productChanged)
    }

    func productChanged(_ index: Int) {
        let code = menuData.params[index].split(":")[0]
        scrollView.scrollToTop()
        product = code
        UtilityAudio.resetAudio(self)
        playButton.set(.play)
        getContent()
    }
}
