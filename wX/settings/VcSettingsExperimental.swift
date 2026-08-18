// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcSettingsExperimental: UIwXViewController {

    private var switches = [Switch]()

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbar.items = ToolbarItems(doneButton, GlobalVariables.flexBarButton).items
        objScrollStackView = ScrollStackView(self)
        boxMain.constrain(self)
        display()
        UIPreferences.settingsUIVisitedNeedRefresh = true
    }

    override func doneClicked() {
        MyApplication.initPreferences()
        super.doneClicked()
    }

    private func display() {
        switches.removeAll()
        switches.append(Switch(boxMain, "NEXRAD_USE_MAPKIT_BASE_LAYER", "NEXRAD radar uses MapKit base layer", "false"))
        switches.append(Switch(boxMain, "HOME_SCREEN_REDESIGN", "Home screen redesign", "false"))
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            self.boxMain.removeChildren()
            self.display()
        }
    }
}
