// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class ObjectWarning {

    var url = ""
    var area = ""
    var effective = ""
    var expires = ""
    var event = ""
    var sender = ""
    var polygon = ""
    var vtec = ""
    var isCurrent = true

    init(
        _ url: String,
        _ area: String,
        _ effective: String,
        _ expires: String,
        _ event: String,
        _ sender: String,
        _ polygon: String,
        _ vtec: String,
    ) {
        self.url = url
        // detailed desc
        self.area = area

        self.effective = effective
        self.effective = self.effective.replace("T", " ")
        self.effective = UtilityString.replaceAllRegexp(self.effective, ":00-0[0-9]:00", "")

        self.expires = expires
        self.expires = self.expires.replace("T", " ")
        self.expires = UtilityString.replaceAllRegexp(self.expires, ":00-0[0-9]:00", "")

        self.event = event
        self.sender = sender
        self.polygon = polygon
        self.vtec = vtec
        isCurrent = ObjectDateTime.isVtecCurrent(self.vtec)
        if vtec.hasPrefix("O.EXP") || vtec.hasPrefix("O.CAN") {
            isCurrent = false
        }
    }

    static func parseJson(_ htmlF: String) -> [ObjectWarning] {
        let html = htmlF.replace("\"geometry\": null,", "\"geometry\": null, \"coordinates\":[[]]}")
        let urlList = UtilityString.parseColumn(html, "\"id\": \"(https://api.weather.gov/alerts/urn.*?)\"")
        let areaDescList = UtilityString.parseColumn(html, "\"areaDesc\": \"(.*?)\"")
        let effectiveList = UtilityString.parseColumn(html, "\"effective\": \"(.*?)\"")
        let expiresList = UtilityString.parseColumn(html, "\"expires\": \"(.*?)\"")
        let eventList = UtilityString.parseColumn(html, "\"event\": \"(.*?)\"")
        let senderNameList = UtilityString.parseColumn(html, "\"senderName\": \"(.*?)\"")
        let data = html.replace("\n", "").replace(" ", "")
        let listOfPolygonRaw = UtilityString.parseColumn(data, GlobalVariables.warningLatLonPattern)
        let vtecs = UtilityString.parseColumn(html, GlobalVariables.vtecPattern)
        var warnings = [ObjectWarning]()
        for index in urlList.indices {
            warnings.append(ObjectWarning(
                Utility.safeGet(urlList, index),
                Utility.safeGet(areaDescList, index),
                Utility.safeGet(effectiveList, index),
                Utility.safeGet(expiresList, index),
                Utility.safeGet(eventList, index),
                Utility.safeGet(senderNameList, index),
                Utility.safeGet(listOfPolygonRaw, index),
                Utility.safeGet(vtecs, index)
            ))
        }
        return warnings
    }

    func getClosestRadar() -> String {
        let data = polygon
                    .replace("[", "")
                    .replace("]", "")
                    .replace(",", " ")
                    .replace("-", "")
        return ObjectWarning.getClosestRadarCompute(data.split(" "))
    }

    static func getClosestRadarCompute(_ points: [String]) -> String {
        if points.count > 2 {
            return RadarSites.getNearestCode(LatLon(points[1], "-" + points[0]), includeTdwr: false)
        } else {
            return ""
        }
    }

    func getUrl() -> String {
        url
    }

    func getPolygonAsLatLons(_ mult: Int) -> [LatLon] {
        let polygonTmp = polygon.replace("[", "").replace("]", "").replace(",", " ")
        return LatLon.parseStringToLatLons(polygonTmp, Double(mult), true)
    }
}
