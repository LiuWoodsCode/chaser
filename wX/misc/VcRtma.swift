// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcRtma: UIwXViewController {

    private var touchImage = TouchImage()
    private var productButton = ToolbarIcon()
    private var sectorButton = ToolbarIcon()
    private var timeButton = ToolbarIcon()
    private var runTimes = [String]()
    private var sectorCode = ""
    private var time = ""
    var productCode = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton = ToolbarIcon(self, .done, #selector(doneClicked), forceLight: true)
        let toolbarTop = Toolbar()
        productButton = ToolbarIcon(self, #selector(productClicked))
        sectorButton = ToolbarIcon(self, #selector(sectorClicked))
        productButton.title = productCode
        timeButton = ToolbarIcon(self, #selector(timeClicked))
        toolbarTop.items = ToolbarItems([
            GlobalVariables.flexBarButton,
            timeButton
        ]).items
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked), forceLight: true)
        toolbar.items = ToolbarItems(
            doneButton,
            GlobalVariables.flexBarButton,
            productButton,
            sectorButton,
            shareButton).items
        touchImage = TouchImage(self, toolbar) // , #selector(handleSwipes))
        sectorCode = UtilityRtma.getNearest(Location.latLon)
        sectorButton.title = sectorCode
        view.addSubview(toolbarTop)
        toolbarTop.setConfigWithUiv(self, toolbarType: .top)
        _ = FutureVoid(getRunTime, getContent)
    }

    override func willEnterForeground() {
        getContent()
    }

    private func getRunTime() {
        runTimes = UtilityRtma.getTimes()
        time = runTimes.first ?? ""
        timeButton.title = time
    }

    override func getContent() {
        _ = FutureBytes(UtilityRtma.getUrl(productCode, sectorCode, time), touchImage.set)
    }

    @objc func productClicked() {
        _ = PopUp(self, productButton, UtilityRtma.codes, productChanged)
    }

    @objc func sectorClicked() {
        _ = PopUp(self, sectorButton, UtilityRtma.sectors, sectorChanged)
    }

    @objc func timeClicked() {
        _ = PopUp(self, timeButton, runTimes, timeChanged)
    }

    func productChanged(_ index: Int) {
        productCode = UtilityRtma.codes[index]
        productButton.title = productCode
        getContent()
    }

    func sectorChanged(_ sector: String) {
        sectorCode = sector
        sectorButton.title = sector
        getContent()
    }

    func timeChanged(_ time: String) {
        self.time = time
        timeButton.title = time
        getContent()
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.image(self, sender, touchImage.getBitmap())
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in self.touchImage.refresh() }
    }
}
