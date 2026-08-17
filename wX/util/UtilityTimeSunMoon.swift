// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class UtilityTimeSunMoon {

    static func getSunTimesForHomeScreen(_ latLon: LatLon) -> String {
        let now = Date()
        var sunTimeSummary = ""
        do {
            let rise = try SunCalc.time(now, .sunrise, latLon)
            let set = try SunCalc.time(now, .sunset, latLon)
            let dawnTime = try SunCalc.time(now, .dawn, latLon)
            let duskTime = try SunCalc.time(now, .dusk, latLon)
            sunTimeSummary = "Sunrise: " + formatTime(rise) + "  Sunset: " + formatTime(set) + GlobalVariables.newline + "Dawn: " + formatTime(dawnTime) + "  Dusk: " + formatTime(duskTime)
        } catch let e as SunCalc.SolarEventError {
            switch e {
            case .sunNeverRise:
                print("Sun never rise")
            case .sunNeverSet:
                print("Sun never set")
            }
        } catch let e {
            print("Unknown error: \(e)")
        }
        return sunTimeSummary
    }

    private static func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    static func getSunriseSunsetFromObs(_ obs: Site) -> (Date, Date) {
        var rise = Date()
        var set = Date()
        let now = Date()
        do {
            rise = try SunCalc.time(now, .sunrise, obs.latLon)
            set = try SunCalc.time(now, .sunset, obs.latLon)
        } catch let e as SunCalc.SolarEventError {
            switch e {
            case .sunNeverRise:
                print("Sun never rise")
            case .sunNeverSet:
                print("Sun never set")
            }
        } catch let e {
            print("Unknown error: \(e)")
        }
        return(rise, set)
    }
}
