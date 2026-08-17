// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit
import AVFoundation

final class VcSevereDashboard: UIwXViewController {

    private var buttonActions = [String]()
    private var severeNotices = [PolygonEnum: SevereNotice]()
    private var severeWarnings = [PolygonEnum: SevereWarning]()
    private var bitmap = Bitmap()
    private var usAlertsBitmap = Bitmap()
    private var statusButton = ToolbarIcon()
    private var toolbarItems1: ToolbarItems!
    private var statusWarnings = ""
    private var downloadTimer = DownloadTimer("SEVERE_DASHBOARD_ACTIVITY")

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ToolbarIcon(self, .share, #selector(share))
        statusButton = ToolbarIcon(self, nil)
        toolbarItems1 = ToolbarItems(doneButton, GlobalVariables.flexBarButton, shareButton)
        toolbar.items = toolbarItems1.items
        objScrollStackView = ScrollStackView(self)
        boxMain.constrain(self)
        for notice in [PolygonEnum.SPCWAT, PolygonEnum.SPCMCD, PolygonEnum.WPCMPD] {
            severeNotices[notice] = SevereNotice(notice)
        }
        for notice in [PolygonEnum.TOR, PolygonEnum.TST, PolygonEnum.FFW] {
            severeWarnings[notice] = SevereWarning(notice)
        }
        getContent()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getContent()
    }

    override func getContent() {
        if downloadTimer.isRefreshNeeded() {
            for notice in [PolygonEnum.SPCWAT, PolygonEnum.SPCMCD, PolygonEnum.WPCMPD] {
                _ = FutureVoid(severeNotices[notice]!.download, display)
            }
            for warning in [PolygonEnum.TOR, PolygonEnum.TST, PolygonEnum.FFW] {
                _ = FutureVoid(severeWarnings[warning]!.download, display)
            }
            _ = FutureVoid({ self.usAlertsBitmap = Bitmap("https://forecast.weather.gov/wwamap/png/US.png") }, display)
            _ = FutureVoid({ self.bitmap = Bitmap(GlobalVariables.nwsSPCwebsitePrefix + "/climo/reports/" + "today" + ".gif") }, display)
        }
    }

    @objc func imageClicked(sender: GestureData) {
        let token = buttonActions[sender.data]
        if token.hasPrefix("WPCMPD") {
            Route.spcMcdWatchItem(self, .WPCMPD, token.replace("WPCMPD", ""))
        } else if buttonActions[sender.data].hasPrefix("SPCMCD") {
            Route.spcMcdWatchItem(self, .SPCMCD, token.replace("SPCMCD", ""))
        } else if buttonActions[sender.data].hasPrefix("SPCWAT") {
            Route.spcMcdWatchItem(self, .SPCWAT, token.replace("SPCWAT", ""))
        }
    }

    func showTextWarnings() {
        var warningPresent = false
        [PolygonEnum.TOR, PolygonEnum.TST, PolygonEnum.FFW].forEach {
            let severeWarning = severeWarnings[$0]!
            if severeWarning.getCount() > 0 {
                _ = CardBlackHeaderText(boxMain, "(" + String(severeWarning.getCount()) + ") " + severeWarning.getName())
            }
            for w in severeWarning.warningList where w.isCurrent {
                let radarSite = w.getClosestRadar()
                boxMain.addWidget(CardDashAlertItem(
                    w,
                    GestureData(w.url, self, #selector(goToAlert(sender:))),
                    GestureData(radarSite, self, #selector(goToRadar(sender:))),
                    GestureData(radarSite, self, #selector(goToRadar(sender:)))
                ))
            }
            if severeWarning.getCount() > 0 {
                warningPresent = true
            }
        }
        if warningPresent {
            statusWarnings = "(" + severeWarnings[.TOR]!.getCount() + "," + severeWarnings[.TST]!.getCount() + "," + severeWarnings[.FFW]!.getCount() + ")"
        } else {
            statusWarnings = ""
        }
    }

    @objc func goToAlerts() {
        Route.alerts(self)
    }

    @objc func goToAlert(sender: GestureData) {
        Route.alertDetail(self, sender.strData)
    }

    @objc func goToRadar(sender: GestureData) {
        Route.radarNoSave(self, sender.strData)
    }

    @objc func spcStormReportsClicked() {
        Route.spcStormReports(self, "today")
    }

    @objc func share(sender: UIButton) {
        UtilityShare.image(self, sender, [bitmap, usAlertsBitmap] + severeNotices[PolygonEnum.SPCWAT]!.bitmaps + severeNotices[PolygonEnum.SPCMCD]!.bitmaps + severeNotices[PolygonEnum.WPCMPD]!.bitmaps)
    }

    private func display() {
        boxMain.removeChildren()
        var views = [UIView]()
        buttonActions = [String]()
        var imageCount = 0
        var imagesPerRow = 2
        var boxRows = [HBox]()
        let noticeCount = getNoticeCount()
        if UtilityUI.isTablet() && UtilityUI.isLandscape() {
            imagesPerRow = 3
        }
        if noticeCount == 0 && UtilityUI.isLandscape() {
            imagesPerRow = 2
        }
        #if targetEnvironment(macCatalyst)
        imagesPerRow = 3
        #endif
        let objectImage: Image
        if imageCount % imagesPerRow == 0 {
            let hbox = HBox(.fillEqually)
            boxRows.append(hbox)
            boxMain.addLayout(hbox)
            objectImage = Image(
                hbox,
                usAlertsBitmap,
                GestureData(self, #selector(goToAlerts)),
                widthDivider: imagesPerRow
            )
        } else {
            objectImage = Image(
                boxRows.last!,
                usAlertsBitmap,
                GestureData(self, #selector(goToAlerts)),
                widthDivider: imagesPerRow
            )
        }
        imageCount += 1
        objectImage.accessibilityLabel = "US Alerts"
        objectImage.isAccessibilityElement = true
        views.append(objectImage.getView())
        let objectImage2: Image
        if imageCount % imagesPerRow == 0 {
            let hbox = HBox(.fillEqually)
            boxRows.append(hbox)
            boxMain.addLayout(hbox)
            objectImage2 = Image(
                boxMain,
                bitmap,
                GestureData(self, #selector(spcStormReportsClicked)),
                widthDivider: imagesPerRow
            )
        } else {
            objectImage2 = Image(
                boxRows.last!,
                bitmap,
                GestureData(self, #selector(spcStormReportsClicked)),
                widthDivider: imagesPerRow
            )
        }
        imageCount += 1
        objectImage2.accessibilityLabel = "spc storm reports"
        objectImage2.isAccessibilityElement = true
        views.append(objectImage2.getView())
        var index = 0
        [PolygonEnum.SPCWAT, PolygonEnum.SPCMCD, PolygonEnum.WPCMPD].forEach { type1 in
            severeNotices[type1]?.bitmaps.enumerated().forEach { imageIndex, image in
                let stackView1: HBox
                if imageCount % imagesPerRow == 0 {
                    let hbox = HBox(.fillEqually)
                    boxRows.append(hbox)
                    stackView1 = hbox
                    boxMain.addLayout(stackView1)
                } else {
                    stackView1 = boxRows.last!
                }
                let objectImage = Image(
                    stackView1,
                    image,
                    GestureData(index, self, #selector(imageClicked)),
                    widthDivider: imagesPerRow
                )
                buttonActions.append(String(describing: type1) + (severeNotices[type1]?.numberList[imageIndex])!)
                objectImage.accessibilityLabel = String(describing: type1) + (severeNotices[type1]?.numberList[imageIndex])!
                objectImage.isAccessibilityElement = true
                views.append(objectImage.getView())
                index += 1
                imageCount += 1
            }
        }
        showTextWarnings()
        view.bringSubviewToFront(toolbar)
        scrollView.accessibilityElements = views
        var status = ""
        let warningLabel = ["W", "M", "P"]
        [PolygonEnum.SPCWAT, PolygonEnum.SPCMCD, PolygonEnum.WPCMPD].enumerated().forEach { index, type1 in
            if (severeNotices[type1]?.bitmaps.count)! > 0 {
                status += warningLabel[index] + "(" + To.string(severeNotices[type1]!.getCount()) + ") "
            }
        }
        let statusButtonTitle = status + " " + statusWarnings
        if statusButtonTitle.count > 2 {
            if toolbar.items!.contains(statusButton) {
            } else {
                toolbarItems1.insert(2, statusButton)
                toolbar.items = toolbarItems1.items
            }
        } else {
            if toolbar.items!.contains(statusButton) {
                toolbarItems1.items.remove(at: 2)
                toolbar.items = toolbarItems1.items
            }
        }
        statusButton.setText(statusButtonTitle)
    }

    func getNoticeCount() -> Int {
        var count = 0
        [PolygonEnum.SPCWAT, PolygonEnum.SPCMCD, PolygonEnum.WPCMPD].forEach { type1 in
            count += (severeNotices[type1]?.getCount())!
        }
        return count
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in self.display() }
    }
}
