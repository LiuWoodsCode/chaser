// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

struct LatLon {

    private var latNum = 0.0
    private var lonNum = 0.0
    private var xStr = "0.0"
    private var yStr = "0.0"

    init() {}

    init(_ latLon: [Double]) {
        lat = latLon[0]
        lon = latLon[1]
    }

    init(_ lat: Double, _ lon: Double) {
        self.lat = lat
        self.lon = lon
    }

    init(_ xStr: String, _ yStr: String) {
        self.xStr = xStr
        self.yStr = yStr
        latNum = To.double(self.xStr)
        lonNum = To.double(self.yStr)
    }

    // SPC and WPC issue text products with LAT/LON encoded in a special format
    // points in polygons are 8 char long separated by whitespace spread over multiple
    // fixed width lines
    // notice that long over 100 are show with the leading 1 omitted
    // 35768265 <- 35.76 82.65
    // 36730423 <- 36.73 104.23
    init(_ temp: String) {
        xStr = temp.substring(0, 4)
        yStr = temp.substring(4, 8)
        xStr = UtilityString.addPeriodBeforeLastTwoChars(xStr)
        yStr = UtilityString.addPeriodBeforeLastTwoChars(yStr)
        var tmpDbl = To.double(yStr)
        if tmpDbl < 40.00 {
            tmpDbl += 100
            yStr = To.stringFromD(tmpDbl)
        }
        latNum = To.double(xStr)
        lonNum = To.double(yStr)
    }

    var list: [Double] { [lat, lon] }

    var lat: Double {
        get { latNum }
        set {
            latNum = newValue
            xStr = String(latNum)
        }
    }

    var lon: Double {
        get { lonNum }
        set {
            lonNum = newValue
            yStr = String(lonNum)
        }
    }

    var latString: String {
        get { xStr }
        set {
            xStr = newValue
            latNum = To.double(newValue)
        }
    }

    var lonString: String {
        get { yStr }
        set {
            yStr = newValue
            lonNum = To.double(newValue)
        }
    }

    func latInRadians() -> Double {
        UtilityMath.deg2rad(lat)
    }

    func lonInRadians() -> Double {
        UtilityMath.deg2rad(lon)
    }

    var latForNws: String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 4
        return formatter.string(from: NSNumber(value: lat))!
    }

    var lonForNws: String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 4
        return formatter.string(from: NSNumber(value: lon))!
    }

    // used in adhoc location save
    func prettyPrint() -> String {
        latForNws + ", " + lonForNws
    }

    func prettyPrintNexrad() -> String {
        latForNws + ", -" + lonForNws
    }

    // used in UtilitySwoD1 and UtilityDownloadRadar
    func printSpaceSeparated() -> String {
        latString + " " + lonString + " "
    }

    func asPoint() -> ExternalPoint {
        ExternalPoint(lat, lon)
    }

    func reverse() -> LatLon {
        LatLon(lat, -1.0 * lon)
    }

    static func distance(_ location1: LatLon, _ location2: LatLon, _ unit: DistanceUnit = .MILES) -> Double {
        let theta = location1.lon - location2.lon
        var dist = sin(
            UtilityMath.deg2rad(location1.lat))
            * sin(UtilityMath.deg2rad(location2.lat)) + cos(UtilityMath.deg2rad(location1.lat))
            * cos(UtilityMath.deg2rad(location2.lat)) * cos(UtilityMath.deg2rad(theta)
        )
        dist = acos(dist)
        dist = UtilityMath.rad2deg(dist)
        dist = dist * 60 * 1.1515
        switch unit {
        case .K:
            return dist * 1.609344
        case .N:
            return dist * 0.8684
        case .MILES:
            return dist
        }
    }

    static func calculateBearing(_ start: LatLon, _ end: LatLon) -> Int {
        let deltaLon = end.lonInRadians() - start.lonInRadians()
        let x = cos(end.latInRadians()) * sin(deltaLon)
        let y = cos(start.latInRadians()) * sin(end.latInRadians()) - sin(start.latInRadians()) * cos(end.latInRadians()) * cos(deltaLon)
        let b = atan2(x, y)
        var bearing = Int(UtilityMath.rad2deg(b)) % 360
        if bearing < 0 {
            bearing += 360
        }
        return bearing
    }

    static func calculateDirection(_ start: LatLon, _ end: LatLon) -> String {
        UtilityMath.bearingToDirection(calculateBearing(start, end))
    }

    // take a space separated list of numbers and return a list of LatLon, list is of the format
    // lon0 lat0 lon1 lat1 for watch
    // for UtilityWatch need to multiply Y by -1.0
    static func parseStringToLatLons(_ stringOfNumbers: String, _ multiplier: Double = 1.0, _ isWarning: Bool = true) -> [LatLon] {
        let list = stringOfNumbers.split(" ")
        var x = [Double]()
        var y = [Double]()
        list.indices.forEach { i in
            if isWarning {
                if i.isEven() {
                    y.append(To.double(list[i]) * multiplier)
                } else {
                    x.append(To.double(list[i]))
                }
            } else {
                if i.isEven() {
                    x.append(To.double(list[i]))
                } else {
                    y.append(To.double(list[i]) * multiplier)
                }
            }
        }
        var latLons = [LatLon]()
        if y.count > 3 && x.count > 3 && x.count == y.count {
            x.indices.forEach { index in latLons.append(LatLon(x[index], y[index])) }
        }
        return latLons
    }

    static func latLonListToListOfDoubles(_ latLons: [LatLon], _ projectionNumbers: ProjectionNumbers) -> [Double] {
        var warningList = [Double]()
        if latLons.count > 0 {
            let startCoordinates = Projection.computeMercatorNumbers(latLons[0], projectionNumbers)
            warningList += startCoordinates
            (1..<latLons.count).forEach { index in
                let coordinates = Projection.computeMercatorNumbers(latLons[index], projectionNumbers)
                warningList += coordinates
                warningList += coordinates
            }
            warningList += startCoordinates
        }
        return warningList
    }

    static func storeWatchMcdLatLon(_ html: String) -> String {
        let coordinates = html.parseColumn("([0-9]{8}).*?")
        var s = ""
        coordinates.forEach {
            s += LatLon($0).printSpaceSeparated()
        }
        s += ":"
        return s.replace(" :", ":")
    }
}

extension LatLon: Equatable {
    static func == (lhs: LatLon, rhs: LatLon) -> Bool { lhs.latString == rhs.latString && lhs.lonString == rhs.lonString }
}
