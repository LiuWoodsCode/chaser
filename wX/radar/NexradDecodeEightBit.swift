// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class NexradDecodeEightBit {

    private static let k180DivPi = 180.0 / Double.pi

    static func andCreateRadials(_ radarBuffers: MetalRadarBuffers, _ fileStorage: FileStorage) -> Int {
        let disFirst = fileStorage.memoryBuffer
        disFirst.position = 0
        if disFirst.capacity == 0 {
            return 0
        }
        while disFirst.getShort() != -1 {}
        disFirst.skipBytes(100)
        let dis2 = UtilityIO.uncompress(disFirst)
        dis2.skipBytes(30)
        radarBuffers.putBackgroundColor()
        radarBuffers.setToPositionZero()
        var angleNext = 0.0
        var angle0 = 0.0
        var totalBins = 0
        let numberOfRadials = radarBuffers.numberOfRadials
        (0..<numberOfRadials).forEach { radial in
            let numberOfRleHalfWords = dis2.getUnsignedShort()
            let angle = 450.0 - Double(Int(dis2.getUnsignedShort())) / 10.0
            dis2.skipBytes(2)
            if radial < numberOfRadials - 1 {
                dis2.mark(dis2.position)
                dis2.skipBytes(Int(numberOfRleHalfWords) + 2)
                angleNext = 450.0 - (Double(Int(dis2.getUnsignedShort())) / 10.0)
                dis2.reset()
            }
            var level: UInt8 = 0
            var levelCount = 0
            var binStart = radarBuffers.binSize
            if radial == 0 {
                angle0 = angle
            }
            let angleV = radial < numberOfRadials - 1 ? angleNext : angle0
            let angleVCos = cos(angleV / k180DivPi)
            let angleVSin = sin(angleV / k180DivPi)
            let angleCos = cos(angle / k180DivPi)
            let angleSin = sin(angle / k180DivPi)
            (0..<numberOfRleHalfWords).forEach { bin in
                let curLevel = dis2.get()
                if bin == 0 {
                    level = curLevel
                }
                if curLevel == level {
                    levelCount += 1
                } else {
                    if radarBuffers.putRadialBin(
                        binStart,
                        binStart + radarBuffers.binSize * Double(levelCount),
                        angleVCos,
                        angleVSin,
                        angleCos,
                        angleSin,
                        level
                    ) {
                        totalBins += 1
                    }
                    level = curLevel
                    binStart = Double(bin) * radarBuffers.binSize
                    levelCount = 1
                }
            }
        }
        return totalBins
    }

    static func createRadials(_ radarBuffers: MetalRadarBuffers) -> Int {
        radarBuffers.putBackgroundColor()
        var totalBins = 0
        var binIndex = 0
        let radarBlackHole: Double
        let radarBlackHoleAdd: Double
        switch radarBuffers.levelData.productCode {
        case 56, 19, 181, 78, 80:
            radarBlackHole = 1.0
            radarBlackHoleAdd = 0.0
        default:
            radarBlackHole = 4.0
            radarBlackHoleAdd = 4.0
        }
        (0..<radarBuffers.levelData.numberOfRadials).forEach { g in
            // since radial_start is constructed natively as opposed to read in
            // from bigendian file we have to use getFloatNatve
            let angle = radarBuffers.levelData.radialStartAngle.getFloatNative(g * 4)
            var level = radarBuffers.levelData.binWord.get(binIndex)
            var levelCount = 0
            var binStart = radarBlackHole
            var angleV = 0.0
            if g < radarBuffers.levelData.numberOfRadials - 1 {
                angleV = radarBuffers.levelData.radialStartAngle.getFloatNative(g * 4 + 4)
            } else {
                angleV = radarBuffers.levelData.radialStartAngle.getFloatNative(0)
            }
            let angleVCos = cos(angleV / k180DivPi)
            let angleVSin = sin(angleV / k180DivPi)
            let angleCos = cos(angle / k180DivPi)
            let angleSin = sin(angle / k180DivPi)
            (0..<radarBuffers.levelData.numberOfRangeBins).forEach { bin in
                let curLevel = radarBuffers.levelData.binWord.get(binIndex)
                binIndex += 1
                if curLevel == level {
                    levelCount += 1
                } else {
                    if radarBuffers.putRadialBin(
                        binStart,
                        binStart + radarBuffers.levelData.binSize * Double(levelCount),
                        angleVCos,
                        angleVSin,
                        angleCos,
                        angleSin,
                        level
                    ) {
                        totalBins += 1
                    }
                    level = curLevel
                    binStart = Double(bin) * radarBuffers.levelData.binSize + radarBlackHoleAdd
                    levelCount = 1
                }
            }
        }
        return totalBins
    }
}
