// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class Warnings {

    static func addGeneric(_ projectionNumbers: ProjectionNumbers, _ type: PolygonWarning) -> [Double] {
        let html = type.getData()
        let warnings = ObjectWarning.parseJson(html)
        var warningList = [Double]()
        for w in warnings {
            if type.type == PolygonTypeGeneric.SPS || type.type == PolygonTypeGeneric.SMW || w.isCurrent {
                let latLons = w.getPolygonAsLatLons(-1)
                warningList += LatLon.latLonListToListOfDoubles(latLons, projectionNumbers)
            }
        }
        return warningList
    }

    static func add(_ projectionNumbers: ProjectionNumbers, _ type: PolygonEnum) -> [Double] {
        let html = PolygonWarning.byType[changeType(type)]!.getData()
        let warnings = ObjectWarning.parseJson(html)
        var warningList = [Double]()
        for w in warnings where w.isCurrent {
            let latLons = w.getPolygonAsLatLons(-1)
            warningList += LatLon.latLonListToListOfDoubles(latLons, projectionNumbers)
        }
        return warningList
    }

    private static func getCount( _ type: PolygonEnum) -> Int {
        let html = PolygonWarning.byType[changeType(type)]!.getData()
        if html == "" {
            return -1 // "-"
        }
        let warningList = ObjectWarning.parseJson(html)
        var i = 0
        for s in warningList where s.isCurrent {
            i += 1
        }
        return i
    }

    static func getCountString() -> String {
        return "(\(getCount(PolygonEnum.TST)),\(getCount(PolygonEnum.TOR)),\(getCount(PolygonEnum.FFW)))"
    }

    static func changeType(_ type: PolygonEnum) -> PolygonTypeGeneric {
        switch type {
        case PolygonEnum.TOR:
            return PolygonTypeGeneric.TOR
        case PolygonEnum.TST:
            return PolygonTypeGeneric.TST
        case PolygonEnum.FFW:
            return PolygonTypeGeneric.FFW
        default:
            return PolygonTypeGeneric.FFW
        }
    }

    static func show(_ latLon: LatLon) -> String {
        var warningChunk = ""
        for type1 in [PolygonTypeGeneric.TOR, PolygonTypeGeneric.FFW, PolygonTypeGeneric.TST] {
            warningChunk += PolygonWarning.byType[type1]!.getData()
        }
        for data in PolygonWarning.polygonList {
            let it = PolygonWarning.byType[data]!
            if it.isEnabled {
                warningChunk += it.getData()
            }
        }
        let warnings = ObjectWarning.parseJson(warningChunk)
        var urlToOpen = ""
        var notFound = true
        for w in warnings {
            let latLons = w.getPolygonAsLatLons(1)
            if latLons.count > 0 {
                let contains = ExternalPolygon.polygonContainsPoint(latLon, latLons)
                if contains && notFound {
                    urlToOpen = w.getUrl()
                    notFound = false
                }
            }
        }
        return urlToOpen
    }
}
