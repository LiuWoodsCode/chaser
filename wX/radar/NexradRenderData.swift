// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

class NexradRenderData {

    #if !targetEnvironment(macCatalyst)
    static let zoomToHideMiscFeatures: Float = 0.5
    #endif
    #if targetEnvironment(macCatalyst)
    static let zoomToHideMiscFeatures: Float = 0.2
    #endif

    var radarLayers = [MetalBuffers]()
    var radarBuffers = MetalRadarBuffers(RadarPreferences.nexradRadarBackgroundColor)
    var geographicBuffers = [MetalBuffers]()
    var stateLineBuffers = MetalBuffers(GeographyType.stateLines, 0.0)
    var mxLineBuffers = MetalBuffers(GeographyType.mxLines, 0.0)
    var caLineBuffers = MetalBuffers(GeographyType.caLines, 0.0)
    var countyLineBuffers = MetalBuffers(GeographyType.countyLines, 0.75)
    var hwBuffers = MetalBuffers(GeographyType.highways, zoomToHideMiscFeatures)
    let hwExtBuffers = MetalBuffers(GeographyType.highwaysExtended, 3.00)
    let lakeBuffers = MetalBuffers(GeographyType.lakes, zoomToHideMiscFeatures)
    let stiBuffers = MetalBuffers(PolygonType.STI, zoomToHideMiscFeatures)
    let wbBuffers = MetalBuffers(PolygonType.WIND_BARB, zoomToHideMiscFeatures)
    let wbGustsBuffers = MetalBuffers(PolygonType.WIND_BARB_GUSTS, zoomToHideMiscFeatures)
    let hiBuffers = MetalBuffers(PolygonType.HI, zoomToHideMiscFeatures)
    let tvsBuffers = MetalBuffers(PolygonType.TVS, zoomToHideMiscFeatures)

    let warningBuffers = [
        PolygonTypeGeneric.TST: MetalBuffers(PolygonType.TST),
        PolygonTypeGeneric.TOR: MetalBuffers(PolygonType.TOR),
        PolygonTypeGeneric.FFW: MetalBuffers(PolygonType.FFW),
        PolygonTypeGeneric.SMW: MetalBuffers(PolygonType.SMW),
        PolygonTypeGeneric.SQW: MetalBuffers(PolygonType.SQW),
        PolygonTypeGeneric.DSW: MetalBuffers(PolygonType.DSW),
        PolygonTypeGeneric.SPS: MetalBuffers(PolygonType.SPS)
    ]

    let watchBuffers1 = [
        PolygonEnum.SPCWAT: MetalBuffers(PolygonType.WATCH),
        PolygonEnum.SPCWAT_TORNADO: MetalBuffers(PolygonType.WATCH_TORNADO),
        PolygonEnum.SPCMCD: MetalBuffers(PolygonType.MCD),
        PolygonEnum.WPCMPD: MetalBuffers(PolygonType.MPD)
    ]

    let swoBuffers = MetalBuffers(PolygonType.SWO)
    let fireBuffers = MetalBuffers(PolygonType.FIRE)
    let locdotBuffers = MetalBuffers(PolygonType.LOCDOT)
    let locCircleBuffers = MetalBuffers(PolygonType.LOCDOT_CIRCLE)
    let wbCircleBuffers = MetalBuffers(PolygonType.WIND_BARB_CIRCLE, zoomToHideMiscFeatures)
    let spotterBuffers = MetalBuffers(PolygonType.SPOTTER, zoomToHideMiscFeatures)
    var wpcFrontBuffersList = [MetalBuffers]()
    var wpcFrontPaints = [Int]()

    init() {
        radarLayers = [radarBuffers]
        [countyLineBuffers, stateLineBuffers, caLineBuffers, mxLineBuffers, hwBuffers, hwExtBuffers, lakeBuffers].forEach {
            if $0.geoType.display {
                geographicBuffers.append($0)
            }
        }
        [countyLineBuffers, stateLineBuffers, caLineBuffers, mxLineBuffers, hwBuffers, hwExtBuffers, lakeBuffers].forEach {
            if $0.geoType.display {
                radarLayers.append($0)
            }
        }
    }

    func cleanup() {
        radarLayers.removeAll()
        geographicBuffers.removeAll()
        stateLineBuffers = MetalBuffers(GeographyType.stateLines, 0.0)
        countyLineBuffers = MetalBuffers(GeographyType.countyLines, 0.75)
        hwBuffers = MetalBuffers(GeographyType.highways, 0.45)
        radarBuffers.levelData.radarBuffers = nil
        radarBuffers.levelData.radialStartAngle = MemoryBuffer()
        radarBuffers.levelData.binWord = MemoryBuffer()
        radarBuffers.levelData = NexradLevelData()
        radarBuffers.metalBuffer.removeAll()
        radarBuffers = MetalRadarBuffers(RadarPreferences.nexradRadarBackgroundColor)
    }

    func addToLayers() {
        [PolygonTypeGeneric.TST,
            PolygonTypeGeneric.TOR,
            PolygonTypeGeneric.FFW,
            PolygonTypeGeneric.SMW,
            PolygonTypeGeneric.SQW,
            PolygonTypeGeneric.DSW,
            PolygonTypeGeneric.SPS].forEach {
            if warningBuffers[$0]!.type.display {
                radarLayers.append(warningBuffers[$0]!)
            }
        }
        [PolygonEnum.SPCMCD, PolygonEnum.SPCWAT, PolygonEnum.SPCWAT_TORNADO, PolygonEnum.WPCMPD].forEach {
            if watchBuffers1[$0]!.type.display {
                radarLayers.append(watchBuffers1[$0]!)
            }
        }
        if PolygonType.LOCDOT.display || RadarPreferences.locdotFollowsGps {
            radarLayers.append(locdotBuffers)
        }
        if PolygonType.SPOTTER.display {
            radarLayers.append(spotterBuffers)
        }
        if RadarPreferences.locdotFollowsGps {
            radarLayers.append(locCircleBuffers)
        }
        if PolygonType.WIND_BARB.display {
            radarLayers.append(wbCircleBuffers)
            radarLayers.append(wbGustsBuffers)
            radarLayers.append(wbBuffers)
        }
        if PolygonType.SWO.display {
            radarLayers.append(swoBuffers)
        }
        if PolygonType.FIRE.display {
            radarLayers.append(fireBuffers)
        }
        radarLayers += [stiBuffers, hiBuffers, tvsBuffers]
    }
}
