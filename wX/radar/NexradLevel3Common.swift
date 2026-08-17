// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class NexradLevel3Common {

    static func drawLine(
        _ startEc: ExternalGlobalCoordinates,
        _ projectionNumbers: ProjectionNumbers,
        _ startBearing: Double,
        _ distance: Double
    ) -> [Double] {
        let start = ExternalGlobalCoordinates(startEc)
        let startCoords = Projection.computeMercatorNumbers(startEc, projectionNumbers)
        let ec = ExternalGeodeticCalculator.calculateEndingGlobalCoordinates(start, startBearing, distance)
        return startCoords + Projection.computeMercatorNumbers(ec, projectionNumbers)
    }

    static func drawLine(
        _ startPoint: [Double],
        _ projectionNumbers: ProjectionNumbers,
        _ start: ExternalGlobalCoordinates,
        _ startBearing: Double,
        _ distance: Double
    ) -> [Double] {
        let ec = ExternalGeodeticCalculator.calculateEndingGlobalCoordinates(start, startBearing, distance)
        return startPoint + Projection.computeMercatorNumbers(ec, projectionNumbers)
    }
}
