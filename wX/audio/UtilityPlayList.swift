// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class UtilityPlayList {

    static let formatTimeString = "MM-dd HH:mm"

    static func add(_ prod: String, _ text: String, _ uiv: UIViewController, _ menuButton: ToolbarIcon, showStatus: Bool = true) -> Bool {
        let prodLocal = prod.uppercased()
        var productAdded = false
        if !UIPreferences.playlistStr.contains(prodLocal) {
            UIPreferences.playlistStr += ":" + prodLocal
            Utility.writePref("PLAYLIST", UIPreferences.playlistStr)
            if showStatus {
                _ = PopupMessage(prodLocal + " saved to playlist: " + String(text.count), uiv, menuButton)
            }
            productAdded = true
        } else {
            _ = PopupMessage(prodLocal + " already in playlist: " + String(text.count), uiv, menuButton)
        }
        let formattedDate = ObjectDateTime.getDateAsString(formatTimeString)
        Utility.writePref("PLAYLIST_" + prodLocal, text)
        Utility.writePref("PLAYLIST_" + prodLocal + "_TIME", formattedDate)
        return productAdded
    }

    static func checkAndSave(_ prod: String, _ text: String) {
        let prodLocal = prod.uppercased()
        let formattedDate = ObjectDateTime.getDateAsString(formatTimeString)
        if UIPreferences.playlistStr.contains(prodLocal) {
            Utility.writePref("PLAYLIST_" + prodLocal, text)
            Utility.writePref("PLAYLIST_" + prodLocal + "_TIME", formattedDate)
        }
    }

    static func download(_ product: String) {
        let formattedDate = ObjectDateTime.getDateAsString(formatTimeString)
        let text = DownloadText.byProduct(product)
        if text != "" {
            Utility.writePref("PLAYLIST_" + product, text)
            Utility.writePref("PLAYLIST_" + product + "_TIME", formattedDate)
        }
    }
}
