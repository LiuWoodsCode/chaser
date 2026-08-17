// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcRadarMosaic: UIwXViewController {

    private var touchImage = TouchImage()
    private var sectorButton = ToolbarIcon()
    private var animateButton = ToolbarIcon()
    private let prefTokenSector = "REMEMBER_NWSMOSAIC_SECTOR"
    private var sector = "CONUS"
    private var isLocal = false
    var nwsMosaicType = ""
    private var index = 0
    var objectAnimate: ObjectAnimate!

    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton = ToolbarIcon(self, .done, #selector(doneClicked), forceLight: true)
        sectorButton = ToolbarIcon(self, #selector(sectorClicked))
        animateButton = ToolbarIcon(self, .play, #selector(animateClicked), forceLight: true)
        let shareButton = ToolbarIcon(self, .share, #selector(share), forceLight: true)
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, sectorButton, animateButton, shareButton]).items
        touchImage = TouchImage(self, toolbar, #selector(handleSwipes))
        objectAnimate = ObjectAnimate(self, touchImage, animateButton, downloadForAnimation, [])
        sector = Utility.readPref(prefTokenSector, sector)
        if nwsMosaicType == "local" {
            nwsMosaicType = ""
            isLocal = true
            sector = UtilityRadarMosaic.getNearest(Location.latLon)
        }
        index = UtilityRadarMosaic.sectors.firstIndex(of: sector)!
        getContent()
    }

    override func getContent() {
        animateButton.set(.play)
        sectorButton.setText(sector, forceLight: true)
        if !isLocal {
            Utility.writePref(prefTokenSector, sector)
        }
        _ = FutureBytes(UtilityRadarMosaic.get(sector), touchImage.set)
    }

    @objc func sectorClicked() {
        _ = PopUp(self, title: "Sector Selection", sectorButton, UtilityRadarMosaic.labels, sectorChanged)
    }

    func sectorChanged(_ index: Int) {
        sector = UtilityRadarMosaic.sectors[index]
        getContent()
    }

    @objc func share(sender: UIButton) {
        UtilityShare.image(self, sender, touchImage.getBitmap())
    }

    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        index = UtilityUI.sideSwipe(sender, index, UtilityRadarMosaic.sectors)
        sectorChanged(index)
    }

    @objc func animateClicked() {
        objectAnimate.animateClicked()
    }

    func downloadForAnimation(_ frameCount: Int) {
        _ = FutureAnimation({ UtilityRadarMosaic.getAnimation(self.sector) }, touchImage.startAnimating)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in self.touchImage.refresh() }
    }
}
