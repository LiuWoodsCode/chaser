// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class ProjectionNumbers {

    private let scale = 190.0
    var oneDegreeScaleFactor = 0.0
    private var xCenter = 0.0
    private var yCenter = 0.0
    private var radarSite = ""
    private var latLon = LatLon()

    init() {
        oneDegreeScaleFactor = UtilityMath.pixPerDegreeLon(xDbl, scale)
    }

    init(_ radarSite: String) {
        self.radarSite = radarSite
        latLon = RadarSites.getLatLon(radarSite).reverse()
        oneDegreeScaleFactor = UtilityMath.pixPerDegreeLon(xDbl, scale)
    }

    func getRadarSite() -> String {
        radarSite
    }

    var xDbl: Double { latLon.lat }

    var xFloat: Float { Float(xDbl) }

    var yDbl: Double { latLon.lon }

    var yFloat: Float { Float(yDbl) }

    var xCenterFloat: Float { Float(xCenter) }

    var yCenterFloat: Float { Float(yCenter) }

    var xCenterDouble: Double { Double(xCenter) }

    var yCenterDouble: Double { Double(yCenter) }

    var oneDegreeScaleFactorFloat: Float { Float(oneDegreeScaleFactor) }
}
