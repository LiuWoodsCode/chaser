// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class UIPreferences {

    static let tabBarHeight: CGFloat = 48.0
    static let toolbarHeight: CGFloat = 44.0
    static let statusBarHeight: CGFloat = 20.0
    static let toolbarIconSpacing: CGFloat = 17.0
    static let stackviewCardSpacing: CGFloat = 1.0
    static var backButtonAnimation = true
    static var dualpaneRadarIcon = false
    static var unitsM = false
    static var unitsF = true
    static var hourlyShowAMPM = false
    static var nwsIconTextColor = Color.rgb(38, 97, 139)
    static var nwsIconBottomColor = Color.rgb(255, 255, 255)
    static var textviewFontSize: CGFloat = 16.0
    static var refreshLocMin = 10
    static var tilesPerRow = 3
    static var homescreenTextLength = 500
    static var radarToolbarTransparent = true
    static var mainScreenRadarFab = true
    static var mainScreenCondense = false
    static var nwsIconSize: Float = 80.0
    static var goesUseFullResolutionImages = false
    static var useNwsApi = true
    static var useNwsApiForHourly = true
    static var debugMode = false
    static var animInterval = 250
    static var playlistStr = ""
    static var screenOnForTts = true
    static var settingsToggleOnRightSide = true
    static var settingsUIVisitedNeedRefresh = false

    static func initialize() {
        #if targetEnvironment(macCatalyst)
        tilesPerRow = 5
        textviewFontSize = 20.0
        #endif
        useNwsApi = Utility.readPref("USE_NWS_API_SEVEN_DAY", "true").hasPrefix("t")
        useNwsApiForHourly = Utility.readPref("USE_NWS_API_HOURLY", "true").hasPrefix("t")
        goesUseFullResolutionImages = Utility.readPref("GOES_USE_FULL_RESOLUTION_IMAGES", "false").hasPrefix("t")
        backButtonAnimation = Utility.readPref("BACK_ARROW_ANIM", "true").hasPrefix("t")
        dualpaneRadarIcon = Utility.readPref("DUALPANE_RADAR_ICON", "false").hasPrefix("t")
        tilesPerRow = Utility.readPrefInt("UI_TILES_PER_ROW", tilesPerRow)
        homescreenTextLength = Utility.readPrefInt("HOMESCREEN_TEXT_LENGTH_PREF", 500)
        unitsM = Utility.readPref("UNITS_M", "true").hasPrefix("t")
        unitsF = Utility.readPref("UNITS_F", "true").hasPrefix("t")
        hourlyShowAMPM = Utility.readPref("HOURLY_SHOW_AM_PM", "false").hasPrefix("t")
        nwsIconTextColor = Utility.readPrefInt("NWS_ICON_TEXT_COLOR", Color.rgb(38, 97, 139))
        nwsIconBottomColor = Utility.readPrefInt("NWS_ICON_BOTTOM_COLOR", Color.rgb(255, 255, 255))
        refreshLocMin = Utility.readPrefInt("REFRESH_LOC_MIN", 10)
        textviewFontSize = CGFloat(Utility.readPrefInt("TEXTVIEW_FONT_SIZE", Int(textviewFontSize)))
        radarToolbarTransparent = Utility.readPref("RADAR_TOOLBAR_TRANSPARENT", "true").hasPrefix("t")
        mainScreenRadarFab = Utility.readPref("UI_MAIN_SCREEN_RADAR_FAB", "true").hasPrefix("t")
        mainScreenCondense = Utility.readPref("UI_MAIN_SCREEN_CONDENSE", "false").hasPrefix("t")
        nwsIconSize = Utility.readPrefFloat("NWS_ICON_SIZE_PREF", 68.0)
        animInterval = Utility.readPrefInt("ANIM_INTERVAL", 6)
        playlistStr = Utility.readPref("PLAYLIST", "")
        debugMode = Utility.readPref("DEBUG_MODE", "false").hasPrefix("t")
        screenOnForTts = Utility.readPref("SCREEN_ON_FOR_TTS", "false").hasPrefix("t")
        settingsToggleOnRightSide = Utility.readPref("SETTINGS_TOGGLE_ON_RIGHT_SIDE", "true").hasPrefix("t")
        GlobalVariables.fixedSpace.width = UIPreferences.toolbarIconSpacing
    }
}
