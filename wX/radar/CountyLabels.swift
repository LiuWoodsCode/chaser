// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class CountyLabels {

    static var labels = [String]()
    static var location = [LatLon]()

    static func create() {
        if labels.isEmpty {
            var lines = UtilityIO.rawFileToStringArrayFromResource("gaz_counties_national.txt")
            _ = lines.popLast()
            lines.forEach { line in
                let items = line.split(",")
                labels.append(items[1])
                location.append(LatLon(Double(items[2])!, -1.0 * Double(items[3])!))
            }
        }
    }
}
