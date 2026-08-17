// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit
import AVFoundation

final class VcAdhocLocation: UIwXViewController {

    private let cardLocation = CardHomeScreen()
    private var locationLabel = Text()
    private var currentConditions = CurrentConditions()
    private var hazards = Hazards()
    private var sevenDay = SevenDay()
    private var boxCc = VBox()
    private var boxHazards = VBox()
    private var boxSevenDay = VBox()
    var saveButton = ToolbarIcon()
    var latLon = LatLon()
    private var locationName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        locationName = latLon.prettyPrint() + " - " + UtilityLocation.getNearestCity(latLon)
        saveButton = ToolbarIcon("", self, #selector(save))
        toolbar.items = ToolbarItems(doneButton, GlobalVariables.flexBarButton, saveButton).items
        saveButton.setText("Save " + latLon.latForNws + ", " + latLon.lonForNws)
        objScrollStackView = ScrollStackView(self)
        boxMain.constrain(self)
        locationLabel = Text(cardLocation, locationName, FontSize.extraLarge.size, ColorCompatibility.highlightText)
        locationLabel.isSelectable = false
        boxMain.addLayout(cardLocation)
        cardLocation.setup(boxMain)
        boxMain.addLayout(boxCc)
        boxMain.addLayout(boxHazards)
        boxMain.addLayout(boxSevenDay)
        getContent()
    }

    override func getContent() {
        _ = FutureVoid({ self.currentConditions.process(self.latLon) }, {
            _ = CardCurrentConditions(self.boxCc, self.currentConditions)
        })
        _ = FutureVoid({ self.hazards.process(self.latLon) }, {
            CardHazards.get(self, self.boxHazards, self.hazards)
        })
        _ = FutureVoid({ self.sevenDay = SevenDay(self.latLon) }, {
            _ = SevenDayCollection(self.boxSevenDay, self.scrollView, self.sevenDay)
        })
    }

    @objc func save() {
        let status = Location.save(latLon, locationName)
        let popup = PopUp(self, saveButton, status)
        popup.finish()
    }
}
