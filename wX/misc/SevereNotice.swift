// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class SevereNotice {

    var numberList = [String]()
    var bitmaps = [Bitmap]()
    let type: PolygonEnum

    init(_ type: PolygonEnum) {
        self.type = type
    }

    func download() {
        PolygonWatch.byType[type]?.download()
        getBitmaps()
    }

    func getBitmaps() {
        let noAlertsVerbiage: String
        let html: String
        bitmaps.removeAll()
        switch type {
        case .SPCMCD:
            noAlertsVerbiage = "No Mesoscale Discussions are currently in effect."
            html = PolygonWatch.byType[PolygonEnum.SPCMCD]!.numberList.getValue()
        case .SPCWAT:
            noAlertsVerbiage = "No watches are currently valid"
            html = PolygonWatch.byType[PolygonEnum.SPCWAT]!.numberList.getValue()
        case .WPCMPD:
            noAlertsVerbiage = "No MPDs are currently in effect."
            html = PolygonWatch.byType[PolygonEnum.WPCMPD]!.numberList.getValue()
        default:
            noAlertsVerbiage = ""
            html = ""
        }
        var text: String
        if !html.contains(noAlertsVerbiage) {
            text = html
        } else {
            text = ""
        }
        numberList = text.split(":").filter { $0 != "" }
        if text != "" {
            numberList.forEach {
                var url: String
                switch type {
                case .SPCMCD:
                    url = GlobalVariables.nwsSPCwebsitePrefix + "/products/md/mcd" + $0 + ".png"
                case .SPCWAT:
                    url = GlobalVariables.nwsSPCwebsitePrefix + "/products/watch/ww" + $0 + "_radar.gif"
                case .WPCMPD:
                    url = GlobalVariables.nwsWPCwebsitePrefix + "/metwatch/images/mcd" + $0 + ".gif"
                default:
                    url = ""
                }
                bitmaps.append(Bitmap(url))
            }
        }
    }

    func getCount() -> Int {
        bitmaps.count
    }
}
