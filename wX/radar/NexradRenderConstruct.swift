// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Metal

class NexradRenderConstruct {

    let device: MTLDevice
    let fileStorage: FileStorage
    let state: NexradRenderState
    var scaleLengthLocationDot: ((Double) -> Double)?

    init(_ device: MTLDevice, _ fileStorage: FileStorage, _ state: NexradRenderState) {
        self.device = device
        self.fileStorage = fileStorage
        self.state = state
    }

    func genericGeographic(_ buffers: MetalBuffers) {
        buffers.setCount(buffers.geoType.count)
        buffers.initialize(4 * buffers.count, buffers.geoType.color)
        let colors = buffers.getColorArrayInFloat()
        JNI_GenMercato(
            MemoryBuffer.getPointer(buffers.geoType.relativeBuffer.array),
            MemoryBuffer.getPointer(buffers.floatBuffer.array),
            state.projectionNumbers.xFloat,
            state.projectionNumbers.yFloat,
            state.projectionNumbers.xCenterFloat,
            state.projectionNumbers.yCenterFloat,
            state.projectionNumbers.oneDegreeScaleFactorFloat,
            Int32(buffers.count)
        )
        buffers.setToPositionZero()
        var i = 0
        (0..<(buffers.count / 2)).forEach { _ in
            buffers.metalBuffer[i] = buffers.floatBuffer.getCGFloatNative()
            buffers.metalBuffer[i + 1] = buffers.floatBuffer.getCGFloatNative()
            buffers.metalBuffer[i + 2] = colors[0]
            buffers.metalBuffer[i + 3] = colors[1]
            buffers.metalBuffer[i + 4] = colors[2]
            i += 5
        }
    }

    func genericLines(_ buffers: MetalBuffers) {
        var list: [Double]
        switch buffers.typeEnum {
        case .SPCMCD, .WPCMPD, .SPCWAT, .SPCWAT_TORNADO:
            list = Watch.add(state.projectionNumbers, buffers.typeEnum)
        case .TST, .TOR, .FFW:
            list = Warnings.add(state.projectionNumbers, buffers.typeEnum)
        case .SMW:
            list = Warnings.addGeneric(state.projectionNumbers, PolygonWarning.byType[PolygonTypeGeneric.SMW]!)
        case .SQW:
            list = Warnings.addGeneric(state.projectionNumbers, PolygonWarning.byType[PolygonTypeGeneric.SQW]!)
        case .DSW:
            list = Warnings.addGeneric(state.projectionNumbers, PolygonWarning.byType[PolygonTypeGeneric.DSW]!)
        case .SPS:
            list = Warnings.addGeneric(state.projectionNumbers, PolygonWarning.byType[PolygonTypeGeneric.SPS]!)
        case .STI:
            NexradLevel3StormInfo.decode(state.projectionNumbers, fileStorage)
            list = fileStorage.stiList
        default:
            list = [Double]()
        }
        buffers.initialize(2, buffers.type.color)
        let colors = buffers.getColorArrayInFloat()
        buffers.metalBuffer = []
        stride(from: 0, to: list.count, by: 4).forEach { vList in
            buffers.putFloat(list[vList])
            buffers.putFloat(list[vList + 1] * -1)
            buffers.putFloat(colors[0])
            buffers.putFloat(colors[1])
            buffers.putFloat(colors[2])
            buffers.putFloat(list[vList + 2])
            buffers.putFloat(list[vList + 3] * -1)
            buffers.putFloat(colors[0])
            buffers.putFloat(colors[1])
            buffers.putFloat(colors[2])
        }
        buffers.count = list.count
    }

    func triangles(_ buffers: MetalBuffers) {
        buffers.setCount(buffers.latList.count)
        switch buffers.typeEnum {
        case .LOCDOT:
            buffers.initialize(24 * buffers.count * buffers.triangleCount, buffers.type.color)
        case .SPOTTER:
            buffers.initialize(24 * buffers.count * buffers.triangleCount, buffers.type.color)
        default:
            buffers.initialize(4 * 6 * buffers.count, buffers.type.color)
        }
        buffers.lenInit = scaleLengthLocationDot!(buffers.lenInit)
        buffers.draw(state.projectionNumbers)
    }

    func genericLinesShort(_ buffers: MetalBuffers, _ list: [Double]) {
        buffers.initialize(2, buffers.type.color)
        let colors = buffers.getColorArrayInFloat()
        buffers.metalBuffer = []
        stride(from: 0, to: list.count, by: 4).forEach { vList in
            buffers.putFloat(list[vList])
            buffers.putFloat(list[vList + 1] * -1)
            buffers.putFloat(colors[0])
            buffers.putFloat(colors[1])
            buffers.putFloat(colors[2])
            buffers.putFloat(list[vList + 2])
            buffers.putFloat(list[vList + 3] * -1)
            buffers.putFloat(colors[0])
            buffers.putFloat(colors[1])
            buffers.putFloat(colors[2])
        }
        buffers.count = list.count
    }

    func alertPolygonsByType(_ type: PolygonTypeGeneric, _ data: NexradRenderData) {
        if data.warningBuffers[type]!.type.display {
            genericLines(data.warningBuffers[type]!)
            data.warningBuffers[type]!.generateMtlBuffer(device)
        }
    }

    func alertPolygons(_ data: NexradRenderData, _ renderFn: ((Int) -> Void)?) {
        [
            PolygonTypeGeneric.TST,
            PolygonTypeGeneric.TOR,
            PolygonTypeGeneric.FFW,
            PolygonTypeGeneric.SMW,
            PolygonTypeGeneric.SQW,
            PolygonTypeGeneric.DSW,
            PolygonTypeGeneric.SPS].forEach {
                if data.warningBuffers[$0]!.type.display {
                    genericLines(data.warningBuffers[$0]!)
                    data.warningBuffers[$0]!.generateMtlBuffer(device)
                }
        }
        if renderFn != nil {
            renderFn!(state.paneNumber)
        }
    }

    func watchPolygonsByType(_ type: PolygonEnum, _ data: NexradRenderData, _ renderFn: ((Int) -> Void)?) {
        if data.watchBuffers1[type]!.type.display {
            genericLines(data.watchBuffers1[type]!)
            data.watchBuffers1[type]!.generateMtlBuffer(device)
        }
        if type == PolygonEnum.SPCWAT {
            if data.watchBuffers1[type]!.type.display {
                genericLines(data.watchBuffers1[PolygonEnum.SPCWAT_TORNADO]!)
                data.watchBuffers1[PolygonEnum.SPCWAT_TORNADO]!.generateMtlBuffer(device)
            }
        }
        if renderFn != nil {
            renderFn!(state.paneNumber)
        }
    }

    func wBLines(_ wbBuffers: MetalBuffers, _ wbGustsBuffers: MetalBuffers, _ wbCircleBuffers: MetalBuffers) {
        genericLinesShort(wbBuffers, NexradLevel3WindBarbs.decode(state.projectionNumbers, isGust: false, fileStorage))
        wBLinesGusts(wbGustsBuffers)
        wBCircle(wbCircleBuffers)
        wbBuffers.generateMtlBuffer(device)
    }

    func wBLinesGusts(_ wbGustsBuffers: MetalBuffers) {
        genericLinesShort(wbGustsBuffers, NexradLevel3WindBarbs.decode(state.projectionNumbers, isGust: true, fileStorage))
        wbGustsBuffers.generateMtlBuffer(device)
    }

    func wBCircle(_ wbCircleBuffers: MetalBuffers) {
        wbCircleBuffers.lenInit = PolygonType.WIND_BARB.size
        wbCircleBuffers.latList = fileStorage.obsArrX
        wbCircleBuffers.lonList = fileStorage.obsArrY
        wbCircleBuffers.colorIntArray = fileStorage.obsArrAviationColor
        wbCircleBuffers.setCount(wbCircleBuffers.latList.count)
        wbCircleBuffers.triangleCount = 6
        wbCircleBuffers.initialize(24 * wbCircleBuffers.count * wbCircleBuffers.triangleCount)
        wbCircleBuffers.lenInit = scaleLengthLocationDot!(wbCircleBuffers.lenInit)
        MetalBuffers.redrawCircleWithColor(wbCircleBuffers, state.projectionNumbers)
        wbCircleBuffers.generateMtlBuffer(device)
    }

    func genericTriangle(_ buffers: MetalBuffers, _ type: PolygonEnum) {
        buffers.lenInit = buffers.type.size
        buffers.triangleCount = 1
        buffers.metalBuffer = []
        buffers.vertexCount = 0
        switch type {
        case .HI:
            NexradLevel3HailIndex.decode(state.projectionNumbers, fileStorage)
            buffers.setXYList(fileStorage.hiData)
        case .TVS:
            NexradLevel3TVS.decode(state.projectionNumbers, fileStorage)
            buffers.setXYList(fileStorage.tvsData)
        default:
            break
        }
        triangles(buffers)
        buffers.generateMtlBuffer(device)
    }

    func swoLines(_ swoBuffers: MetalBuffers, _ projectionNumbers: ProjectionNumbers) {
        swoBuffers.initialize(2, Color.MAGENTA)
        var fSize = 0
        for (_, v) in SwoDayOne.polygonBy {
            fSize += v.count
        }
        swoBuffers.metalBuffer = []
        for (k, v) in SwoDayOne.polygonBy {
            let flArr = v
            let color = SwoDayOne.colors[k]!
            stride(from: 0, to: flArr.count - 1, by: 4).forEach { j in
                var tmpCoords = Projection.computeMercatorNumbers(Double(flArr[j]), Double(flArr[j + 1]) * -1.0, projectionNumbers)
                swoBuffers.putFloat(tmpCoords[0])
                swoBuffers.putFloat(tmpCoords[1] * -1.0)
                swoBuffers.putColor3(color)
                tmpCoords = Projection.computeMercatorNumbers(Double(flArr[j + 2]), Double(flArr[j + 3]) * -1.0, projectionNumbers)
                swoBuffers.putFloat(tmpCoords[0])
                swoBuffers.putFloat(tmpCoords[1] * -1.0)
                swoBuffers.putColor3(color)
            }
        }
        swoBuffers.count = Int(Double(swoBuffers.metalBuffer.count) * 0.4)
        swoBuffers.generateMtlBuffer(device)
    }

    func fireLines(_ fireBuffers: MetalBuffers, _ projectionNumbers: ProjectionNumbers) {
        fireBuffers.initialize(2, Color.MAGENTA)
        var fSize = 0
        for (_, v) in FireDayOne.polygonBy {
            fSize += v.count
        }
        fireBuffers.metalBuffer = []
        for (k, v) in FireDayOne.polygonBy {
            let flArr = v
            let color = FireDayOne.colors[k]!
            stride(from: 0, to: flArr.count - 1, by: 4).forEach { j in
                var tmpCoords = Projection.computeMercatorNumbers(Double(flArr[j]), Double(flArr[j + 1]) * -1.0, projectionNumbers)
                fireBuffers.putFloat(tmpCoords[0])
                fireBuffers.putFloat(tmpCoords[1] * -1.0)
                fireBuffers.putColor3(color)
                tmpCoords = Projection.computeMercatorNumbers(Double(flArr[j + 2]), Double(flArr[j + 3]) * -1.0, projectionNumbers)
                fireBuffers.putFloat(tmpCoords[0])
                fireBuffers.putFloat(tmpCoords[1] * -1.0)
                fireBuffers.putColor3(color)
            }
        }
        fireBuffers.count = Int(Double(fireBuffers.metalBuffer.count) * 0.4)
        fireBuffers.generateMtlBuffer(device)
    }

    func wpcFronts(_ wpcFrontBuffersList: inout [MetalBuffers], _ wpcFrontPaints: inout [Int]) {
        wpcFrontBuffersList.removeAll()
        wpcFrontPaints.removeAll()
        WpcFronts.fronts.forEach { _ in
            let buff = MetalBuffers()
            buff.initialize(2, Color.MAGENTA)
            wpcFrontBuffersList.append(buff)
        }
        WpcFronts.fronts.indices.forEach { z in
            let front = WpcFronts.fronts[z]
            switch front.type {
            case FrontTypeEnum.COLD:
                wpcFrontPaints.append(Color.rgb(0, 127, 255))
            case FrontTypeEnum.WARM:
                wpcFrontPaints.append(Color.rgb(255, 0, 0))
            case FrontTypeEnum.STNRY:
                wpcFrontPaints.append(Color.rgb(0, 127, 255))
            case FrontTypeEnum.STNRY_WARM:
                wpcFrontPaints.append(Color.rgb(255, 0, 0))
            case FrontTypeEnum.OCFNT:
                wpcFrontPaints.append(Color.rgb(255, 0, 255))
            case FrontTypeEnum.TROF:
                wpcFrontPaints.append(Color.rgb(254, 216, 177))
            }
            for j in stride(from: 0, to: front.coordinates.count - 1, by: 2) {
                var tmpCoords = Projection.computeMercatorNumbers(front.coordinates[j].lat, front.coordinates[j].lon, state.projectionNumbers)
                wpcFrontBuffersList[z].putFloat(tmpCoords[0])
                wpcFrontBuffersList[z].putFloat(tmpCoords[1] * -1.0)
                wpcFrontBuffersList[z].putColor3(wpcFrontPaints[z])
                tmpCoords = Projection.computeMercatorNumbers(front.coordinates[j + 1].lat, front.coordinates[j + 1].lon, state.projectionNumbers)
                wpcFrontBuffersList[z].putFloat(tmpCoords[0])
                wpcFrontBuffersList[z].putFloat(tmpCoords[1] * -1.0)
                wpcFrontBuffersList[z].putColor3(wpcFrontPaints[z])
            }
            wpcFrontBuffersList[z].count = Int(Double(wpcFrontBuffersList[z].metalBuffer.count) * 0.4)
            wpcFrontBuffersList[z].generateMtlBuffer(device)
        }
    }

    func spotters(_ spotterBuffers: MetalBuffers) {
        spotterBuffers.lenInit = PolygonType.SPOTTER.size
        spotterBuffers.triangleCount = 6
        _ = UtilitySpotter.get()
        spotterBuffers.latList = UtilitySpotter.lat
        spotterBuffers.lonList = UtilitySpotter.lon
        triangles(spotterBuffers)
        spotterBuffers.lenInit = scaleLengthLocationDot!(spotterBuffers.type.size)
        spotterBuffers.draw(state.projectionNumbers)
        spotterBuffers.generateMtlBuffer(device)
    }

    func stiLines(_ stiBuffers: MetalBuffers) {
        NexradLevel3StormInfo.decode(state.projectionNumbers, fileStorage)
        genericLinesShort(stiBuffers, fileStorage.stiList)
        stiBuffers.generateMtlBuffer(device)
    }

    func level3TextProduct(_ type: PolygonEnum, _ data: NexradRenderData) {
        switch type {
        case .HI:
            genericTriangle(data.hiBuffers, type)
        case .TVS:
            genericTriangle(data.tvsBuffers, type)
        case .STI:
            stiLines(data.stiBuffers)
        default:
            break
        }
    }

    func locationDot(_ locdotBuffers: MetalBuffers, _ locCircleBuffers: MetalBuffers, _ setZoom: () -> Void) {
        var locationMarkers = [Double]()
        locdotBuffers.lenInit = PolygonType.LOCDOT.size
        if PolygonType.LOCDOT.display {
            locationMarkers = UtilityLocation.latLonAsDouble()
        }
        if RadarPreferences.locdotFollowsGps {
            locationMarkers.append(state.gpsLocation.lat)
            locationMarkers.append(state.gpsLocation.lon)
        }
        // get even and odd values and put in separate lists
        locdotBuffers.latList = locationMarkers.enumerated().filter { index, _ in index & 1 == 0 }.map { _, value in Double(value) }
        locdotBuffers.lonList = locationMarkers.enumerated().filter { index, _ in index & 1 != 0 }.map { _, value in Double(value) }
        locdotBuffers.triangleCount = 24
        locdotBuffers.count = locationMarkers.count
        locdotBuffers.lenInit = scaleLengthLocationDot!(locdotBuffers.type.size)
        triangles(locdotBuffers)
        locCircleBuffers.triangleCount = 24
        locCircleBuffers.initialize(32 * locCircleBuffers.triangleCount, PolygonType.LOCDOT.color)
        if RadarPreferences.locdotFollowsGps {
            let gpsCoords = Projection.computeMercatorNumbers(state.gpsLocation.lat, state.gpsLocation.lon, state.projectionNumbers)
            state.gpsLatLonTransformed = (Float(-1.0 * gpsCoords[0]), Float(gpsCoords[1]))
            locCircleBuffers.lenInit = locdotBuffers.lenInit
            NexradRenderUtilities.genCircleLocationDot(locCircleBuffers, state.projectionNumbers, state.gpsLocation)
            locCircleBuffers.generateMtlBuffer(device)
        }
        locdotBuffers.generateMtlBuffer(device)
        locCircleBuffers.generateMtlBuffer(device)
        setZoom()
    }
}
