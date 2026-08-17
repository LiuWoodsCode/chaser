// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcOpc: UIwXViewController {

    private var touchImage = TouchImage()
    private var productButton = ToolbarIcon()
    private var index = 0
    private let prefToken = "OPC_IMG_FAV_URL"

    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton = ToolbarIcon(self, .done, #selector(doneClicked), forceLight: true)
        let toolbarTop = Toolbar()
        productButton = ToolbarIcon(self, #selector(productClicked))
        toolbarTop.items = ToolbarItems(productButton).items
        let shareButton = ToolbarIcon(self, .share, #selector(share), forceLight: true)
        toolbar.items = ToolbarItems(doneButton, GlobalVariables.flexBarButton, shareButton).items
        touchImage = TouchImage(self, toolbar, #selector(handleSwipes))
        index = Utility.readPrefInt(prefToken, index)
        view.addSubview(toolbarTop)
        toolbarTop.setConfigWithUiv(self, toolbarType: .top)
        getContent(index)
    }

    override func willEnterForeground() {
        getContent(index)
    }

    func getContent(_ index: Int) {
        self.index = index
        Utility.writePrefInt(prefToken, index)
        productButton.setText(UtilityOpcImages.labels[index], forceLight: true)
        _ = FutureBytes(UtilityOpcImages.urls[index], touchImage.set)
    }

    @objc func productClicked() {
        _ = PopUp(self, productButton, UtilityOpcImages.labels, getContent)
    }

    @objc func share(sender: UIButton) {
        UtilityShare.image(self, sender, touchImage.getBitmap())
    }

    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        getContent(UtilityUI.sideSwipe(sender, index, UtilityOpcImages.urls))
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in self.touchImage.refresh() }
    }
}
