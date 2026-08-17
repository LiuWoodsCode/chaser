// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcSpcCompMap: UIwXViewController {

    private var touchImage = TouchImage()
    private var productButton = ToolbarIcon()
    private var layers: Set = ["1"]

    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton = ToolbarIcon(self, .done, #selector(doneClicked), forceLight: true)
        productButton = ToolbarIcon("Layers", self, #selector(productClicked))
        let shareButton = ToolbarIcon(self, .share, #selector(share), forceLight: true)
        toolbar.items = ToolbarItems(doneButton, GlobalVariables.flexBarButton, productButton, shareButton).items
        touchImage = TouchImage(self, toolbar)
        layers = Set(WString.split(Utility.readPref("SPCCOMPMAP_LAYERSTRIOS", "7:19:"), ":"))
        getContent()
    }

    override func getContent() {
        Utility.writePref("SPCCOMPMAP_LAYERSTRIOS", WString.join(":", layers))
        _ = FutureBytes2({ UtilitySpcCompmap.getImage(self.layers) }, touchImage.set)
    }

    @objc func productClicked() {
        let popUp = PopUp(self, productButton, "Layer Selection")
        (["Clear All"] + UtilitySpcCompmap.labels).enumerated().forEach { index, rid in
            var pre = ""
            if index > 0 && layers.contains(UtilitySpcCompmap.urlIndices[UtilitySpcCompmap.labels.firstIndex(of: rid)!]) {
                pre = "(on) "
            }
            popUp.add(Action(pre + rid) { self.productChanged(index) })
        }
        popUp.finish()
    }

    func productChanged(_ product: Int) {
        if product == 0 {
            layers = []
            getContent()
            return
        }
        let prodLocal = product - 1
        if layers.contains(UtilitySpcCompmap.urlIndices[prodLocal]) {
            layers.remove(UtilitySpcCompmap.urlIndices[prodLocal])
        } else {
            layers.insert(UtilitySpcCompmap.urlIndices[prodLocal])
        }
        getContent()
    }

    @objc func share(sender: UIButton) {
        UtilityShare.image(self, sender, touchImage.getBitmap())
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in self.touchImage.refresh() }
    }
}
