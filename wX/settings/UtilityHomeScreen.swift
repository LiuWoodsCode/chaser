// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class UtilityHomeScreen {

    enum Pane: String {
        case left
        case right
    }

    static let favoritesPreference = "HOMESCREEN_FAV"
    static let leftPanePreference = "HOMESCREEN_FAV_LEFT"
    static let rightPanePreference = "HOMESCREEN_FAV_RIGHT"
    static let panesConfiguredPreference = "HOMESCREEN_PANES_CONFIGURED"

    static let localChoicesText = [
        "METAL-RADAR": "Local NEXRAD Radar",
        "TXT-AFDLOC": "Area Forecast Discussion",
        "TXT-HWOLOC": "Hazardous Weather Outlook",
        "TXT-HOURLY": "Hourly Forecast",
        "TXT-CC2": "Current Conditions with Image",
        "TXT-HAZ": "Hazards",
        "TXT-7DAY2": "7 Day Forecast with Images"
    ]

    static let localChoicesImages = [
        "CARAIN: Local CA Radar",
        "WEATHERSTORY: Local NWS Weather Story",
        "WFOWARNINGS: Local NWS Office Warnings",
        "RTMA_DEW: Real-Time Mesoscale Analysis Dew Point",
        "RTMA_TEMP: Real-Time Mesoscale Analysis Temperature",
        "RTMA_WIND: Real-Time Mesoscale Analysis Wind"
    ]

    static var usesTwoPaneRedesign: Bool {
        guard UIPreferences.homeScreenRedesign else { return false }
        #if targetEnvironment(macCatalyst)
        return true
        #else
        return UIDevice.current.userInterfaceIdiom == .pad
        #endif
    }

    static func getFavorites() -> [String] {
        splitFavorites(Utility.readPref(favoritesPreference, GlobalVariables.homescreenFavDefault))
    }

    static func getPaneFavorites() -> (left: [String], right: [String]) {
        if Utility.readPref(panesConfiguredPreference, "false").hasPrefix("t") {
            return (
                splitFavorites(Utility.readPref(leftPanePreference, "")),
                splitFavorites(Utility.readPref(rightPanePreference, ""))
            )
        }
        return splitIntoPaneFavorites(getFavorites())
    }

    static func splitFavorites(_ favorites: String) -> [String] {
        if favorites.isEmpty {
            return []
        }
        let normalizedFavorites = favorites.hasSuffix(":") ? favorites : favorites + ":"
        return WString.split(normalizedFavorites, ":")
    }

    static func writeFavorites(_ favorites: [String]) {
        Utility.writePref(favoritesPreference, WString.join(":", favorites))
        GlobalVariables.editor.removeObject(leftPanePreference)
        GlobalVariables.editor.removeObject(rightPanePreference)
        Utility.writePref(panesConfiguredPreference, "false")
    }

    static func writePaneFavorites(left: [String], right: [String]) {
        Utility.writePref(leftPanePreference, WString.join(":", left))
        Utility.writePref(rightPanePreference, WString.join(":", right))
        Utility.writePref(panesConfiguredPreference, "true")
        Utility.writePref(favoritesPreference, WString.join(":", left + right))
    }

    static func splitIntoPaneFavorites(_ favorites: [String]) -> (left: [String], right: [String]) {
        var left = [String]()
        var right = [String]()
        let hasRightPanePreferredWidgets = favorites.contains { prefersRightPane($0) }
        favorites.enumerated().forEach { index, favorite in
            if prefersRightPane(favorite) {
                right.append(favorite)
            } else if hasRightPanePreferredWidgets {
                left.append(favorite)
            } else if index % 2 == 0 {
                left.append(favorite)
            } else {
                right.append(favorite)
            }
        }
        return (left, right)
    }

    static func prefersRightPane(_ favorite: String) -> Bool {
        favorite == "METAL-RADAR" || favorite.hasPrefix("IMG-")
    }

    static func title(for prefVar: String) -> String {
        if let title = localChoicesText[prefVar] {
            return title.trim()
        }
        let prefVarMod = prefVar.replace("TXT-", "").replace("IMG-", "")
        for label in localChoicesImages + GlobalArrays.nwsImageProducts where label.hasPrefix(prefVarMod + ":") {
            return label.split(":")[1].trim()
        }
        for label in UtilityWpcText.labelsWithCodes where label.hasPrefix(prefVarMod + ":") {
            return label.split(":")[1].trim()
        }
        return prefVar
    }

    static func jumpToActivity(_ uiv: UIViewController, _ homeScreenToken: String) {
        switch homeScreenToken {
        case "USWARN":
            Route.alerts(uiv)
        case "VIS_1KM":
            Route.wpcImage(uiv)
        case "FMAP":
            Route.wpcImage(uiv)
        case "VIS_CONUS":
            Route.goesVisConus(uiv)
        case "CONUSWV":
            Route.goesWaterVapor(uiv)
        case "SWOD1":
            Route.swo(uiv, "1")
        case "SWOD2":
            Route.swo(uiv, "2")
        case "SWOD3":
            Route.swo(uiv, "3")
        case "STRPT":
            Route.spcStormReports(uiv, "today")
        case "SND":
            Route.soundings(uiv)
        case "SPCMESO_500":
            Route.spcMesoFromHomeScreen(uiv, "500mb")
        case "SPCMESO_MSLP":
            Route.spcMesoFromHomeScreen(uiv, "pmsl")
        case "SPCMESO_TTD":
            Route.spcMesoFromHomeScreen(uiv, "ttd")
        case "SPCMESO_LLLR":
            Route.spcMesoFromHomeScreen(uiv, "lllr")
        case "SPCMESO_LAPS":
            Route.spcMesoFromHomeScreen(uiv, "laps")
        case "SPCMESO_RGNLRAD":
            Route.spcMesoFromHomeScreen(uiv, "rgnlrad")
        case "RAD_2KM":
            Route.radarMosaic(uiv)
        case "GOES16":
            Route.vis(uiv)
        case "RTMA_DEW":
            Route.rtma(uiv, "2m_dwpt")
        case "RTMA_TEMP":
            Route.rtma(uiv, "2m_temp")
        case "RTMA_WIND":
            Route.rtma(uiv, "10m_wnd")
        default:
            Route.wpcImageFromHomeScreen(uiv, homeScreenToken)
        }
    }
}
