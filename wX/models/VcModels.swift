// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcModels: UIwXViewController {

    private var touchImage = TouchImage()
    private var sectorButton = ToolbarIcon()
    private var modelButton = ToolbarIcon()
    private var runButton = ToolbarIcon()
    private var timeButton = ToolbarIcon()
    private var productButton = ToolbarIcon()
    private var menuData = MenuData(
        UtilityModelSpcHrefInterface.titles,
        UtilityModelSpcHrefInterface.params,
        UtilityModelSpcHrefInterface.labels
    )
    private var modelObj = ObjectModel()
    private var fabLeft: Fab?
    private var fabRight: Fab?
    var modelActivitySelected = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let toolbarTop = Toolbar()
        modelButton = ToolbarIcon("Model", self, #selector(modelClicked))
        sectorButton = ToolbarIcon("Sector", self, #selector(sectorClicked))
        runButton = ToolbarIcon("Run", self, #selector(runClicked))
        let animateButton = ToolbarIcon(self, .play, #selector(getAnimation), forceLight: true)
        toolbarTop.items = ToolbarItems(
            modelButton,
            sectorButton,
            runButton,
            animateButton).items
        if modelActivitySelected.contains("NCAR")
            || modelActivitySelected.contains("SPCSREF")
            || modelActivitySelected.contains("SPCHREF")
            || modelActivitySelected.contains("WPCGEFS") {
            productButton = ToolbarIcon("Product", self, #selector(showProdMenu))
        } else {
            productButton = ToolbarIcon("Product", self, #selector(prodClicked))
        }
        if modelActivitySelected.contains("SPCSREF") {
            menuData = MenuData(
                UtilityModelSpcSrefInterface.titles,
                UtilityModelSpcSrefInterface.params,
                UtilityModelSpcSrefInterface.labels
            )
        } else if modelActivitySelected.contains("SPCHREF") {
            menuData = MenuData(
                UtilityModelSpcHrefInterface.titles,
                UtilityModelSpcHrefInterface.params,
                UtilityModelSpcHrefInterface.labels
            )
        } else if modelActivitySelected.contains("WPCGEFS") {
            menuData = MenuData(
                UtilityModelWpcGefsInterface.titles,
                UtilityModelWpcGefsInterface.params,
                UtilityModelWpcGefsInterface.labels
            )
        }
        timeButton = ToolbarIcon("Time", self, #selector(timeClicked))
        let doneButton = ToolbarIcon(self, .done, #selector(doneClicked), forceLight: true)
        GlobalVariables.fixedSpace.width = UIPreferences.toolbarIconSpacing
        toolbar.items = ToolbarItems(
            doneButton,
            GlobalVariables.flexBarButton,
            productButton,
            timeButton).items
        view.addSubview(toolbarTop)
        toolbarTop.setConfigWithUiv(self, toolbarType: .top)
        touchImage = TouchImage(self, toolbar, #selector(handleSwipes(sender:)))
        fabLeft = Fab(self, #selector(leftClicked), iconType: .leftArrow)
        fabRight = Fab(self, #selector(rightClicked), iconType: .rightArrow)
        fabLeft?.setToTheLeft()
        modelObj = ObjectModel(modelActivitySelected)
        modelObj.setButtons(productButton, sectorButton, runButton, timeButton, modelButton)
        view.bringSubviewToFront(toolbarTop)
        setupModel()
        getRunStatus()
    }

    func getRunStatus() {
        _ = FutureVoid({ ObjectModelGet.runStatus(self.modelObj) }, updateAfterRunStatus)
    }

    private func updateAfterRunStatus() {
        modelObj.setRun(modelObj.runTimeData.mostRecentRun)
        if modelActivitySelected == "SPCHRRR"
            || modelActivitySelected == "SPCSREF"
            || modelActivitySelected == "SPCHREF" {
            modelObj.times = UtilityModels.updateTime(
                UtilityString.getLastXChars(modelObj.run, 2),
                modelObj.run,
                modelObj.times,
                ""
            )
        } else if !modelActivitySelected.contains("GLCFS") {
            modelObj.times.enumerated().forEach { idx, timeStr in
                modelObj.setTimeArr(
                    idx,
                    timeStr.split(" ")[0] + " "
                        + UtilityModels.convertTimeRunToTimeString(
                            modelObj.runTimeData.timeStringConversion.replace("Z", ""),
                            timeStr.split(" ")[0]
                    )
                )
            }
        }
        if modelObj.timeIdx >= modelObj.times.count {
            modelObj.setTimeIdx(modelObj.times.count - 1)
        }
        modelObj.timeButton.title = Utility.safeGet(modelObj.times, modelObj.timeIdx)
        getContent()
    }

    override func willEnterForeground() {}

    override func getContent() {
        _ = FutureBytes2({ ObjectModelGet.image(self.modelObj) }, display)
    }

    private func display(_ bitmap: Bitmap) {
        touchImage.set(bitmap)
        modelObj.setPreferences()
    }

    @objc func prodClicked() {
        _ = PopUp(self, productButton, modelObj.paramLabels, prodChanged)
    }

    @objc func showProdMenu() {
        _ = PopUp(self, "Product Selection", productButton, menuData.objTitles, showSubMenu)
    }

    func showSubMenu(_ index: Int) {
        _ = PopUp(self, productButton, menuData.objTitles, index, menuData, prodChanged)
    }

    @objc func sectorClicked() {
        _ = PopUp(self, title: "Region Selection", sectorButton, modelObj.sectors, sectorChanged)
    }

    func sectorChanged(_ sector: String) {
        modelObj.setSector(sector)
        getRunStatus()
    }

    @objc func runClicked() {
        _ = PopUp(self, title: "Run Selection", runButton, modelObj.runTimeData.listRun, runChanged)
    }

    func runChanged(_ run: String) {
        modelObj.setRun(run)
        getContent()
    }

    @objc func modelClicked() {
        _ = PopUp(self, title: "Model Selection", modelButton, modelObj.models, modelChanged)
    }

    func modelChanged(_ model: String) {
        modelObj.setModel(model)
        setupModel()
        getRunStatus()
    }

    @objc func leftClicked() {
        modelObj.leftClick()
        fabLeft?.close()
        getContent()
    }

    @objc func rightClicked() {
        modelObj.rightClick()
        fabRight?.close()
        getContent()
    }

    @objc func timeClicked() {
        _ = PopUp(self, title: "Time Selection", timeButton, modelObj.times, timeChanged)
    }

    func timeChanged(_ time: Int) {
        modelObj.setTimeIdx(time)
        getContent()
    }

    func prodChanged(_ prod: Int) {
        modelObj.setParam(prod)
        if modelActivitySelected.contains("SSEO") {
            modelObj.times.enumerated().forEach { idx, timeStr in
                modelObj.setTimeArr(
                    idx,
                    timeStr.split(" ")[0]
                        + " "
                        + UtilityModels.convertTimeRunToTimeString(
                            modelObj.runTimeData.timeStringConversion.replace("Z", ""),
                            timeStr.split(" ")[0]
                    )
                )
            }
        }
        getContent()
    }

    func setupModel() {
        modelObj.setModelVars(modelObj.model)
    }

    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            rightClicked()
        }
        if sender.direction == .right {
            leftClicked()
        }
    }

    @objc func getAnimation() {
        _ = FutureAnimation({ ObjectModelGet.animation(self.modelObj) }, touchImage.startAnimating)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in self.touchImage.refresh() }
    }
}
