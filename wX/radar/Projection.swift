// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class Projection {

    static func computeMercatorNumbers(_ lat: Double, _ lon: Double, _ projectionNumbers: ProjectionNumbers) -> [Double] {
        let test1 = 180.0 / Double.pi * log(tan(Double.pi / 4.0 + lat * (Double.pi / 180.0) / 2.0))
        let test2 = 180.0 / Double.pi * log(tan(Double.pi / 4.0 + projectionNumbers.xDbl * (Double.pi / 180.0) / 2.0))
        let y = -1.0 * ((test1 - test2) * projectionNumbers.oneDegreeScaleFactor) + projectionNumbers.yCenterDouble
        let x = -1.0 * ((lon - projectionNumbers.yDbl) * projectionNumbers.oneDegreeScaleFactor) + projectionNumbers.xCenterDouble
        return [x, y]
    }

    static func computeMercatorNumbers(_ latLon: LatLon, _ projectionNumbers: ProjectionNumbers) -> [Double] {
        computeMercatorNumbers(latLon.lat, latLon.lon, projectionNumbers)
    }

    static func computeMercatorNumbers(_ ec: ExternalGlobalCoordinates, _ projectionNumbers: ProjectionNumbers) -> [Double] {
        computeMercatorNumbers(ec.getLatitude(), ec.getLongitude() * -1.0, projectionNumbers)
    }
}
