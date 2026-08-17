// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class Sites {

    var sites: [Site] = []
    var byCode: [String: Site] = [:]
    var codeList: [String] = []
    var nameList: [String] = []

    init(
        _ nameDict: [String: String],
        _ latDict: [String: String],
        _ lonDict: [String: String],
        _ lonReversed: Bool = false
    ) {
        for (key, value) in nameDict {
            sites.append(Site(key, value, latDict[key]!, lonDict[key]!, lonReversed))
            byCode[key] = sites.last!
        }

        sites.sort(by: {$0.fullName < $1.fullName})

        for site in sites {
            codeList.append(site.codeName)
            nameList.append("\(site.codeName): \(site.fullName)")
        }
    }

    func getNearest(_ latLon: LatLon) -> String {
        for site in sites {
            site.distance = Int(LatLon.distance(latLon, site.latLon))
        }
        sites.sort(by: {$0.distance < $1.distance})
        return sites[0].codeName
    }

    func getNearestSite(_ latLon: LatLon, _ order: Int = 0) -> Site {
        for site in sites {
            site.distance = Int(LatLon.distance(latLon, site.latLon))
        }
        sites.sort(by: {$0.distance < $1.distance})
        return sites[order]
    }

    func getNearestInMiles(_ latLon: LatLon) -> Int {
        for site in sites {
            site.distance = Int(LatLon.distance(latLon, site.latLon))
        }
        sites.sort(by: {$0.distance < $1.distance})
        return sites[0].distance
    }
}
