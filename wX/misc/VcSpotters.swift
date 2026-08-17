// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcSpotters: UIwXViewController {

    private var spotterData = [Spotter]()
    private var spotterDataSorted = [Spotter]()
    private var spotterCountButton = ToolbarIcon()
    private var spotterReportsButton = ToolbarIcon()

    override func viewDidLoad() {
        super.viewDidLoad()
        spotterCountButton = ToolbarIcon(self, nil)
        spotterReportsButton = ToolbarIcon(self, #selector(showSpotterReports))
        toolbar.items = ToolbarItems(
            doneButton,
            GlobalVariables.flexBarButton,
            spotterCountButton,
            spotterReportsButton).items
        objScrollStackView = ScrollStackView(self)
        boxMain.constrain(self)
        getContent()
    }

    override func getContent() {
        spotterData.removeAll()
        _ = FutureVoid({ self.spotterData = UtilitySpotter.get() }, display)
    }

    private func display() {
        boxMain.removeChildren()
        spotterCountButton.setText("Count: " + String(spotterData.count))
        spotterReportsButton.setText("Spotter Reports")
        spotterDataSorted = spotterData.sorted { $1.lastName > $0.lastName }
        spotterDataSorted.enumerated().forEach { index, item in
            _ = CardSpotter(boxMain, item, GestureData(index, self, #selector(buttonPressed)))
        }
    }

    @objc func showSpotterReports() {
        Route.spotterReports(self)
    }

    @objc func buttonPressed(sender: GestureData) {
        let index = sender.data
        let popUp = PopUp(self, spotterReportsButton, "")
        popUp.add(Action("Show on map") { self.showMap(index) })
        popUp.finish()
    }

    func showMap(_ selection: Int) {
        Route.map(self, spotterDataSorted[selection].location.latString, spotterDataSorted[selection].location.lonString)
    }
}
