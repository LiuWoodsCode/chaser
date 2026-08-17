// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation
import Metal

final class NexradLevelData {

    var radialStartAngle = MemoryBuffer()
    var binSize = 0.0
    var numberOfRangeBins = 916
    var numberOfRadials = 360
    var binWord = MemoryBuffer()
    var productCode: Int16 = 0
    private var radarType: RadarType = .level3
    private var days = MemoryBuffer(2)
    private var msecs = MemoryBuffer(4)
    private var halfWord3132: Float = 0.0
    private var seekStart: CLong = 0
    var radarBuffers: MetalRadarBuffers?
    var indexString = "0"
    var radarHeight = 0
    var degree = 0.0
    var operationalMode: Int16 = 0
    var volumeCoveragePattern: Int16 = 0
    private var latitudeOfRadar = 0.0
    private var longitudeOfRadar = 0.0
    private var sequenceNumber: UInt16 = 0
    private var volumeScanNumber: UInt16 = 0
    private var elevationNumber: UInt16 = 0
    private var fileStorage = FileStorage()
    private var isAnimating = false
    private var animationIndex = 0
    var radarInfo = ""
    var radarAgeMilli: Int64 = 0

    convenience init(_ product: String, _ radarBuffers: MetalRadarBuffers, _ indexString: String, _ fileStorage: FileStorage, _ isAnimating: Bool, _ animationIndex: Int) {
        self.init()
        self.radarBuffers = radarBuffers
        self.indexString = indexString
        self.fileStorage = fileStorage
        self.isAnimating = isAnimating
        self.animationIndex = animationIndex
        productCode = GlobalDictionaries.radarProductStringToShortInt[product] ?? 0
        switch productCode {
        case 153, 154:
            radarType = .level2
        case 30, 37, 38, 56, 78, 80, 181:
            radarType = .level3bit4
        default:
            radarType = .level3
        }
    }

    func decode() {
        switch productCode {
        case 153, 154:
            decodeAndPlotNexradL2()
        case 30, 37, 38, 41, 56, 57, 78, 80, 181:
            decodeAndPlotNexradLevel3FourBit()
        default:
            decodeAndPlotNexradLevel3()
        }
    }

    private func decodeAndPlotNexradLevel3() {
        let dis = fileStorage.memoryBuffer
        dis.position = 0
        if dis.capacity > 0 {
            while dis.getShort() != -1 {}
            latitudeOfRadar = Double(dis.getInt()) / 1000.0
            longitudeOfRadar = Double(dis.getInt()) / 1000.0
            radarHeight = Int(dis.getUnsignedShort())
            productCode = Int16(dis.getUnsignedShort())
            operationalMode = Int16(dis.getUnsignedShort())
            volumeCoveragePattern = Int16(dis.getUnsignedShort())
            sequenceNumber = dis.getUnsignedShort()
            volumeScanNumber = dis.getUnsignedShort()
            let volumeScanDate = Int16(dis.getUnsignedShort())
            let volumeScanTime = dis.getInt()
            writeTime(volumeScanDate, volumeScanTime)
            dis.skipBytes(10)
            elevationNumber = dis.getUnsignedShort()
            let elevationAngle = dis.getShort()
            degree = Double(elevationAngle) / 10.0
            halfWord3132 = dis.getFloat()
            NexradUtil.wxoglDspLegendMax = (255.0 / Double(halfWord3132)) * 0.01
            dis.skipBytes(26)
            dis.skipBytes(30)
            seekStart = dis.filePointer
            binSize = NexradUtil.getBinSize(productCode)
            numberOfRangeBins = Int(NexradUtil.getNumberRangeBins(Int(productCode)))
//            if originalProductCode == 2153 || originalProductCode == 2154 {
//                numberOfRadials = 720
//            }
            radarBuffers!.numberOfRangeBins = numberOfRangeBins
            radarBuffers!.numberOfRadials = numberOfRadials
            radarBuffers!.binSize = binSize
        }
    }

    private func decodeAndPlotNexradLevel3FourBit() {
        switch productCode {
        case 181:
            binWord = MemoryBuffer(360 * 720)
        case 78, 80:
            binWord = MemoryBuffer(360 * 592)
        case 37, 38:
            binWord = MemoryBuffer(464 * 464)
        default:
            binWord = MemoryBuffer(360 * 230)
        }
        radialStartAngle = MemoryBuffer(4 * 360)
        let dis = fileStorage.memoryBuffer
        dis.position = 0
        if dis.capacity > 0 {
            dis.skipBytes(30)
            dis.skipBytes(20)
            dis.skipBytes(8)
            radarHeight = Int(dis.getUnsignedShort())
            productCode = Int16( dis.getUnsignedShort())
            operationalMode = Int16( dis.getUnsignedShort())
            volumeCoveragePattern = Int16(dis.getUnsignedShort())
            sequenceNumber = dis.getUnsignedShort()
            volumeScanNumber = dis.getUnsignedShort()
            let volumeScanDate = Int16(dis.getUnsignedShort())
            let volumeScanTime = dis.getInt()
            writeTime(volumeScanDate, volumeScanTime)
            dis.skipBytes(6)
            dis.skipBytes(56)
            dis.skipBytes(32)
            switch productCode {
            case 37, 38, 41, 57:
                numberOfRangeBins = Int(NexradDecodeFourBit.raster(radarBuffers!, fileStorage))
            default:
                numberOfRangeBins = Int(NexradDecodeFourBit.radial(radarBuffers!, fileStorage))
            }
            binSize = NexradUtil.getBinSize(productCode)
            numberOfRadials = 360
        } else {
            numberOfRangeBins = 230
            numberOfRadials = 360
        }
    }

    private func decodeAndPlotNexradL2() {
        radialStartAngle = MemoryBuffer(720 * 4)
        binWord = MemoryBuffer(720 * numberOfRangeBins)
        if !isAnimating {
            NexradLevel2Util.decompress(radarBuffers!, fileStorage)
        } else {
            fileStorage.memoryBuffer = fileStorage.animationMemoryBuffer[animationIndex]
        }
        Level2.decode(radarBuffers!, fileStorage, days, msecs)
        writeTimeL2()
        binSize = NexradUtil.getBinSize(productCode)
        binWord.position = 0
        numberOfRadials = radialStartAngle.capacity / 4
    }

    private func writeTimeL2() {
        msecs.position = 0
        days.position = 0
        let days2: Int16 = days.getShortNative()
        let msecs2: Int = msecs.getInt()
        let sec: CLong = (CLong(days2 - 1)) * 24 * 60 * 60 + msecs2 / 1000
        let dateString = ObjectDateTime.radarTimeL2(days2, msecs2)
        let radarInfoFinal = "\(dateString)\(GlobalVariables.newline)Product: \(productCode)"
        radarInfo = radarInfoFinal
        radarAgeMilli = Int64(ObjectDateTime.currentTimeMillis() - sec * 1000)
    }

    private func writeTime(_ volumeScanDate: Int16, _ volumeScanTime: Int) {
        let radarInfoTemp = "Mode: \(operationalMode), VCP: \(volumeCoveragePattern), Product: \(productCode), Height: \(radarHeight)"
        let sec = CLong((Int(volumeScanDate) - 1) * 60 * 60 * 24) + Int(volumeScanTime)
        let dateString = ObjectDateTime.radarTime(volumeScanDate, volumeScanTime)
        let radarInfoFinal = dateString + GlobalVariables.newline + radarInfoTemp
        radarInfo = radarInfoFinal
        radarAgeMilli = Int64(ObjectDateTime.currentTimeMillis() - sec * 1000)
    }

    func decodeAndGenerateRadials(_ device: MTLDevice) -> Int {
        radarBuffers!.levelData.decode()
        radarBuffers!.initialize()
        let totalBins = radarBuffers!.generateRadials()
        radarBuffers!.setToPositionZero()
        radarBuffers!.setCount()
        radarBuffers!.generateMtlBuffer(device)
        return totalBins
    }
}
