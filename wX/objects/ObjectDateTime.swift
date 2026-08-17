// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class ObjectDateTime {

    private var dateTime = Date()

    func addHours(_ d: Int) {
        dateTime = dateTime.addingTimeInterval(60 * 60 * Double(d))
    }

    func get() -> Date {
        dateTime
    }

    func format(_ pattern: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = pattern
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: dateTime)
    }

    //
    // start of core static methods
    //
    static func fromObs(_ time: String) -> ObjectDateTime {
        // time comes in as follows 2018.02.11 2353 UTC
        // https://valadoc.org/glib-2.0/GLib.DateTime.DateTime.from_iso8601.html
        // https://en.wikipedia.org/wiki/ISO_8601
        let returnTime = time.trim()
                                .replace(" UTC", "")
                                .replace(".", "")
                                .replace(" ", "T") + "00.000Z"
        // time should now be as "20220225T095300.000Z"
        // text has a timezone "Z" so 2nd arg is null

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss.SSSZ"
        let dateTime = dateFormatter.date(from: returnTime)
        let objectDateTime = ObjectDateTime()
        objectDateTime.dateTime = dateTime ?? Date()
        return objectDateTime
    }

    static func parse(_ timeAsString: String, _ format: String) -> ObjectDateTime {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
//        dateFormatter.timeZone = TimeZone.current
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = Locale.current
        let dateTime = dateFormatter.date(from: timeAsString)
        let objectDateTime = ObjectDateTime()
        objectDateTime.dateTime = dateTime ?? Date()
        return objectDateTime
    }

    static func isVtecCurrent(_ vtec: String ) -> Bool {
         // example 190512T1252Z-190512T1545Z
         let timeRange = vtec.parse("-([0-9]{6}T[0-9]{4})Z")
         let timeInMinutes = decodeVtecTime(timeRange)
         let currentTimeInMinutes = decodeVtecTime(getGmtTimeForVtec())
         return currentTimeInMinutes < timeInMinutes
    }

    private static func getGmtTimeForVtec() -> String {
        let UTCDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyMMddHHmm"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: UTCDate)
    }

    private static func decodeVtecTime(_ timeRangeOriginal: String) -> Date {
        // Y2K issue
        // TODO decode from string using ObjectDateTime
        let timeRange = timeRangeOriginal.replace("T", "")
        let year = To.int("20" + timeRange.parse("([0-9]{2})[0-9]{4}[0-9]{4}"))
        let month = To.int(timeRange.parse("[0-9]{2}([0-9]{2})[0-9]{2}[0-9]{4}"))
        let day = To.int(timeRange.parse("[0-9]{4}([0-9]{2})[0-9]{4}"))
        let hour = To.int(timeRange.parse("[0-9]{6}([0-9]{2})[0-9]{2}"))
        let minute = To.int(timeRange.parse("[0-9]{6}[0-9]{2}([0-9]{2})"))
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.timeZone = TimeZone(abbreviation: "GMT")
        dateComponents.hour = hour
        dateComponents.minute = minute
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)
        return date!
    }

    static func getCurrentTimeInUTC() -> Date {
        Date()
    }

    static func gmtTime() -> String {
        let UTCDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy HH:mm"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return "GMT: " + formatter.string(from: UTCDate)
    }

    // is difference between t1 and t2 less then 20min
    static func timeDifference(_ t1: Date, _ t2: Date, _ m: Int) -> Bool {
        let date = t2.addingTimeInterval(Double(m) * 60)
        return date > t1
    }

    static func secondsFromUTC() -> Int {
        TimeZone.current.secondsFromGMT()
    }

    static func getDateAsString(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format // "MMMM dd yyyy"
        return dateFormatter.string(from: Date())
    }

    static func getLocalTimeAsString() -> String {
        getDateAsString("yyyy-MM-dd HH:mm:ss")
    }

    static func currentTimeMillis() -> Int {
        Int((Date().timeIntervalSince1970 * 1000.0).rounded())
    }

    static func getCurrentHourInUTC() -> Int {
        let date = Date()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let components = calendar.dateComponents([.hour], from: date)
        return components.hour ?? 0
    }

    static func getYear() -> Int {
        Calendar.current.component(.year, from: Date())
    }

    static func getYearString() -> String {
        String(Calendar.current.component(.year, from: Date()))
    }

    static func getYearShortString() -> String {
        String(Calendar.current.component(.year, from: Date())).substring(2)
    }

    static func translateTimeForHourly(_ originalTime: String) -> String {
        var items = originalTime.split("-")
        items.removeLast()
        let timeNoTz = items.joined(separator: "-")
        let objectDateTime = parse(timeNoTz, "yyyy'-'MM'-'dd'T'HH':'mm':'ss")
        return if UIPreferences.hourlyShowAMPM {
            objectDateTime.format("E hh a")
        } else {
            objectDateTime.format("E HH")
        }
    }

    static func generateModelRuns(_ time: String, _ hours: Int, _ dateStr: String) -> [String] {
        let dateFmt = DateFormatter()
        dateFmt.timeZone = TimeZone(secondsFromGMT: 0)
        dateFmt.dateFormat = dateStr
        let date = dateFmt.date(from: time)
        var runs = [String]()
        (1...4).forEach {
            let timeChange = 60.0 * 60.0 * Double(hours) * Double($0)
            runs.append(dateFmt.string(from: (date! - timeChange) as Date))
        }
        return runs
    }

    static func convertFromUTCForMetar(_ time: String) -> String {
        // time comes in as follows 2018.02.11 2353 UTC
        var returnTime = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd' 'HHmm"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let date = dateFormatter.date(from: time.replace("+00:00", ""))
        dateFormatter.dateFormat = "MM-dd h:mm a"
        dateFormatter.timeZone = TimeZone.current
        if let goodDate = date {
            returnTime = dateFormatter.string(from: goodDate)
        }
        return returnTime
    }

    static func getTimeFromPointAsString(_ sec: CLong) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(sec))
        let dateFormatter = DateFormatter()
        if UIPreferences.hourlyShowAMPM {
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
        return dateFormatter.string(from: date)
    }

    static func radarTime(_ volumeScanDate: Int16, _ volumeScanTime: Int) -> String {
        getTimeFromPointAsString(CLong((Int(volumeScanDate) - 1) * 60 * 60 * 24) + Int(volumeScanTime))
    }

    static func radarTimeL2(_ days: Int16, _ milliSeconds: Int) -> String {
        getTimeFromPointAsString((CLong(days - 1)) * 24 * 60 * 60 + milliSeconds / 1000)
    }
}
