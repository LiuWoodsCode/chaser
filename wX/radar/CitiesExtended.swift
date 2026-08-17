// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class CitiesExtended {

    static var cities = [CityExt]()

    static func create() {
        if cities.isEmpty {
            let lines = UtilityIO.rawFileToStringArrayFromResource("cityall.txt")
            lines.forEach { line in
                let items = line.split(",")
                if items.count > 2 {
                    cities.append(CityExt(items[0], Double(items[1])!, -1.0 * Double(items[2])!))
                }
            }
        }
    }
}
