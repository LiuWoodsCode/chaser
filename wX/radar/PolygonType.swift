// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

struct PolygonType: Hashable {
    static var NONE = PolygonType(RadarPreferences.colorMcd, "", false) // was "MCD"
    static var SMW = PolygonType(
        PolygonWarning.byType[PolygonTypeGeneric.SMW]!.color,
        "SMW",
        PolygonWarning.byType[PolygonTypeGeneric.SMW]!.isEnabled
    )
    static var SQW = PolygonType(
        PolygonWarning.byType[PolygonTypeGeneric.SQW]!.color,
        "SQW",
        PolygonWarning.byType[PolygonTypeGeneric.SQW]!.isEnabled
    )
    static var DSW = PolygonType(
        PolygonWarning.byType[PolygonTypeGeneric.DSW]!.color,
        "DSW",
        PolygonWarning.byType[PolygonTypeGeneric.DSW]!.isEnabled
    )
    static var SPS = PolygonType(
        PolygonWarning.byType[PolygonTypeGeneric.SPS]!.color,
        "SPS",
        PolygonWarning.byType[PolygonTypeGeneric.SPS]!.isEnabled
    )
    static var MCD = PolygonType(RadarPreferences.colorMcd, "MCD", RadarPreferences.watMcd)
    static var MPD = PolygonType(RadarPreferences.colorMpd, "MPD", RadarPreferences.mpd)
    static var WATCH = PolygonType(RadarPreferences.colorTstormWatch, "WATCH", RadarPreferences.watMcd)
    static var WATCH_TORNADO = PolygonType(
        RadarPreferences.colorTorWatch,
        "WATCH_TORNADO",
        RadarPreferences.watMcd
    )
    static var TST = PolygonType(RadarPreferences.colorTstorm, "TST", RadarPreferences.warnings)
    static var TOR = PolygonType(RadarPreferences.colorTor, "TOR", RadarPreferences.warnings)
    static var FFW = PolygonType(RadarPreferences.colorFfw, "FFW", RadarPreferences.warnings)
    static var SPOTTER = PolygonType(
        RadarPreferences.colorSpotter,
        "SPOTTER",
        RadarPreferences.spotters,
        RadarPreferences.spotterSize
    )
    static var SPOTTER_LABELS = PolygonType(
        RadarPreferences.colorSpotter,
        "SPOTTER_LABELS",
        RadarPreferences.spottersLabel
    )
    static var WIND_BARB_GUSTS = PolygonType(
        Color.RED,
        "WIND_BARB_GUSTS",
        RadarPreferences.obsWindbarbs,
        RadarPreferences.aviationSize
    )
    static var WIND_BARB = PolygonType(
        RadarPreferences.colorObsWindbarbs,
        "WIND_BARB",
        RadarPreferences.obsWindbarbs,
        RadarPreferences.aviationSize
    )
    static var WIND_BARB_CIRCLE = PolygonType(
        RadarPreferences.colorObsWindbarbs,
        "WIND_BARB_CIRCLE",
        RadarPreferences.obsWindbarbs,
        RadarPreferences.aviationSize
    )
    static var LOCDOT = PolygonType(
        RadarPreferences.colorLocdot,
        "LOCDOT",
        RadarPreferences.locDot,
        RadarPreferences.locdotSize
    )
    static var LOCDOT_CIRCLE = PolygonType(
        RadarPreferences.colorLocdot,
        "LOCDOT_CIRCLE",
        RadarPreferences.locdotFollowsGps,
        RadarPreferences.locdotSize
    )
    static var STI = PolygonType(RadarPreferences.colorSti, "STI", RadarPreferences.sti)
    static var TVS = PolygonType(
        RadarPreferences.colorTor,
        "TVS",
        RadarPreferences.tvs,
        RadarPreferences.tvsSize
    )
    static var HI = PolygonType(
        RadarPreferences.colorHi,
        "HI",
        RadarPreferences.hailIndex,
        RadarPreferences.hiSize
    )
    static var OBS = PolygonType(
        RadarPreferences.colorObs,
        "OBS",
        RadarPreferences.obs
    )
    static var SWO = PolygonType(
        RadarPreferences.colorHi,
        "SWO",
        RadarPreferences.swo
    )
    static var FIRE = PolygonType(
        RadarPreferences.colorHi,
        "FIRE",
        RadarPreferences.fire
    )
    var color = 0
    var string = ""
    var size = 0.0
    var display = false

    init(_ color: Int, _ stringValue: String, _ pref: Bool) {
        self.color = color
        string = stringValue
        display = pref
    }

    init(_ color: Int, _ stringValue: String, _ pref: Bool, _ size: Int) {
        self.init(color, stringValue, pref)
        self.size = Double(size)
    }

    static func regen() {
        NONE = PolygonType(RadarPreferences.colorMcd, "", false) // was "MCD"
        SMW = PolygonType(
            PolygonWarning.byType[PolygonTypeGeneric.SMW]!.color,
            "SMW",
            PolygonWarning.byType[PolygonTypeGeneric.SMW]!.isEnabled
        )
        SQW = PolygonType(
            PolygonWarning.byType[PolygonTypeGeneric.SQW]!.color,
            "SQW",
            PolygonWarning.byType[PolygonTypeGeneric.SQW]!.isEnabled
        )
        DSW = PolygonType(
            PolygonWarning.byType[PolygonTypeGeneric.DSW]!.color,
            "DSW",
            PolygonWarning.byType[PolygonTypeGeneric.DSW]!.isEnabled
        )
        SPS = PolygonType(
            PolygonWarning.byType[PolygonTypeGeneric.SPS]!.color,
            "SPS",
            PolygonWarning.byType[PolygonTypeGeneric.SPS]!.isEnabled
        )
        MCD = PolygonType(RadarPreferences.colorMcd, "MCD", RadarPreferences.watMcd)
        MPD = PolygonType(RadarPreferences.colorMpd, "MPD", RadarPreferences.mpd)
        WATCH = PolygonType(RadarPreferences.colorTstormWatch, "WATCH", RadarPreferences.watMcd)
        WATCH_TORNADO = PolygonType(RadarPreferences.colorTorWatch, "WATCH_TORNADO", RadarPreferences.watMcd)
        TST = PolygonType(RadarPreferences.colorTstorm, "TST", RadarPreferences.warnings)
        TOR = PolygonType(RadarPreferences.colorTor, "TOR", RadarPreferences.warnings)
        FFW = PolygonType(RadarPreferences.colorFfw, "FFW", RadarPreferences.warnings)
        SPOTTER = PolygonType(
            RadarPreferences.colorSpotter,
            "SPOTTER",
            RadarPreferences.spotters,
            RadarPreferences.spotterSize
        )
        SPOTTER_LABELS = PolygonType(
            RadarPreferences.colorSpotter,
            "SPOTTER_LABELS",
            RadarPreferences.spottersLabel
        )
        WIND_BARB_GUSTS = PolygonType(
            Color.RED,
            "WIND_BARB_GUSTS",
            RadarPreferences.obsWindbarbs,
            RadarPreferences.aviationSize
        )
        WIND_BARB = PolygonType(
            RadarPreferences.colorObsWindbarbs,
            "WIND_BARB",
            RadarPreferences.obsWindbarbs,
            RadarPreferences.aviationSize
        )
        WIND_BARB_CIRCLE = PolygonType(
            RadarPreferences.colorObsWindbarbs,
            "WIND_BARB_CIRCLE",
            RadarPreferences.obsWindbarbs,
            RadarPreferences.aviationSize
        )
        LOCDOT = PolygonType(
            RadarPreferences.colorLocdot,
            "LOCDOT",
            RadarPreferences.locDot,
            RadarPreferences.locdotSize
        )
        LOCDOT_CIRCLE = PolygonType(
            RadarPreferences.colorLocdot,
            "LOCDOT_CIRCLE",
            RadarPreferences.locdotFollowsGps,
            RadarPreferences.locdotSize
        )
        STI = PolygonType(RadarPreferences.colorSti, "STI", RadarPreferences.sti)
        TVS = PolygonType(RadarPreferences.colorTor, "TVS", RadarPreferences.tvs, RadarPreferences.tvsSize)
        HI = PolygonType(RadarPreferences.colorHi, "HI", RadarPreferences.hailIndex, RadarPreferences.hiSize)
        OBS = PolygonType(RadarPreferences.colorObs, "OBS", RadarPreferences.obs)
        SWO = PolygonType(RadarPreferences.colorHi, "SWO", RadarPreferences.swo)
        FIRE = PolygonType(RadarPreferences.colorHi, "FIRE", RadarPreferences.fire)
    }
}
