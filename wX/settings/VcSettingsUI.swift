// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcSettingsUI: UIwXViewController {

    private var numberPickers = [NumberPicker]()
    private var switches = [Switch]()
    private var comboBoxes = [ComboBox]()
    private let sliderPreferences = [
        "ANIM_INTERVAL",
        "HOMESCREEN_TEXT_LENGTH_PREF",
        "NWS_ICON_SIZE_PREF",
        "REFRESH_LOC_MIN",
        "TEXTVIEW_FONT_SIZE",
        "UI_TILES_PER_ROW"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton]).items
        objScrollStackView = ScrollStackView(self)
        UtilityUI.determineDeviceType()
        display()
        UIPreferences.settingsUIVisitedNeedRefresh = true
    }

    override func doneClicked() {
        MyApplication.initPreferences()
        AppColors.update()
        super.doneClicked()
    }

    private func display() {
        switches.removeAll()
        numberPickers.removeAll()
        setupSwitch()
        setupSliders()
        setupComboBox()
    }

    func setupSwitch() {
        switches.append(Switch(boxMain, "BACK_ARROW_ANIM", "Animation with back arrow", "true"))
        switches.append(Switch(boxMain, "UNITS_F", "Fahrenheit in current conditions/7day", "true"))
        switches.append(Switch(boxMain, "HOURLY_SHOW_AM_PM", "Hourly/Nexrad: show with AM/PM", "false"))
        switches.append(Switch(boxMain, "SCREEN_ON_FOR_TTS", "Keep screen on for TTS", "false"))
        switches.append(Switch(boxMain, "DUALPANE_RADAR_ICON", "Lightning button opens dual pane radar", "false"))
        switches.append(Switch(boxMain, "RADAR_TOOLBAR_TRANSPARENT", "Radar uses transparent toolbars", "true"))
        switches.append(Switch(boxMain, "UI_MAIN_SCREEN_CONDENSE", "Show less information on main screen", "false"))
        switches.append(Switch(boxMain, "SETTINGS_TOGGLE_ON_RIGHT_SIDE", "Settings - toggle is on right side", "true"))
        switches.append(Switch(boxMain, "GOES_USE_FULL_RESOLUTION_IMAGES", "Use full resolution GOES images", "false"))
        switches.append(Switch(boxMain, "UNITS_M", "Use millibars", "true"))
        switches.append(Switch(boxMain, "USE_NWS_API_SEVEN_DAY", "Use new NWS API for 7 day", "true"))
        switches.append(Switch(boxMain, "USE_NWS_API_HOURLY", "Use new NWS API for hourly", "true"))
        switches.append(Switch(boxMain, "WFO_REMEMBER_LOCATION", "WFO text viewer remembers location", "false"))
    }

    func setupComboBox() {
        comboBoxes.append(ComboBox(boxMain, "UI_THEME", "Color theme", "blue", ["blue", "black", "green", "orange"]))
    }

    func setupSliders() {
        for pref in sliderPreferences {
            numberPickers.append(NumberPicker(self, pref))
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            self.boxMain.removeChildren()
            self.display()
        }
    }
}
