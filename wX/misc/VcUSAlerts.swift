// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit
import AVFoundation

final class VcUSAlerts: UIwXViewController {

    private var capAlerts = [CapAlert]()
    private var filter = ""
    private var filterButton = ToolbarIcon()
    private var alertSummary = AlertSummary()
    private var filterGesture: GestureData!
    private var filterShown = false
    private var boxImage = VBox()
    private var boxText = VBox()
    private var image = Image()
    private var bitmap = Bitmap()
    private let imageUrl = "https://forecast.weather.gov/wwamap/png/US.png"

    override func viewDidLoad() {
        super.viewDidLoad()
        filterButton = ToolbarIcon(self, #selector(filterClicked))
        filterGesture = GestureData(self, #selector(filterClicked))
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ToolbarItems(doneButton, GlobalVariables.flexBarButton, filterButton, shareButton).items
        boxText.spacing = 1.0
        objScrollStackView = ScrollStackView(self)
        boxMain.addLayout(boxImage)
        boxMain.addLayout(boxText)
        boxImage.constrain(self)
        boxText.constrain(self)
        image = Image(boxImage)
        image.connect(GestureData(self, #selector(imageClicked)))
        getContent()
    }

    override func getContent() {
        _ = FutureVoid(downloadText, display)
        _ = FutureBytes(imageUrl, image.set)
    }

    func downloadText() {
        capAlerts.removeAll()
        let html = UtilityDownloadNws.getCap("us")
        let alerts = html.parseColumn("<entry>(.*?)</entry>")
        alerts.forEach {
            capAlerts.append(CapAlert(eventText: $0))
        }
    }

    private func display() {
        boxText.removeChildren()
        if !filterShown {
            filterButton.setText("Tornado/ThunderStorm/FFW")
            alertSummary = AlertSummary(self, boxText, "", capAlerts, filterGesture)
        } else {
            filterChanged(filter)
        }
    }

    @objc func warningSelected(sender: GestureData) {
        Route.alertDetail(self, sender.strData)
    }

    @objc func goToRadar(sender: GestureData) {
        Route.radarNoSave(self, sender.strData)
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.image(self, sender, bitmap)
    }

    @objc func filterClicked() {
        var eventArr = [String]()
        var counts = [String: Int]()
        var eventArrWithCount = [String]()
        capAlerts.forEach {
            eventArr.append($0.event)
        }
        eventArr.forEach {
            counts[$0] = (counts[$0] ?? 0) + 1
        }
        Array(counts.keys).sorted().forEach {
            eventArrWithCount.append($0 + ": " + To.string(counts[$0]!))
        }
        _ = PopUp(self, title: "Filter Selection", filterButton, eventArrWithCount, filterChanged)
    }

    func filterChanged(_ filter: String) {
        boxText.removeChildren()
        filterButton.setText(filter)
        alertSummary = AlertSummary(self, boxText, filter, capAlerts, filterGesture)
        filterShown = true
        self.filter = filter
    }

    @objc func imageClicked() {
        Route.imageViewer(self, imageUrl)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in self.display() }
    }
}
