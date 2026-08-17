// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class RadarPreferences {

    static var warnings = true
    static var locdotFollowsGps = false
    static var dualpaneshareposn = true
    static var spotters = false
    static var spottersLabel = false
    static var obs = false
    static var obsWindbarbs = false
    static var swo = false
    static var fire = false
    static var cities = false
    static var locDot = false
    static var countyLabels = false
    static var countyHires = false
    static var stateHires = false
    static var watMcd = false
    static var mpd = false
    static var sti = false
    static var hailIndex = false
    static var tvs = false
    static var dataRefreshInterval = 5
    static var showLegend = false
    static var obsExtZoom = 0
    static var spotterSize = 4
    static var aviationSize = 4
    static var textSizePref: Float = 10.0
    static var textSize: Float = 1.0
    static var locdotSize = 4
    static var hiSize = 4
    static var tvsSize = 4
    static var wxoglSize = 10
    static var wxoglRememberLocation = true
    static var wxoglRadarAutorefresh = false
    static var wxoglRadarAutorefreshBoolString = "false"
    static var nexradRadarBackgroundColor = 0
    static var wxoglCenterOnLocation = false
    static var wpcFronts = false
    static var showRadarWhenPan = true
    static var useMapKitBaseLayer = false
    static let nexradContinuousMode = true

    static var colorHw = 0
    static var colorHwExt = 0
    static var colorState = 0
    static var colorTstorm = 0
    static var colorTstormWatch = 0
    static var colorTor = 0
    static var colorTorWatch = 0
    static var colorFfw = 0
    static var colorMcd = 0
    static var colorMpd = 0
    static var colorLocdot = 0
    static var colorSpotter = 0
    static var colorCity = 0
    static var colorLakes = 0
    static var colorCounty = 0
    static var colorSti = 0
    static var colorHi = 0
    static var colorObs = 0
    static var colorObsWindbarbs = 0
    static var colorCountyLabels = 0

    static func initialize() {
        radarGeometrySetColors()
        if UtilityUI.isTablet() {
            locdotSize = 2
            aviationSize = 2
            spotterSize = 2
        }
        #if targetEnvironment(macCatalyst)
        locdotSize = 1
        hiSize = 1
        tvsSize = 1
        aviationSize = 2
        spotterSize = 1
        textSizePref = 15.0
        textSize = 1.5
        wxoglRadarAutorefreshBoolString = "true"
        #endif
        PolygonWarning.load()
        PolygonWatch.load()
        warnings = Utility.readPref("COD_WARNINGS_DEFAULT", "true").hasPrefix("t")
        locdotFollowsGps = Utility.readPref("LOCDOT_FOLLOWS_GPS", "false").hasPrefix("t")
        dualpaneshareposn = Utility.readPref("DUALPANE_SHARE_POSN", "true").hasPrefix("t")
        spotters = Utility.readPref("WXOGL_SPOTTERS", "false").hasPrefix("t")
        spottersLabel = Utility.readPref("WXOGL_SPOTTERS_LABEL", "false").hasPrefix("t")
        swo = Utility.readPref("RADAR_SHOW_SWO", "false").hasPrefix("t")
        fire = Utility.readPref("RADAR_SHOW_FIRE", "false").hasPrefix("t")
        obs = Utility.readPref("WXOGL_OBS", "false").hasPrefix("t")
        obsWindbarbs = Utility.readPref("WXOGL_OBS_WINDBARBS", "false").hasPrefix("t")
        cities = Utility.readPref("COD_CITIES_DEFAULT", "false").hasPrefix("t")
        locDot = Utility.readPref("COD_LOCDOT_DEFAULT", "true").hasPrefix("t")
        watMcd = Utility.readPref("RADAR_SHOW_WATCH", "false").hasPrefix("t")
        mpd = Utility.readPref("RADAR_SHOW_MPD", "false").hasPrefix("t")
        sti = Utility.readPref("RADAR_SHOW_STI", "false").hasPrefix("t")
        hailIndex = Utility.readPref("RADAR_SHOW_HI", "false").hasPrefix("t")
        tvs = Utility.readPref("RADAR_SHOW_TVS", "false").hasPrefix("t")
        countyLabels = Utility.readPref("RADAR_COUNTY_LABELS", "false").hasPrefix("t")
        countyHires = Utility.readPref("RADAR_COUNTY_HIRES", "false").hasPrefix("t")
        stateHires = Utility.readPref("RADAR_STATE_HIRES", "false").hasPrefix("t")
        showLegend = Utility.readPref("RADAR_SHOW_LEGEND", "false").hasPrefix("t")
        obsExtZoom = Utility.readPrefInt("RADAR_OBS_EXT_ZOOM", 7)
        spotterSize = Utility.readPrefInt("RADAR_SPOTTER_SIZE", spotterSize)
        aviationSize = Utility.readPrefInt("RADAR_AVIATION_SIZE", aviationSize)
        textSizePref = Utility.readPrefFloat("RADAR_TEXT_SIZE", textSizePref)
        textSize = textSizePref / 10.0
        locdotSize = Utility.readPrefInt("RADAR_LOCDOT_SIZE", locdotSize)
        hiSize = Utility.readPrefInt("RADAR_HI_SIZE", hiSize)
        tvsSize = Utility.readPrefInt("RADAR_TVS_SIZE", tvsSize)
        wxoglSize = Utility.readPrefInt("WXOGL_SIZE", wxoglSize)
        wxoglRememberLocation = Utility.readPref("WXOGL_REMEMBER_LOCATION", "true").hasPrefix("t")
        wxoglRadarAutorefresh = Utility.readPref("RADAR_AUTOREFRESH", wxoglRadarAutorefreshBoolString).hasPrefix("t")
        dataRefreshInterval = Utility.readPrefInt("RADAR_DATA_REFRESH_INTERVAL", 5)
        nexradRadarBackgroundColor = Utility.readPrefInt("NEXRAD_RADAR_BACKGROUND_COLOR", Color.rgb(0, 0, 0))
        wxoglCenterOnLocation = Utility.readPref("RADAR_CENTER_ON_LOCATION", "false").hasPrefix("t")
        wpcFronts = Utility.readPref("RADAR_SHOW_WPC_FRONTS", "false").hasPrefix("t")
        showRadarWhenPan = Utility.readPref("SHOW_RADAR_WHEN_PAN", "true").hasPrefix("t")
        useMapKitBaseLayer = Utility.readPref("NEXRAD_USE_MAPKIT_BASE_LAYER", "false").hasPrefix("t")
    }

    private static func radarGeometrySetColors() {
        colorHw = Utility.readPrefInt("RADAR_COLOR_HW", Color.rgb(135, 135, 135))
        colorHwExt = Utility.readPrefInt("RADAR_COLOR_HW_EXT", Color.rgb(91, 91, 91))
        colorState = Utility.readPrefInt("RADAR_COLOR_STATE", Color.rgb(255, 255, 255))
        colorTstorm = Utility.readPrefInt("RADAR_COLOR_TSTORM", Color.rgb(255, 255, 0))
        colorTstormWatch = Utility.readPrefInt("RADAR_COLOR_TSTORM_WATCH", Color.rgb(255, 187, 0))
        colorTor = Utility.readPrefInt("RADAR_COLOR_TOR", Color.rgb(243, 85, 243))
        colorTorWatch = Utility.readPrefInt("RADAR_COLOR_TOR_WATCH", Color.rgb(255, 0, 0))
        colorFfw = Utility.readPrefInt("RADAR_COLOR_FFW", Color.rgb(0, 255, 0))
        colorMcd = Utility.readPrefInt("RADAR_COLOR_MCD", Color.rgb(153, 51, 255))
        colorMpd = Utility.readPrefInt("RADAR_COLOR_MPD", Color.rgb(0, 255, 0))
        colorLocdot = Utility.readPrefInt("RADAR_COLOR_LOCDOT", Color.rgb(255, 255, 255))
        colorSpotter = Utility.readPrefInt("RADAR_COLOR_SPOTTER", Color.rgb(255, 0, 245))
        colorCity = Utility.readPrefInt("RADAR_COLOR_CITY", Color.rgb(255, 255, 255))
        colorLakes = Utility.readPrefInt("RADAR_COLOR_LAKES", Color.rgb(0, 0, 255))
        colorCounty = Utility.readPrefInt("RADAR_COLOR_COUNTY", Color.rgb(75, 75, 75))
        colorSti = Utility.readPrefInt("RADAR_COLOR_STI", Color.rgb(255, 255, 255))
        colorHi = Utility.readPrefInt("RADAR_COLOR_HI", Color.rgb(0, 255, 0))
        colorObs = Utility.readPrefInt("RADAR_COLOR_OBS", Color.rgb(255, 255, 255))
        colorObsWindbarbs = Utility.readPrefInt("RADAR_COLOR_OBS_WINDBARBS", Color.rgb(255, 255, 255))
        colorCountyLabels = Utility.readPrefInt("RADAR_COLOR_COUNTY_LABELS", Color.rgb(234, 214, 123))
    }
}
