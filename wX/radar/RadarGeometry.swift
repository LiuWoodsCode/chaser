// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class RadarGeometry {

    static var dataByType = [RadarGeometryTypeEnum: RadarGeomInfo]()

    static let orderedTypes = [
        RadarGeometryTypeEnum.CountyLines,
        RadarGeometryTypeEnum.StateLines,
        RadarGeometryTypeEnum.CaLines,
        RadarGeometryTypeEnum.MxLines,
        RadarGeometryTypeEnum.HwLines,
        RadarGeometryTypeEnum.HwExtLines,
        RadarGeometryTypeEnum.LakeLines
    ]

    static func initialize() {
        orderedTypes.forEach {
            dataByType[$0] = RadarGeomInfo($0)
        }
        if RadarPreferences.stateHires {
            dataByType[RadarGeometryTypeEnum.StateLines]!.count = 1166552
            dataByType[RadarGeometryTypeEnum.StateLines]!.fileId = R.Raw.statev3
        }
        if RadarPreferences.countyHires {
            dataByType[RadarGeometryTypeEnum.CountyLines]!.count = 820852
            dataByType[RadarGeometryTypeEnum.CountyLines]!.fileId = R.Raw.countyv2
        }
        orderedTypes.forEach {
            dataByType[$0]!.loadData()
        }
    }

    // FIXME check wx
//    static func updateConfig() {
//        dataByType.values.forEach {
//            $0.update()
//        }
//    }
}
