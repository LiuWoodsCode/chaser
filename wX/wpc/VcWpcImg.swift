// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcWpcImg: UIwXViewController {

    private var touchImage = TouchImage()
    private var productButton = ToolbarIcon()
    private var index = 0
    private var timePeriod = 1
    private let menuData = MenuData(UtilityWpcImages.titles, UtilityWpcImages.urls, UtilityWpcImages.labels)
    var wpcImagesFromHomeScreen = false
    var wpcImagesToken = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton = ToolbarIcon(self, .done, #selector(doneClicked), forceLight: true)
        let toolbarTop = Toolbar()
        productButton = ToolbarIcon(self, #selector(showProductMenu))
        productButton.title = "Select Product"
        toolbarTop.items = ToolbarItems(productButton).items
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked), forceLight: true)
        toolbar.items = ToolbarItems(doneButton, GlobalVariables.flexBarButton, shareButton).items
        touchImage = TouchImage(self, toolbar, #selector(handleSwipes))
        index = Utility.readPrefInt("WPCIMG_PARAM_LAST_USED", index)
        view.addSubview(toolbarTop)
        toolbarTop.setConfigWithUiv(self, toolbarType: .top)
        if wpcImagesFromHomeScreen {
            getContentFromHomeScreen()
            wpcImagesFromHomeScreen = false
        } else {
            getContent(index)
        }
    }

    override func willEnterForeground() {
        getContent(index)
    }

    func getContent(_ index: Int) {
        self.index = index
        let title = Utility.safeGet(UtilityWpcImages.labels, index)
        if title != "" {
            productButton.title = title
        }
        var url = Utility.safeGet(UtilityWpcImages.urls, index)
        if url.contains(GlobalVariables.nwsGraphicalWebsitePrefix + "/images/conus/") {
            url += String(timePeriod) + "_conus.png"
        }
        Utility.writePrefInt("WPCIMG_PARAM_LAST_USED", index)
        _ = FutureBytes(url, touchImage.set)
    }

    func getContentFromHomeScreen() {
        let titles = GlobalArrays.nwsImageProducts.filter { $0.hasPrefix(wpcImagesToken + ":") }
        if titles.count > 0 {
            productButton.title = titles[0].split(":")[1]
        }
        _ = FutureBytes2({ DownloadImage.byProduct(self.wpcImagesToken) }, touchImage.set)
    }

    @objc func showProductMenu() {
        _ = PopUp(self, "Product Selection", productButton, menuData.objTitles, showSubMenu, prefersCatalystList: true)
    }

    func showSubMenu(_ index: Int) {
        _ = PopUp(self, productButton, menuData.objTitles, index, menuData, getContent, prefersCatalystList: true)
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.image(self, sender, touchImage.getBitmap())
    }

    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        getContent(UtilityUI.sideSwipe(sender, index, UtilityWpcImages.urls))
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in self.touchImage.refresh() }
    }
}
