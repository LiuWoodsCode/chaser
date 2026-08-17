// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class SevereWarning {

    private let type: PolygonEnum
    var warningList = [ObjectWarning]()
    var downloadComplete = false

    init(_ type: PolygonEnum) {
        self.type = type
        generateString()
    }

    func download() {
        switch type {
        case .TOR:
            PolygonWarning.byType[PolygonTypeGeneric.TOR]!.download()
        case .TST:
            PolygonWarning.byType[PolygonTypeGeneric.TST]!.download()
        case .FFW:
            PolygonWarning.byType[PolygonTypeGeneric.FFW]!.download()
        default:
            break
        }
        generateString()
        downloadComplete = true
    }

    func generateString() {
        var html: String
        switch type {
        case .TOR:
            html = PolygonWarning.byType[PolygonTypeGeneric.TOR]!.getData()
        case .TST:
            html = PolygonWarning.byType[PolygonTypeGeneric.TST]!.getData()
        case .FFW:
            html = PolygonWarning.byType[PolygonTypeGeneric.FFW]!.getData()
        default:
            html = ""
        }
        warningList = ObjectWarning.parseJson(html)
    }

    func getName() -> String {
        switch type {
        case .TOR:
            return "Tornado Warning"
        case .TST:
            return "Severe Thunderstorm Warning"
        case .FFW:
            return "Flash Flood Warning"
        default:
            return ""
        }
    }

    func getCount() -> String {
        if !downloadComplete {
            return "?"
        }
        var i = 0
        for s in warningList where s.isCurrent {
            i += 1
        }
        return String(i)
    }

    func getCount() -> Int {
        var i = 0
        for s in warningList where s.isCurrent {
            i += 1
        }
        return i
    }
}
