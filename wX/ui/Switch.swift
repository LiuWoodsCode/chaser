// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class Switch {

    private let button = UIButton(type: UIButton.ButtonType.system)
    private let switchUi = UISwitch()
    private let prefVar: String
    private var locationManger: LocationManager?

    init(_ vbox: VBox, _ prefVar: String, _ title: String, _ defaultValue: String) {
        self.prefVar = prefVar
        button.backgroundColor = ColorCompatibility.systemBackground
        button.setTitleColor(ColorCompatibility.label, for: .normal)
        switchUi.backgroundColor = ColorCompatibility.systemBackground
        button.contentHorizontalAlignment = .left
        button.setTitle(title, for: .normal)
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        button.titleLabel?.font = FontSize.medium.size
        switchUi.thumbTintColor = AppColors.primaryDarkBlueUIColor
        switchUi.onTintColor = ColorCompatibility.label
        switchUi.setOn(Utility.readPref(prefVar, defaultValue).hasPrefix("t"), animated: true)
        var card = Card([button, switchUi])
        if !UIPreferences.settingsToggleOnRightSide {
            card = Card([switchUi, button])
            card.addCustomSpacing(6.0, switchUi)
        }
        let (width, _) = UtilityUI.getScreenBoundsCGFloat()
        card.constrain(CGFloat(width - (UIPreferences.stackviewCardSpacing * 2.0)))
        vbox.addWidget(card)
        addTarget()
    }

    private func addTarget() {
        switchUi.addTarget(self,
            action: #selector(switchChanged),
            for: UIControl.Event.valueChanged
        )
    }

    @objc func switchChanged(sender: UISwitch) {
        let isOnQ = sender.isOn
        var truthString = "false"
        if isOnQ {
            truthString = "true"
        }
        Utility.writePref(prefVar, truthString)
        if prefVar == "LOCDOT_FOLLOWS_GPS" && truthString == "true" {
            locationManger = LocationManager()
            locationManger?.checkLocation()
        }
    }
}
