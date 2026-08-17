// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcGoesGlobal: UIwXViewController {

    private var touchImage = TouchImage()
    private var productButton = ToolbarIcon()
    private var index = 0
    private var animateButton = ToolbarIcon()
    private var shareButton = ToolbarIcon()
    private let prefToken = "GOESFULLDISK_IMG_FAV_URL"

    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton = ToolbarIcon(self, .done, #selector(doneClicked), forceLight: true)
        let toolbarTop = Toolbar()
        productButton = ToolbarIcon(self, #selector(productClicked))
        toolbarTop.items = ToolbarItems(productButton).items
        animateButton = ToolbarIcon(self, .play, #selector(getAnimation), forceLight: true)
        shareButton = ToolbarIcon(self, .share, #selector(shareClicked), forceLight: true)
        toolbar.items = ToolbarItems(doneButton, GlobalVariables.flexBarButton, animateButton, shareButton).items
        touchImage = TouchImage(self, toolbar, #selector(handleSwipes))
        index = Utility.readPrefInt(prefToken, index)
        if index >= UtilityGoesFullDisk.labels.count {
            index = UtilityGoesFullDisk.labels.count - 1
        }
        view.addSubview(toolbarTop)
        toolbarTop.setConfigWithUiv(self, toolbarType: .top)
        getContent(index)
    }

    override func willEnterForeground() {
        getContent(index)
    }

    func getContent(_ index: Int) {
        self.index = index
        productButton.title = UtilityGoesFullDisk.labels[index]
        if UtilityGoesFullDisk.canAnimate(UtilityGoesFullDisk.urls[index]) {
            showAnimateButton()
        } else {
            hideAnimateButton()
        }
        _ = FutureBytes(UtilityGoesFullDisk.urls[index], display)
    }

    private func display(_ bitmap: Bitmap) {
        touchImage.set(bitmap)
//        if UtilityGoesFullDisk.urls[index].contains("jma") {
//        if UtilityGoesFullDisk.canAnimate(UtilityGoesFullDisk.urls[index]) {
//            showAnimateButton()
//        } else {
//            hideAnimateButton()
//        }
        Utility.writePrefInt(prefToken, index)
    }

    func showAnimateButton() {
        toolbar.items = ToolbarItems(doneButton, GlobalVariables.flexBarButton, animateButton, shareButton).items
    }

    func hideAnimateButton() {
        toolbar.items = ToolbarItems(doneButton, GlobalVariables.flexBarButton, shareButton).items
    }

    @objc func productClicked() {
        _ = PopUp(self, productButton, UtilityGoesFullDisk.labels, getContent)
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.image(self, sender, touchImage.getBitmap())
    }

    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        getContent(UtilityUI.sideSwipe(sender, index, UtilityGoesFullDisk.urls))
    }

    @objc func getAnimation() {
        _ = FutureAnimation({ UtilityGoesFullDisk.getAnimation(UtilityGoesFullDisk.urls[self.index]) }, touchImage.startAnimating)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in self.touchImage.refresh() }
    }
}
