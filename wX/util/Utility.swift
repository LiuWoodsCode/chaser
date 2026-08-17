// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class Utility {

    static func safeGet(_ list: [String], _ index: Int) -> String {
        if list.count <= index {
            return ""
        } else {
            return list[index]
        }
    }

    static func readPrefFloat(_ key: String, _ value: Float) -> Float {
        GlobalVariables.preferences.getFloat(key, value)
    }

    static func readPrefInt(_ key: String, _ value: Int) -> Int {
        GlobalVariables.preferences.getInt(key, value)
    }

    static func readPref(_ key: String, _ value: String) -> String {
        GlobalVariables.preferences.getString(key, value)
    }

    static func writePrefFloat(_ key: String, _ value: Float) {
        GlobalVariables.editor.putFloat(key, value)
    }

    static func writePrefInt(_ key: String, _ value: Int) {
        GlobalVariables.editor.putInt(key, value)
    }

    static func writePref(_ key: String, _ value: String) {
        GlobalVariables.editor.putString(key, value)
    }

    static func showDiagnostics() -> String {
        GlobalVariables.newline + "Is Tablet?: " + String(UtilityUI.isTablet()) + GlobalVariables.newline
        + "native screen scale: " + String(UtilityUI.getNativeScreenScale()) + GlobalVariables.newline + "screen scale: " + String(UtilityUI.getScreenScale())
    }
}
