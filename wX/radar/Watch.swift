// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class Watch {

    static func add(_ projectionNumbers: ProjectionNumbers, _ type: PolygonEnum) -> [Double] {
        var warningList = [Double]()
        let prefToken = PolygonWatch.byType[type]?.latLonList.getValue() ?? ""
        if prefToken != "" {
            let polygons = prefToken.split(":")
            polygons.forEach { polygon in
                let latLons = LatLon.parseStringToLatLons(polygon, 1.0, false)
                warningList += LatLon.latLonListToListOfDoubles(latLons, projectionNumbers)
            }
        }
        return warningList
    }

    static func show(_ latLon: LatLon, _ type: PolygonEnum) -> String {
        let numberList: [String]
        let watchLatLon: String
        if type == PolygonEnum.SPCWAT {
            watchLatLon = PolygonWatch.watchLatlonCombined.getValue()
            numberList = PolygonWatch.byType[PolygonEnum.SPCWAT]!.numberList.getValue().split(":")
        } else {
            numberList = PolygonWatch.byType[type]!.numberList.getValue().split(":")
            watchLatLon = PolygonWatch.byType[type]!.latLonList.getValue()
        }
        let latLonsFromString = watchLatLon.split(":")
        var notFound = true
        var text = ""
        latLonsFromString.indices.forEach { z in
            let latLons = LatLon.parseStringToLatLons(latLonsFromString[z], -1.0, false)
            if latLons.count > 3 {
                let contains = ExternalPolygon.polygonContainsPoint(latLon, latLons)
                if contains && notFound {
                    text = numberList[z]
                    notFound = false
                }
            }
        }
        return text
    }
}
