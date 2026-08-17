// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class MetalRadarBuffers: MetalBuffers {

    var bgColor = 0
    let useMapKitBaseLayer: Bool
    var fileName = "nids"
    var levelData = NexradLevelData()
    var fileStorage = FileStorage()
    var numberOfRadials = 0
    var numberOfRangeBins = 0
    var binSize = 0.0

    init(_ bgColor: Int, useMapKitBaseLayer: Bool = false) {
        self.bgColor = bgColor
        self.useMapKitBaseLayer = useMapKitBaseLayer
    }

    var colorMap: ColorPalette { ColorPalette.colorMap[Int(levelData.productCode)]! }

    func initialize() {
        if !RadarPreferences.showRadarWhenPan {
            honorDisplayHold = true
        }
        if levelData.productCode == 37 || levelData.productCode == 38 || levelData.productCode == 41 || levelData.productCode == 57 {
            if floatBuffer.capacity < (48 * 464 * 464) {
                floatBuffer = MemoryBuffer(48 * 464 * 464)
            }
        } else {
            if floatBuffer.capacity < (32 * levelData.numberOfRadials * levelData.numberOfRangeBins) {
                floatBuffer = MemoryBuffer(32 * levelData.numberOfRadials * levelData.numberOfRangeBins)
            }
        }
        setToPositionZero()
    }

    func putColorsByIndex(_ level: UInt8) {
        putColor(colorMap.redValues.get(Int(level)))
        putColor(colorMap.greenValues.get(Int(level)))
        putColor(colorMap.blueValues.get(Int(level)))
    }

    func shouldDrawLevel(_ level: UInt8) -> Bool {
        !useMapKitBaseLayer || level != 0
    }

    func putRadialBin(
        _ binStart: Double,
        _ binEnd: Double,
        _ angleVCos: Double,
        _ angleVSin: Double,
        _ angleCos: Double,
        _ angleSin: Double,
        _ level: UInt8
    ) -> Bool {
        guard shouldDrawLevel(level) else { return false }
        putFloat(binStart * angleVCos)
        putFloat(binStart * angleVSin)
        putColorsByIndex(level)
        putFloat(binEnd * angleVCos)
        putFloat(binEnd * angleVSin)
        putColorsByIndex(level)
        putFloat(binEnd * angleCos)
        putFloat(binEnd * angleSin)
        putColorsByIndex(level)
        putFloat(binStart * angleVCos)
        putFloat(binStart * angleVSin)
        putColorsByIndex(level)
        putFloat(binEnd * angleCos)
        putFloat(binEnd * angleSin)
        putColorsByIndex(level)
        putFloat(binStart * angleCos)
        putFloat(binStart * angleSin)
        putColorsByIndex(level)
        return true
    }

    func generateRadials() -> Int {
        let totalBins: Int
        switch levelData.productCode {
        case 37, 38:
            totalBins = NexradRaster.create(self)
        case 153, 154, 30, 56, 78, 80, 181:
            totalBins = NexradDecodeEightBit.createRadials(self)
        case 0:
            totalBins = 0
        default:
            totalBins = NexradDecodeEightBit.andCreateRadials(self, fileStorage)
        }
        return totalBins
    }

    func setCount() {
        count = (metalBuffer.count / floatCountPerVertex) * 2
    }

    func putBackgroundColor() {
        colorMap.redValues.put(0, Color.red(bgColor))
        colorMap.greenValues.put(0, Color.green(bgColor))
        colorMap.blueValues.put(0, Color.blue(bgColor))
    }
}
