// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcSettingsColorListing: UIwXViewController {

    private var colors = [WXColor]()
    private var textList = [Text]()

    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton = ToolbarIcon(self, .done, #selector(doneClicked), forceLight: true)
        toolbar.items = ToolbarItems(doneButton, GlobalVariables.flexBarButton).items
        objScrollStackView = ScrollStackView(self)
        boxMain.constrain(self)
        boxMain.spacing = 0
        setupColorObjects()
        colors.sort { $0.uiLabel < $1.uiLabel }
        display()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textList.forEach { tv in
            if tv.textColor.colorsCurrent.red == 0
                && tv.textColor.colorsCurrent.green == 0
                && tv.textColor.colorsCurrent.blue == 0 {
                tv.color = UIColor.white
            } else {
                tv.color = tv.textColor.uiColorCurrent
            }
        }
    }

    override func doneClicked() {
        RadarPreferences.initialize()
        GeographyType.regen()
        PolygonType.regen()
        super.doneClicked()
    }

    func setupColorObjects() {
        colors.append(WXColor("Highways", "RADAR_COLOR_HW", 135, 135, 135))
        colors.append(WXColor("Secondary Roads", "RADAR_COLOR_HW_EXT", 91, 91, 91))
        colors.append(WXColor("State Lines", "RADAR_COLOR_STATE", 142, 142, 142))
        colors.append(WXColor("Thunderstorm Warning", "RADAR_COLOR_TSTORM", 255, 255, 0))
        colors.append(WXColor("Thunderstorm Watch", "RADAR_COLOR_TSTORM_WATCH", 255, 187, 0))
        colors.append(WXColor("Tornado Warning", "RADAR_COLOR_TOR", 243, 85, 243))
        colors.append(WXColor("Tornado Watch", "RADAR_COLOR_TOR_WATCH", 255, 0, 0))
        colors.append(WXColor("Flash Flood Warning", "RADAR_COLOR_FFW", 0, 255, 0))
        PolygonWarning.polygonList.forEach { poly in
            if poly != PolygonTypeGeneric.TOR && poly != PolygonTypeGeneric.TST && poly != PolygonTypeGeneric.FFW {
                let polygonType = PolygonWarning.byType[poly]!
                colors.append(WXColor(polygonType.name, polygonType.prefTokenColor, polygonType.defaultColors[poly]!))
            }
        }
        colors.append(WXColor("MCD", "RADAR_COLOR_MCD", 153, 51, 255))
        colors.append(WXColor("MPD", "RADAR_COLOR_MPD", 0, 255, 0))
        colors.append(WXColor("Location Dot", "RADAR_COLOR_LOCDOT", 255, 255, 255))
        colors.append(WXColor("Spotters", "RADAR_COLOR_SPOTTER", 255, 0, 245))
        colors.append(WXColor("Cities", "RADAR_COLOR_CITY", 255, 255, 255))
        colors.append(WXColor("Lakes and Rivers", "RADAR_COLOR_LAKES", 0, 0, 255))
        colors.append(WXColor("Counties", "RADAR_COLOR_COUNTY", 75, 75, 75))
        colors.append(WXColor("Storm Tracks", "RADAR_COLOR_STI", 255, 255, 255))
        colors.append(WXColor("Hail Indicators", "RADAR_COLOR_HI", 0, 255, 0))
        colors.append(WXColor("Observations", "RADAR_COLOR_OBS", 255, 255, 255))
        colors.append(WXColor("Wind Barbs", "RADAR_COLOR_OBS_WINDBARBS", 255, 255, 255))
        colors.append(WXColor("County Labels", "RADAR_COLOR_COUNTY_LABELS", 234, 214, 123))
        colors.append(WXColor("NWS Forecast Icon Text Color", "NWS_ICON_TEXT_COLOR", 38, 97, 139))
        colors.append(WXColor("NWS Forecast Icon Bottom Color", "NWS_ICON_BOTTOM_COLOR", 255, 255, 255))
        colors.append(WXColor("Nexrad Radar Background Color", "NEXRAD_RADAR_BACKGROUND_COLOR", 0, 0, 0))
    }

    @objc func goToColor(sender: GestureData) {
        Route.colorPicker(self, colors[sender.data])
    }

    private func display() {
        colors.enumerated().forEach { index, color in
            let text = Text(boxMain, color.uiLabel, color)
            text.isUserInteractionEnabled = true
            if color.colorsCurrent.red == 0 && color.colorsCurrent.green == 0 && color.colorsCurrent.blue == 0 {
                text.color = UIColor.white
            } else {
                text.color = color.uiColorCurrent
            }
            text.addSpacing()
            text.background = UIColor.black
            text.font = FontSize.extraLarge.size
            text.connect(GestureData(index, self, #selector(goToColor)))
            text.isSelectable = false
            textList.append(text)
        }
    }
}
