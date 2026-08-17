// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class DownloadTimer {

    private var initialized = false
    private var lastRefresh: CLong = 0
    private var refreshDataInMinutes = 6
    private let identifier: String

    init(_ identifier: String) {
        self.identifier = identifier
    }

    func isRefreshNeeded() -> Bool {
        refreshDataInMinutes = 6
        if identifier.contains("WARNINGS") {
            refreshDataInMinutes = 3
        } else if identifier.contains("MAIN_LOCATION_TAB") {
            refreshDataInMinutes = UIPreferences.refreshLocMin
        }

        if identifier == "SEVERE_DASHBOARD_ACTIVITY" || identifier == "NHC_ACTIVITY" {
            refreshDataInMinutes = 3
        }
        var refreshNeeded = false
        let currentTime = ObjectDateTime.currentTimeMillis()
        let currentTimeSeconds = currentTime / 1000
        let refreshIntervalSeconds = refreshDataInMinutes * 60
        if (currentTimeSeconds > (lastRefresh + refreshIntervalSeconds)) || !initialized {
            refreshNeeded = true
            initialized = true
            lastRefresh = currentTime / 1000
        }
        return refreshNeeded
    }

    func resetTimer() {
        lastRefresh = 0
    }
}
