// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import simd

class NexradRenderUtilities {

    private static let k180DivPi = 180.0 / Double.pi
    private static let piDiv4 = Double.pi / 4.0
    private static let piDiv360 = Double.pi / 360.0
    private static let twicePi = 2.0 * Double.pi

    static func modelMatrix() -> float4x4 {
        var matrix = float4x4()
        matrix.translate(0.0, y: 0.0, z: 0.0)
        matrix.rotateAroundX(0.0, y: 0.0, z: 0.0)
        matrix.scale(1.0, y: 1.0, z: 1.0)
        return matrix
    }

    static func genTriangle(_ buffers: MetalBuffers, _ pn: ProjectionNumbers) {
        var pointX = 0.0
        var pointY = 0.0
        var pixYD = 0.0
        var pixXD = 0.0
        var test1 = 0.0
        var test2 = 0.0
        let len = Double(buffers.lenInit)
        buffers.setToPositionZero()
        buffers.metalBuffer = []
        (0..<buffers.count).forEach {
            pointX = buffers.latList[$0]
            pointY = buffers.lonList[$0]
            test1 = k180DivPi * log(tan(piDiv4 + pointX * piDiv360))
            test2 = k180DivPi * log(tan(piDiv4 + pn.xDbl * piDiv360))
            pixYD = -1.0 * ((test1 - test2) * pn.oneDegreeScaleFactor) + pn.yCenterDouble
            pixXD = -1.0 * ((pointY - pn.yDbl) * pn.oneDegreeScaleFactor) + pn.xCenterDouble
            buffers.putFloat(pixXD)
            buffers.putFloat(-pixYD)
            buffers.putColors()
            buffers.putFloat(pixXD - len)
            buffers.putFloat(-pixYD + len)
            buffers.putColors()
            buffers.putFloat(pixXD + len)
            buffers.putFloat(-pixYD + len)
            buffers.putColors()
        }
    }

    static func genTriangleUp(_ buffers: MetalBuffers, _ pn: ProjectionNumbers) {
        var pointX = 0.0
        var pointY = 0.0
        var pixYD = 0.0
        var pixXD = 0.0
        var test1 = 0.0
        var test2 = 0.0
        buffers.setToPositionZero()
        buffers.metalBuffer = []
        let len = buffers.lenInit
        (0..<buffers.count).forEach {
            pointX = buffers.latList[$0]
            pointY = buffers.lonList[$0]
            test1 = k180DivPi * log(tan(piDiv4 + pointX * piDiv360))
            test2 = k180DivPi * log(tan(piDiv4 + pn.xDbl * piDiv360))
            pixYD = -1.0 * ((test1 - test2) * pn.oneDegreeScaleFactor) + pn.yCenterDouble
            pixXD = -1.0 * ((pointY - pn.yDbl) * pn.oneDegreeScaleFactor) + pn.xCenterDouble
            buffers.putFloat(pixXD)
            buffers.putFloat(-pixYD)
            buffers.putColors()
            buffers.putFloat(pixXD - len)
            buffers.putFloat(-pixYD - len)
            buffers.putColors()
            buffers.putFloat(pixXD + len)
            buffers.putFloat(-pixYD - len)
            buffers.putColors()
        }
    }

    static func genCircle(_ buffers: MetalBuffers, _ pn: ProjectionNumbers) {
        var pointX = 0.0
        var pointY = 0.0
        var pixYD = 0.0
        var pixXD = 0.0
        var test1 = 0.0
        var test2 = 0.0
        let lenLocal = buffers.lenInit * 0.50
        let triangleAmount = Double(buffers.triangleCount)
        buffers.setToPositionZero()
        buffers.metalBuffer = []
        (0..<buffers.count).forEach {
            pointX = buffers.latList[$0]
            pointY = buffers.lonList[$0]
            test1 = k180DivPi * log(tan(piDiv4 + pointX * piDiv360))
            test2 = k180DivPi * log(tan(piDiv4 + pn.xDbl * piDiv360))
            pixYD = -1.0 * ((test1 - test2) * pn.oneDegreeScaleFactor) + pn.yCenterDouble
            pixXD = -1.0 * ((pointY - pn.yDbl) * pn.oneDegreeScaleFactor) + pn.xCenterDouble
            (0..<buffers.triangleCount).forEach {
                buffers.putFloat(pixXD)
                buffers.putFloat(-pixYD)
                buffers.putColors()
                buffers.putFloat(pixXD + (lenLocal * cos(Double($0) * twicePi / triangleAmount)))
                buffers.putFloat(-pixYD + (lenLocal * sin(Double($0) * twicePi / triangleAmount)))
                buffers.putColors()
                buffers.putFloat(pixXD + (lenLocal * cos((Double($0) + 1) * twicePi / triangleAmount)))
                buffers.putFloat(-pixYD + (lenLocal * sin((Double($0) + 1) * twicePi / triangleAmount)))
                buffers.putColors()
            }
        }
    }

    static func genCircleWithColor(_ buffers: MetalBuffers, _ pn: ProjectionNumbers) {
        var pointX = 0.0
        var pointY = 0.0
        var pixYD = 0.0
        var pixXD = 0.0
        var test1 = 0.0
        var test2 = 0.0
        let lenLocal = buffers.lenInit * 0.50
        let triangleAmount = Double(buffers.triangleCount)
        buffers.setToPositionZero()
        buffers.metalBuffer = []
        (0..<buffers.count).forEach {
            if buffers.typeEnum == .WIND_BARB_CIRCLE {
                buffers.red = Color.red(Int(buffers.colorIntArray[$0]))
                buffers.green = Color.green(Int(buffers.colorIntArray[$0]))
                buffers.blue = Color.blue(Int(buffers.colorIntArray[$0]))
            }
            pointX = buffers.latList[$0]
            pointY = buffers.lonList[$0]
            test1 = k180DivPi * log(tan(piDiv4 + pointX * piDiv360))
            test2 = k180DivPi * log(tan(piDiv4 + pn.xDbl * piDiv360))
            pixYD = -1.0 * ((test1 - test2) * pn.oneDegreeScaleFactor) + pn.yCenterDouble
            pixXD = -1.0 * ((pointY - pn.yDbl) * pn.oneDegreeScaleFactor) + pn.xCenterDouble
            (0..<buffers.triangleCount).forEach {
                buffers.putFloat(pixXD)
                buffers.putFloat(-pixYD)
                buffers.putColors()
                buffers.putFloat(pixXD + (lenLocal * cos(Double($0) * twicePi / triangleAmount)))
                buffers.putFloat(-pixYD + (lenLocal * sin(Double($0) * twicePi / triangleAmount)))
                buffers.putColors()
                buffers.putFloat(pixXD + (lenLocal * cos((Double($0) + 1) * twicePi / triangleAmount)))
                buffers.putFloat(-pixYD + (lenLocal * sin((Double($0) + 1) * twicePi / triangleAmount)))
                buffers.putColors()
            }
        }
    }

    static func genCircleLocationDot(_ buffers: MetalBuffers, _ pn: ProjectionNumbers, _ location: LatLon) {
        buffers.setToPositionZero()
        buffers.count = buffers.triangleCount * 4
        let lenLocal = buffers.lenInit * 2.0
        let triangleAmount = Double(buffers.triangleCount)
        buffers.metalBuffer = []
        let test1 = k180DivPi * log(tan(piDiv4 + location.lat * piDiv360))
        let test2 = k180DivPi * log(tan(piDiv4 + pn.xDbl * piDiv360))
        let pixYD = -1.0 * ((test1 - test2) * pn.oneDegreeScaleFactor) + pn.yCenterDouble
        let pixXD = -1.0 * ((location.lon - pn.yDbl) * pn.oneDegreeScaleFactor) + pn.xCenterDouble
        (0..<buffers.triangleCount).forEach {
            buffers.putFloat(pixXD + (lenLocal * cos(Double($0) * twicePi / triangleAmount)))
            buffers.putFloat(-1.0 * pixYD + (lenLocal * sin(Double($0) * twicePi / triangleAmount)))
            buffers.putColors()
            buffers.putFloat(pixXD + (lenLocal * cos((Double($0) + 1) * twicePi / triangleAmount)))
            buffers.putFloat(-1.0 * pixYD + (lenLocal * sin((Double($0) + 1) * twicePi / triangleAmount)))
            buffers.putColors()
        }
    }
}
