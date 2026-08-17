// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class RadarGeomInfo {

    //
    // radar geometry files are in: ./app/src/main/res/raw/
    // count values below are file size in bytes divided by 4 as these files contain binary packed floats
    //

    let type: RadarGeometryTypeEnum
    var isEnabled: Bool = false
//    private let lineSizeDefault = 2
//    var lineSize: Float = 0.0
//    var colorInt: Int = 0
    var lineData = MemoryBuffer()
    var count: Int
    var fileId: String

    init(_ type: RadarGeometryTypeEnum) {
        self.type = type
        count = RadarGeomInfo.typeToCount[type]!
        fileId = RadarGeomInfo.typeToFileName[type]!
        update()
    }

    func update() {
        isEnabled = Utility.readPref(RadarGeomInfo.prefToken[type]!, RadarGeomInfo.defaultPref[type]!).hasPrefix("t")
        // FIXME check wx
//        lineSize = Float(Utility.readPrefInt(RadarGeomInfo.prefTokenLineSize[type]!, lineSizeDefault))
//        colorInt = Utility.readPrefInt(RadarGeomInfo.prefTokenColorInt[type]!, RadarGeomInfo.prefTokenColorIntDefault[type]!)
    }

    func loadData() {
        let floatSize: Float = 0.0
        var newArray = [UInt8](repeating: 0, count: count * 4)
        let path = Bundle.main.path(forResource: fileId, ofType: "bin")
        let data = NSData(contentsOfFile: path!)
        data!.getBytes(&newArray, length: MemoryLayout.size(ofValue: floatSize) * count)
        lineData = MemoryBuffer(newArray)
    }

    static let typeToCount = [
        RadarGeometryTypeEnum.CaLines: 161792,
        RadarGeometryTypeEnum.MxLines: 151552,
        RadarGeometryTypeEnum.StateLines: 222980,
        RadarGeometryTypeEnum.CountyLines: 212992,
        RadarGeometryTypeEnum.HwLines: 862208,
        RadarGeometryTypeEnum.HwExtLines: 770048,
        RadarGeometryTypeEnum.LakeLines: 503808
    ]

    static let typeToFileName = [
        RadarGeometryTypeEnum.CaLines: R.Raw.ca,
        RadarGeometryTypeEnum.MxLines: R.Raw.mx,
        RadarGeometryTypeEnum.StateLines: R.Raw.statev2,
        RadarGeometryTypeEnum.CountyLines: R.Raw.county,
        RadarGeometryTypeEnum.HwLines: R.Raw.hwv4,
        RadarGeometryTypeEnum.HwExtLines: R.Raw.hwv4ext,
        RadarGeometryTypeEnum.LakeLines: R.Raw.lakesv3
    ]

    static let prefToken = [
        RadarGeometryTypeEnum.CaLines: "RADAR_CAMX_BORDERS",
        RadarGeometryTypeEnum.MxLines: "RADAR_CAMX_BORDERS",
        RadarGeometryTypeEnum.StateLines: "RADAR_SHOW_STATELINES",
        RadarGeometryTypeEnum.CountyLines: "RADAR_SHOW_COUNTY",
        RadarGeometryTypeEnum.HwLines: "COD_HW_DEFAULT",
        RadarGeometryTypeEnum.HwExtLines: "RADAR_HW_ENH_EXT",
        RadarGeometryTypeEnum.LakeLines: "COD_LAKES_DEFAULT"
    ]

    static let defaultPref = [
        RadarGeometryTypeEnum.CaLines: "false",
        RadarGeometryTypeEnum.MxLines: "false",
        RadarGeometryTypeEnum.StateLines: "true",
        RadarGeometryTypeEnum.CountyLines: "true",
        RadarGeometryTypeEnum.HwLines: "true",
        RadarGeometryTypeEnum.HwExtLines: "false",
        RadarGeometryTypeEnum.LakeLines: "false"
    ]

//    static let prefTokenLineSize = [
//        RadarGeometryTypeEnum.CaLines: "RADAR_STATE_LINESIZE",
//        RadarGeometryTypeEnum.MxLines: "RADAR_STATE_LINESIZE",
//        RadarGeometryTypeEnum.StateLines: "RADAR_STATE_LINESIZE",
//        RadarGeometryTypeEnum.CountyLines: "RADAR_COUNTY_LINESIZE",
//        RadarGeometryTypeEnum.HwLines: "RADAR_HW_LINESIZE",
//        RadarGeometryTypeEnum.HwExtLines: "RADAR_HWEXT_LINESIZE",
//        RadarGeometryTypeEnum.LakeLines: "RADAR_LAKE_LINESIZE"
//    ]
//
//    static let prefTokenColorInt = [
//        RadarGeometryTypeEnum.CaLines: "RADAR_COLOR_STATE",
//        RadarGeometryTypeEnum.MxLines: "RADAR_COLOR_STATE",
//        RadarGeometryTypeEnum.StateLines: "RADAR_COLOR_STATE",
//        RadarGeometryTypeEnum.CountyLines: "RADAR_COLOR_COUNTY",
//        RadarGeometryTypeEnum.HwLines: "RADAR_COLOR_HW",
//        RadarGeometryTypeEnum.HwExtLines: "RADAR_COLOR_HW_EXT",
//        RadarGeometryTypeEnum.LakeLines: "RADAR_COLOR_LAKES"
//    ]
//
//    static let prefTokenColorIntDefault = [
//        RadarGeometryTypeEnum.CaLines: Color.rgb(255, 255, 255),
//        RadarGeometryTypeEnum.MxLines: Color.rgb(255, 255, 255),
//        RadarGeometryTypeEnum.StateLines: Color.rgb(255, 255, 255),
//        RadarGeometryTypeEnum.CountyLines: Color.rgb(75, 75, 75),
//        RadarGeometryTypeEnum.HwLines: Color.rgb(135, 135, 135),
//        RadarGeometryTypeEnum.HwExtLines: Color.rgb(91, 91, 91),
//        RadarGeometryTypeEnum.LakeLines: Color.rgb(0, 0, 255)
//    ]
}
