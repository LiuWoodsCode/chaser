// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class PolygonWarning {

    static var byType: [PolygonTypeGeneric: PolygonWarning] = [:]

    let storage: DataStorage
    let timer: DownloadTimer
    let isEnabled: Bool
    let type: PolygonTypeGeneric
    private let baseUrl = "https://api.weather.gov/alerts/active?event="

    init(_ type: PolygonTypeGeneric) {
        self.type = type
        isEnabled = Utility.readPref("RADAR_SHOW_\(type)", "false").hasPrefix("t")
        storage = DataStorage("SEVEREDASHBOARD\(type)")
        timer = DownloadTimer("WARNINGS_\(type)")
        storage.update()
    }

    func download() {
        if timer.isRefreshNeeded() {
            let html = getUrl().getNwsHtml()
            if html != "" {
                storage.value = html
            } else {
                timer.resetTimer()
            }
        }
    }

    func getData() -> String {
        storage.value
    }

    var color: Int { Utility.readPrefInt(prefTokenColor, defaultColors[type]!) }

    var name: String { longName[type]!.replaceAll("%20", " ") }

    var prefTokenColor: String { "RADAR_COLOR_" + typeName }

    var typeName: String { "\(type)".replaceAll("PolygonType.", "") }

    func getUrlToken() -> String {
        longName[type]!
    }

    func getUrl() -> String {
        baseUrl + getUrlToken()
    }

    let defaultColors: [PolygonTypeGeneric: Int] = [
        .SMW: Color.rgb(255, 165, 0),
        .SQW: Color.rgb(199, 21, 133),
        .DSW: Color.rgb(255, 228, 196),
        .SPS: Color.rgb(255, 228, 181),
        .TOR: Color.rgb(243, 85, 243),
        .TST: Color.rgb(255, 255, 0),
        .FFW: Color.rgb(0, 255, 0)
    ]

    let longName: [PolygonTypeGeneric: String] = [
        .SMW: "Special%20Marine%20Warning",
        .SQW: "Snow%20Squall%20Warning",
        .DSW: "Dust%20Storm%20Warning",
        .SPS: "Special%20Weather%20Statement",
        .TOR: "Tornado%20Warning",
        .TST: "Severe%20Thunderstorm%20Warning",
        .FFW: "Flash%20Flood%20Warning"
    ]

    static let polygonList = [
        PolygonTypeGeneric.TOR,
        PolygonTypeGeneric.TST,
        PolygonTypeGeneric.FFW,
        PolygonTypeGeneric.SMW,
        PolygonTypeGeneric.SQW,
        PolygonTypeGeneric.DSW,
        PolygonTypeGeneric.SPS
    ]

    static func areAnyEnabled() -> Bool {
        var anyEnabled = false
        polygonList.forEach {
            if PolygonWarning.byType[$0]!.isEnabled {
                anyEnabled = true
            }
        }
        return anyEnabled
    }

    // FIXME use in NexradLongPressMenu like wx
//    static func isCountNonZero() -> Bool {
//        var count = 0
//        polygonList.forEach {
//            if (byType[$0]!.isEnabled) {
//                count += Warnings.getCount(it)
//            }
//        }
//        return count > 0
//    }

    static func resetTimers() {
        polygonList.forEach {
            PolygonWarning.byType[$0]!.timer.resetTimer()
        }
    }

    static func load() {
        polygonList.forEach {
            byType[$0] = PolygonWarning($0)
        }
    }
}
