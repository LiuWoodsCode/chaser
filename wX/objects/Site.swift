// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class Site {

    var codeName: String
    var fullName: String
    var latLon: LatLon
    var distance: Int = 0

    init(_ codeName: String, _ fullName: String, _ lat: String, _ lon: String, _ lonReversed: Bool) {
        self.codeName = codeName
        self.fullName = fullName
        var lonTmp = lon
        if lonReversed {
            lonTmp = "-" + lon
        }
        latLon = LatLon(lat, lonTmp)
    }

    static func fromLatLon(_ codeName: String, _ latLon: LatLon, _ distance: Double = 0.0) -> Site {
        let site = Site(codeName, " ", latLon.latString, latLon.lonString, false)
        site.distance = Int(distance)
        return site
    }
}
