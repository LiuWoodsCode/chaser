// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcSettingsLocation: UIwXViewController {

    private var addLocationButton = ToolbarIcon()
    private var locationCards = [CardLocationItem]()
    private var currentConditions = [CurrentConditions]()

    override func viewDidLoad() {
        super.viewDidLoad()
        addLocationButton = ToolbarIcon(self, .plus, #selector(addClicked))
        toolbar.items = ToolbarItems(doneButton, GlobalVariables.flexBarButton, addLocationButton).items
        objScrollStackView = ScrollStackView(self)
        boxMain.constrain(self)
    }

    override func willEnterForeground() {}

    override func getContent() {
        currentConditions.removeAll()
        _ = FutureVoid(download, update)
    }

    func download() {
        Location.locations.forEach {
            currentConditions.append(CurrentConditions())
            currentConditions.last?.process($0.latLon)
        }
    }

    func update() {
        locationCards.indices.forEach { index in
            locationCards[index].setConditions(currentConditions[index].topLine)
            Location.updateObservation(index, currentConditions[index].topLine)
        }
    }

    override func doneClicked() {
        Location.refresh()
        super.doneClicked()
    }

    @objc func addClicked() {
        Route.locationAdd(self)
    }

    @objc func actionLocationPopup(sender: GestureData) {
        let locName = Location.getName(sender.data)
        let popUp = PopUp(self, addLocationButton, locName)
        popUp.add(Action("Edit \"" + locName + "\"") { self.actionLocation(sender.data) })
        if Location.numLocations > 1 {
            popUp.add(Action("Delete \"" + locName + "\"") { self.deleteLocation(sender.data) })
            popUp.add(Action("Move Up") { self.moveUp(sender.data) })
            popUp.add(Action("Move Down") { self.moveDown(sender.data) })
        }
        popUp.finish()
    }

    func actionLocation(_ position: Int) {
        Route.locationEdit(self, String(position + 1))
    }

    func moveUp(_ position: Int) {
        if position > 0 {
            let locA = ObjectLocation(position - 1)
            let locB = ObjectLocation(position)
            locA.saveToNewSlot(position)
            locB.saveToNewSlot(position - 1)
        } else {
            let locA = ObjectLocation(Location.numLocations - 1)
            let locB = ObjectLocation(0)
            locA.saveToNewSlot(0)
            locB.saveToNewSlot(Location.numLocations - 1)
        }
        display()
    }

    func moveDown(_ position: Int) {
        if position < (Location.numLocations - 1) {
            let locA = ObjectLocation(position)
            let locB = ObjectLocation(position + 1)
            locA.saveToNewSlot(position + 1)
            locB.saveToNewSlot(position)
        } else {
            let locA = ObjectLocation(position)
            let locB = ObjectLocation(0)
            locA.saveToNewSlot(0)
            locB.saveToNewSlot(position)
        }
        display()
    }

    func deleteLocation(_ position: Int) {
        if Location.numLocations > 1 {
            Location.delete(To.string(position + 1))
            display()
        }
    }

    func initializeObservations() {
        (0..<Location.numLocations).forEach {
            Location.updateObservation($0, "")
        }
    }

    func display() {
        locationCards.removeAll()
        boxMain.removeViews()
        Location.locations.enumerated().forEach { index, location in
            locationCards.append(CardLocationItem(boxMain, location,
                    GestureData(index, self, #selector(actionLocationPopup))
                )
            )
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initializeObservations()
        display()
        getContent()
    }
}
