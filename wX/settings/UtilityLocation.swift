// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class UtilityLocation {

    static func latLonAsDouble() -> [Double] {
        var latLonList = [Double]()
        var tmpX = ""
        var tmpY = ""
        var tmpXArr = [String]()
        var tmpYArr = [String]()
        (0..<Location.numLocations).forEach { index in
            if !Location.getX(index).contains(":") {
                tmpX = Location.getX(index)
                tmpY = Location.getY(index).replace("-", "")
            } else {
                tmpXArr = Location.getX(index).split(":")
                if tmpXArr.count > 2 {
                    tmpX = tmpXArr[2]
                }
                tmpYArr = Location.getY(index).replace("-", "").split(":")
                if tmpYArr.count > 1 {
                    tmpY = tmpYArr[1]
                }
            }
            if tmpX != "" && tmpY != "" {
                latLonList.append(To.double(tmpX))
                latLonList.append(To.double(tmpY))
            }
        }
        return latLonList
    }

    static func getNearest(_ latLon: LatLon, _ sectorToLatLon: [String: LatLon]) -> String {
        var sites = [Site]()
        for (k, v) in sectorToLatLon {
            sites.append(Site.fromLatLon(k, v, LatLon.distance(latLon, v)))
        }
        sites.sort { $0.distance < $1.distance }
        return sites[0].codeName
    }

    static func getNearestCity(_ latLon: LatLon) -> String {
        let cityData = UtilityIO.rawFileToStringArrayFromResource("cityall.txt")
        var cityToLatlon = [String: LatLon]()
        for line in cityData {
            let items = line.split(",")
            if items.count > 3 {
                if cityToLatlon.keys.contains(items[0]) {
                    // std::cout << "UtilityLocation::getNearestCity duplicate: " << items[0] << std::endl;
                }
                if To.int(items[3]) > 1000 {
                    cityToLatlon[items[0]] = LatLon(items[1], items[2])
                }
            }
        }
        var sites = [Site]()
        for m in cityToLatlon {
            sites.append(Site.fromLatLon(m.key, m.value, LatLon.distance(latLon, m.value)))
        }
        sites.sort { $0.distance < $1.distance }
        let bearingToCity = LatLon.calculateDirection(latLon, cityToLatlon[sites[0].codeName]!)
        let distanceToCIty = Int(round(LatLon.distance(latLon, cityToLatlon[sites[0].codeName]!)))
        return sites[0].codeName + " is " + To.string(distanceToCIty) + " miles to the " + bearingToCity
    }
}
