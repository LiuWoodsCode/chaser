// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcUSAlertsDetail: UIwXViewControllerWithAudio {

    private var cap = CapAlert()
    private var alertDetail: AlertDetail!
    var usAlertsDetailUrl = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        let radarButton = ToolbarIcon(self, .radar, #selector(radarClicked))
        playButton = ToolbarIcon(self, .play, #selector(playClicked))
        toolbar.items = ToolbarItems(
            doneButton,
            GlobalVariables.flexBarButton,
            playButton,
            shareButton,
            radarButton).items
        objScrollStackView = ScrollStackView(self)
        getContent()
    }

    override func getContent() {
        boxMain.spacing = 0
        alertDetail = AlertDetail(boxMain)
        _ = FutureVoid({ self.cap = CapAlert(url: self.usAlertsDetailUrl) }, display)
    }

    private func display() {
        alertDetail.updateContent(scrollView, cap)
//        var hailUnit = ""
//        if cap.maxHailSize == "0" {
//            cap.maxHailSize = ""
//        }
//        if cap.maxHailSize != "" {
//            hailUnit = " in"
//        }
//        let statusButtonTitle = cap.windThreat.replace("RADAR INDICATED", "") + " " + cap.maxWindGust + " " + cap.hailThreat.replace("RADAR INDICATED", "") + " " + cap.maxHailSize + hailUnit + " " + cap.tornadoThreat
//        if statusButtonTitle.count > 10 {
//            statusButton.title = statusButtonTitle.truncate(10)
//            if toolbar.items!.contains(statusButton!) {
//            } else {
//                toolbarItems1.insert(1, statusButton!)
//                toolbar.items = toolbarItems1.items
//            }
//        }
    }

    override func playClicked() {
        UtilityAudio.playClicked(cap.text, synthesizer, playButton)
    }

    override func shareClicked(sender: UIButton) {
        UtilityShare.share(self, sender, cap.text.removeHtml())
    }

    @objc func radarClicked() {
        Route.radarNoSave(self, cap.getClosestRadar())
    }
}
