// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class NexradLevel3TVS {

    static func decode(_ projectionNumbers: ProjectionNumbers, _ fileStorage: FileStorage) {        
        let rawData = NexradLevel3TextProduct.download("TVS", projectionNumbers.getRadarSite())
        var stormList = [Double]()
        if rawData.count > 10 {
            let tvs = rawData.parseColumn("P  TVS(.{20})")
            tvs.forEach {
                let s = $0.parse(".{9}(.{7})")
                let items = s.split("/")
                let degree = To.int(items[0].replace(" ", ""))
                let nm = To.int(items[1].replace(" ", ""))
                let start = ExternalGlobalCoordinates(projectionNumbers, lonNegativeOne: true)
                let ec = ExternalGeodeticCalculator.calculateEndingGlobalCoordinates(start, Double(degree), Double(nm) * 1852.0)
                stormList.append(ec.getLatitude())
                stormList.append(ec.getLongitude() * -1.0)
            }
        }
        fileStorage.tvsData = stormList
    }
}
