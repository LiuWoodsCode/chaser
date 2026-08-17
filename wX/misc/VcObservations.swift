// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcObservations: UIwXViewController {

    private var touchImage = TouchImage()
    private var productButton = ToolbarIcon()
    private var rtmaButton = ToolbarIcon()
    private var index = 0
    private let prefTokenIndex = "SFC_OBS_IMG_IDX"

    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton = ToolbarIcon(self, .done, #selector(doneClicked), forceLight: true)
        let toolbarTop = Toolbar()
        productButton = ToolbarIcon(self, #selector(productClicked))
        toolbarTop.items = ToolbarItems(productButton).items
        rtmaButton = ToolbarIcon(self, #selector(rtmaClicked))
        rtmaButton.title = "RTMA"
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked), forceLight: true)
        toolbar.items = ToolbarItems(
            doneButton,
            GlobalVariables.flexBarButton,
            rtmaButton,
            shareButton).items
        touchImage = TouchImage(self, toolbar, #selector(handleSwipes))
        touchImage.setMaxScaleFromMinScale(10.0)
        touchImage.setKZoomInFactorFromMinWhenDoubleTap(8.0)
        index = Utility.readPrefInt(prefTokenIndex, 0)
        view.addSubview(toolbarTop)
        toolbarTop.setConfigWithUiv(self, toolbarType: .top)
        getContent(index)
    }

    override func willEnterForeground() {
        getContent(index)
    }

    func getContent(_ index: Int) {
        self.index = index
        Utility.writePrefInt(prefTokenIndex, index)
        productButton.setText(UtilityObservations.labels[index], forceLight: true)
        _ = FutureBytes(UtilityObservations.urls[index], touchImage.set)
    }

    @objc func productClicked() {
        _ = PopUp(self, productButton, UtilityObservations.labels, getContent)
    }

    @objc func rtmaClicked() {
        Route.rtma(self, "2m_temp")
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.image(self, sender, touchImage.getBitmap())
    }

    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        getContent(UtilityUI.sideSwipe(sender, index, UtilityObservations.urls))
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in self.touchImage.refresh() }
    }
}
