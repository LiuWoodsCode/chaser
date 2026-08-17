// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcSpotterReports: UIwXViewController {

    private var spotterReports = [SpotterReports]()
    private var spotterReportsSorted = [SpotterReports]()
    private var countButton = ToolbarIcon()

    override func viewDidLoad() {
        super.viewDidLoad()
        countButton = ToolbarIcon(self, nil)
        countButton.title = ""
        toolbar.items = ToolbarItems(doneButton, GlobalVariables.flexBarButton, countButton).items
        objScrollStackView = ScrollStackView(self)
        boxMain.constrain(self)
        getContent()
    }

    override func getContent() {
        spotterReports.removeAll()
        _ = FutureVoid({ self.spotterReports = UtilitySpotter.reportsList }, display)
    }

    func display() {
        boxMain.removeChildren()
        countButton.setText("Count: " + String(spotterReports.count))
        spotterReportsSorted = spotterReports.sorted { $1.time > $0.time }
        spotterReportsSorted.enumerated().forEach { index, item in
            _ = CardSpotterReport(boxMain, item, GestureData(index, self, #selector(buttonPressed)))
        }
        if spotterReports.count == 0 {
            let text = TextLarge(10, "No active spotter reports.", ColorCompatibility.highlightText)
            boxMain.addWidget(text)
        }
    }

    @objc func buttonPressed(sender: GestureData) {
        let index = sender.data
        let popUp = PopUp(self, countButton, "")
        popUp.add(Action("Show on map") { self.showMap(index) })
        popUp.finish()
    }

    func showMap(_ selection: Int) {
        Route.map(self, spotterReportsSorted[selection].location.latString, spotterReportsSorted[selection].location.lonString)
    }
}
