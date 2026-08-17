// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcImageViewer: UIwXViewController {

    private var touchImage = TouchImage()
    var url = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton = ToolbarIcon(self, .done, #selector(doneClicked), forceLight: true)
        let shareButton = ToolbarIcon(self, .share, #selector(share), forceLight: true)
        toolbar.items = ToolbarItems(doneButton, GlobalVariables.flexBarButton, shareButton).items
        getContent()
    }

    override func willEnterForeground() {}

    override func getContent() {
        _ = FutureBytes(url, display)
    }

    private func display(_ bitmap: Bitmap) {
        touchImage = TouchImage(self, toolbar, bitmap)
    }

    @objc func share(sender: UIButton) {
        UtilityShare.image(self, sender, touchImage.getBitmap())
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in self.touchImage.refresh() }
    }
}
