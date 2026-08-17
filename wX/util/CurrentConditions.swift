// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class CurrentConditions {

    var iconUrl = ""
    var topLine = ""
    var middleLine = ""
    var spokenText = ""
    private var windGustSpoken = ""
    private var timeStringUtc = ""
    private var latLon = LatLon()

    func process(_ latLon: LatLon, _ index: Int = 0) {
        self.latLon = latLon
        let objectMetar = ObjectMetar(latLon, index)
        timeStringUtc = objectMetar.timeStringUtc
        var data = objectMetar.temperature + GlobalVariables.degreeSymbol
        if objectMetar.windChill != "NA" {
            data += "(" + objectMetar.windChill + GlobalVariables.degreeSymbol + ")"
        } else if objectMetar.heatIndex != "NA" {
            data += "(" + objectMetar.heatIndex + GlobalVariables.degreeSymbol + ")"
        }
        data += " / " + objectMetar.dewPoint + GlobalVariables.degreeSymbol + "(" + objectMetar.relativeHumidity + "%" + ")" + " - "
        data += objectMetar.seaLevelPressure + " - " + objectMetar.windDirection + " " + objectMetar.windSpeed
        if objectMetar.windGust != "" {
            data += " G "
            windGustSpoken = " gusting to \(objectMetar.windGust) miles per hour "
        } else {
            windGustSpoken = ""
        }
        data += "\(objectMetar.windGust) mph - \(objectMetar.visibility) mi - \(objectMetar.condition)"
        iconUrl = objectMetar.icon
        format(objectMetar, data)
    }

    private func format(_ objectMetar: ObjectMetar, _ data: String) {
        let separator = " - "
        let dataList = data.split(separator)
        var topLineLocal = ""
        var middleLineLocal = ""
        if dataList.count > 4 {
            let list = dataList[0].split("/")
            topLineLocal = dataList[4].replaceAll("^ ", "") + " " + list[0] + dataList[2]
            middleLineLocal = list[1].replaceAll("^ ", "") + separator + dataList[1] + separator + dataList[3] + GlobalVariables.newline
            middleLineLocal += objectMetar.conditionsTimeString + " " + getObsFullName(objectMetar.obsClosest.codeName)
        }
        topLine = topLineLocal
        middleLine = middleLineLocal
        spokenText = "\(objectMetar.condition), temperature is \(objectMetar.temperature + GlobalVariables.degreeSymbol) with wind at \(UtilityLocationFragment.windCodeToSpoken(objectMetar.windDirection)) \(objectMetar.windSpeed) miles per hour \(windGustSpoken) dew point is \(objectMetar.dewPoint + GlobalVariables.degreeSymbol), relative humidity is \(objectMetar.relativeHumidity + "%"), pressure in milli-bars is \(objectMetar.seaLevelPressure), visibility is \(objectMetar.visibility) miles \(objectMetar.conditionsTimeString) \(getObsFullName(objectMetar.obsClosest.codeName))"
    }

    private func getObsFullName(_ obsSite: String) -> String {
        let locationName = Metar.sites.byCode[obsSite]!.fullName
        return "\(locationName.trimnl()) (\(obsSite))"
    }

    func timeCheck() {
        let obsTime = ObjectDateTime.fromObs(timeStringUtc)
        let currentTime = ObjectDateTime.getCurrentTimeInUTC()
        let isTimeCurrent = ObjectDateTime.timeDifference(currentTime, obsTime.get(), 120)
        if !isTimeCurrent {
             process(latLon, 1)
        }
    }
}
