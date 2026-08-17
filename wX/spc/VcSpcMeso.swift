// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcSpcMeso: UIwXViewController {

    private var touchImage = TouchImage()
    private var sectorButton = ToolbarIcon()
    private var sfcButton = ToolbarIcon()
    private var cpeButton = ToolbarIcon()
    private var layerButton = ToolbarIcon()
    private var paramButton = ToolbarIcon()
    private var animateButton = ToolbarIcon()
    private var product = "500mb"
    var sector = "19"
    var sectorSpecified = false
    private let menuData = MenuData(UtilitySpcMeso.titles, UtilitySpcMeso.params, UtilitySpcMeso.labels)
    var spcMesoFromHomeScreen = false
    var spcMesoToken = ""
    var parameters = [String]()
    private let prefTokenProduct = "SPCMESO1_PARAM_LAST_USED"
    private let prefTokenSector = "SPCMESO1_SECTOR_LAST_USED"
    var objectAnimate: ObjectAnimate!

    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton = ToolbarIcon(self, .done, #selector(doneClicked), forceLight: true)
        let toolbarTop = Toolbar()
        layerButton = ToolbarIcon("Layers", self, #selector(layerClicked))
        animateButton = ToolbarIcon(self, .play, #selector(animateClicked), forceLight: true)
        let shareButton = ToolbarIcon(self, .share, #selector(share), forceLight: true)
        paramButton = ToolbarIcon(self, #selector(showProductMenu))
        toolbarTop.items = ToolbarItems(
            GlobalVariables.flexBarButton,
            paramButton,
            GlobalVariables.fixedSpace,
            layerButton,
            GlobalVariables.fixedSpace,
            animateButton,
            shareButton
        ).items
        sectorButton = ToolbarIcon("Sector", self, #selector(sectorClicked))
        sfcButton = ToolbarIcon("SFC/UA", self, #selector(paramClicked))
        cpeButton = ToolbarIcon("CPE/SH", self, #selector(paramClicked))
        toolbar.items = ToolbarItems(
            doneButton,
            GlobalVariables.flexBarButton,
            sfcButton,
            cpeButton,
            sectorButton).items
        view.addSubview(toolbarTop)
        touchImage = TouchImage(self, toolbar, hasTopToolbar: true, topToolbar: toolbarTop)
        touchImage.connect(#selector(handleSwipes))
        objectAnimate = ObjectAnimate(self, touchImage, animateButton, downloadForAnimation, [6, 12, 18])
        toolbarTop.setConfigWithUiv(self, toolbarType: .top)
        if spcMesoFromHomeScreen {
            product = spcMesoToken
            spcMesoFromHomeScreen = false
            sectorChanged(sector)
        } else {
            product = Utility.readPref(prefTokenProduct, product)
            if !sectorSpecified {
                sectorChanged(Utility.readPref(prefTokenSector, sector))
            } else {
                sectorChanged(sector)
            }
        }
    }

    override func getContent() {
        animateButton.set(.play)
        _ = FutureBytes2({ UtilitySpcMesoInputOutput.getImage(self.product, self.sector) }, display)
    }

    private func display(_ bitmap: Bitmap) {
        touchImage.set(bitmap)
        paramButton.title = product
        Utility.writePref(prefTokenProduct, product)
        if !sectorSpecified {
            Utility.writePref(prefTokenSector, sector)
        }
    }

    @objc func sectorClicked() {
        _ = PopUp(self, title: "", sectorButton, UtilitySpcMeso.sectors, sectorChangedByIndex)
    }

    func sectorChangedByIndex(_ index: Int) {
        sector = UtilitySpcMeso.sectorCodes[index]
        sectorButton.title = UtilitySpcMeso.sectorMapForTitle[sector] ?? ""
        getContent()
    }

    func sectorChanged(_ sector: String) {
        self.sector = sector
        sectorButton.title = UtilitySpcMeso.sectorMapForTitle[sector] ?? ""
        getContent()
    }

    @objc func share(sender: UIButton) {
        UtilityShare.image(self, sender, touchImage.getBitmap())
    }

    @objc func paramClicked(sender: ToolbarIcon) {
        switch sender.title! {
        case "SFC/UA":
            parameters = UtilitySpcMeso.paramSurfaceAndUA
        case "CPE/SH":
            parameters = UtilitySpcMeso.paramCapeAndCompAndShear
        default:
            break
        }
        let labels = parameters.map { $0.split(":")[1] }
        _ = PopUp(self, title: "", sender, labels, productChangedBySubmenu)
    }

    @objc func layerClicked() {
        let popUp = PopUp(self, layerButton, "Toggle Layers")
        ["Radar", "SPC Outlooks", "Watches/Warnings", "Topography"].forEach { layer in
            var pre = ""
            if isLayerSelected(layer) {
                pre = "(on) "
            }
            popUp.add(Action(pre + layer) { self.layerChanged(layer) })
        }
        popUp.finish()
    }

    func layerChanged(_ layer: String) {
        switch layer {
        case "Radar":
            toggleLayer("SPCMESO_SHOW_RADAR")
        case "SPC Outlooks":
            toggleLayer("SPCMESO_SHOW_OUTLOOK")
        case "Watches/Warnings":
            toggleLayer("SPCMESO_SHOW_WATWARN")
        case "Topography":
            toggleLayer("SPCMESO_SHOW_TOPO")
        default:
            break
        }
        getContent()
    }

    func isLayerSelected(_ layer: String) -> Bool {
        var isSelected = "false"
        switch layer {
        case "Radar":
            isSelected = Utility.readPref("SPCMESO_SHOW_RADAR", "false")
        case "SPC Outlooks":
            isSelected = Utility.readPref("SPCMESO_SHOW_OUTLOOK", "false")
        case "Watches/Warnings":
            isSelected = Utility.readPref("SPCMESO_SHOW_WATWARN", "false")
        case "Topography":
            isSelected = Utility.readPref("SPCMESO_SHOW_TOPO", "false")
        default:
            break
        }
        return isSelected == "true"
    }

    func toggleLayer(_ prefVar: String) {
        let currentValue = Utility.readPref(prefVar, "false").hasPrefix("true")
        if currentValue {
            Utility.writePref(prefVar, "false")
        } else {
            Utility.writePref(prefVar, "true")
        }
    }

    @objc func animateClicked() {
        objectAnimate.animateClicked()
    }

    func downloadForAnimation(_ frameCount: Int) {
        _ = FutureAnimation({ UtilitySpcMesoInputOutput.getAnimation(self.sector, self.product, frameCount) }, touchImage.startAnimating)
    }

    @objc func showProductMenu() {
        _ = PopUp(self, "", paramButton, menuData.objTitles, showSubMenu)
    }

    func showSubMenu(_ index: Int) {
        _ = PopUp(self, paramButton, menuData.objTitles, index, menuData, productChanged)
    }

    func productChangedBySubmenu(_ index: Int) {
        product = parameters[index].split(":")[0]
        getContent()
    }

    func productChangedByCode(_ product: String) {
        self.product = product
        getContent()
    }

    func productChanged(_ index: Int) {
        let product = menuData.params[index]
        self.product = product
        getContent()
    }

    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        var index = 0
        if let product = UtilitySpcMeso.productShortList.firstIndex(of: product) {
            index = UtilityUI.sideSwipe(sender, product, UtilitySpcMeso.productShortList)
        }
        productChangedByCode(UtilitySpcMeso.productShortList[index])
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in self.touchImage.refresh() }
    }
}
