// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

struct GeographyType {
    static var stateLines = GeographyType(
        RadarGeometry.dataByType[.StateLines]!.lineData,
        RadarGeometry.dataByType[.StateLines]!.lineData.length / 4,
        RadarPreferences.colorState,
        true
    )
    static var mxLines = GeographyType(
        RadarGeometry.dataByType[.MxLines]!.lineData,
        RadarGeometry.dataByType[.MxLines]!.lineData.length / 4,
        RadarPreferences.colorState,
        RadarGeometry.dataByType[.MxLines]!.isEnabled
    )
    static var caLines = GeographyType(
        RadarGeometry.dataByType[.CaLines]!.lineData,
        RadarGeometry.dataByType[.CaLines]!.lineData.length / 4,
        RadarPreferences.colorState,
        RadarGeometry.dataByType[.CaLines]!.isEnabled
    )
    static var countyLines = GeographyType(
        RadarGeometry.dataByType[.CountyLines]!.lineData,
        RadarGeometry.dataByType[.CountyLines]!.lineData.length / 4,
        RadarPreferences.colorCounty,
        RadarGeometry.dataByType[.CountyLines]!.isEnabled
    )
    static var lakes = GeographyType(
        RadarGeometry.dataByType[.LakeLines]!.lineData,
        RadarGeometry.dataByType[.LakeLines]!.lineData.length / 4,
        RadarPreferences.colorLakes,
        RadarGeometry.dataByType[.LakeLines]!.isEnabled
    )
    static var highways = GeographyType(
        RadarGeometry.dataByType[.HwLines]!.lineData,
        RadarGeometry.dataByType[.HwLines]!.lineData.length / 4,
        RadarPreferences.colorHw,
        RadarGeometry.dataByType[.HwLines]!.isEnabled
    )
    static var highwaysExtended = GeographyType(
        RadarGeometry.dataByType[.HwExtLines]!.lineData,
        RadarGeometry.dataByType[.HwExtLines]!.lineData.length / 4,
        RadarPreferences.colorHwExt,
        RadarGeometry.dataByType[.HwExtLines]!.isEnabled
    )
    static var cities = GeographyType(
        MemoryBuffer(),
        0,
        RadarPreferences.colorCity,
        RadarPreferences.cities
    )
    static var countyLabels = GeographyType(
        MemoryBuffer(),
        0,
        RadarPreferences.colorCountyLabels,
        RadarPreferences.countyLabels
    )
    static var NONE = GeographyType(
        RadarGeometry.dataByType[.HwExtLines]!.lineData,
        RadarGeometry.dataByType[.HwExtLines]!.lineData.length / 4,
        RadarPreferences.colorHwExt,
        false
    )

    var relativeBuffer = MemoryBuffer()
    var count = 0
    var color = 0
    var display = true

    init(_ relativeBuffer: MemoryBuffer, _ count: Int, _ color: Int, _ pref: Bool) {
        self.relativeBuffer = relativeBuffer
        self.count = count
        self.color = color
        display = pref
    }

    static func regen() {
        stateLines = GeographyType(
            RadarGeometry.dataByType[.StateLines]!.lineData,
            RadarGeometry.dataByType[.StateLines]!.lineData.length / 4,
            RadarPreferences.colorState,
            true
        )
        mxLines = GeographyType(
            RadarGeometry.dataByType[.MxLines]!.lineData,
            RadarGeometry.dataByType[.MxLines]!.lineData.length / 4,
            RadarPreferences.colorState,
            RadarGeometry.dataByType[.MxLines]!.isEnabled
        )
        caLines = GeographyType(
            RadarGeometry.dataByType[.CaLines]!.lineData,
            RadarGeometry.dataByType[.CaLines]!.lineData.length / 4,
            RadarPreferences.colorState,
            RadarGeometry.dataByType[.CaLines]!.isEnabled
        )
        countyLines = GeographyType(
            RadarGeometry.dataByType[.CountyLines]!.lineData,
            RadarGeometry.dataByType[.CountyLines]!.lineData.length / 4,
            RadarPreferences.colorCounty,
            RadarGeometry.dataByType[.CountyLines]!.isEnabled
        )
        lakes = GeographyType(
            RadarGeometry.dataByType[.LakeLines]!.lineData,
            RadarGeometry.dataByType[.LakeLines]!.lineData.length / 4,
            RadarPreferences.colorLakes,
            RadarGeometry.dataByType[.LakeLines]!.isEnabled
        )
        highways = GeographyType(
            RadarGeometry.dataByType[.HwLines]!.lineData,
            RadarGeometry.dataByType[.HwLines]!.lineData.length / 4,
            RadarPreferences.colorHw,
            RadarGeometry.dataByType[.HwLines]!.isEnabled
        )
        highwaysExtended = GeographyType(
            RadarGeometry.dataByType[.HwExtLines]!.lineData,
            RadarGeometry.dataByType[.HwExtLines]!.lineData.length / 4,
            RadarPreferences.colorHwExt,
            RadarGeometry.dataByType[.HwExtLines]!.isEnabled
        )
        cities = GeographyType(
            MemoryBuffer(),
            0,
            RadarPreferences.colorCity,
            RadarPreferences.cities
        )
        countyLabels = GeographyType(
            MemoryBuffer(),
            0,
            RadarPreferences.colorCountyLabels,
            RadarPreferences.countyLabels
        )
        NONE = GeographyType(
            RadarGeometry.dataByType[.HwExtLines]!.lineData,
            RadarGeometry.dataByType[.HwExtLines]!.lineData.length / 4,
            RadarPreferences.colorHwExt,
            false
        )
    }
}
