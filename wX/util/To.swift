// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class To {

    static func string(_ i: Int) -> String {
        Swift.String(i)
    }

    static func string(_ i: UInt8) -> String {
        Swift.String(i)
    }

    static func stringFromD(_ d: Double) -> String {
        Swift.String(d)
    }

    static func int(_ s: String) -> Int {
        Swift.Int(s) ?? 0
    }

    static func double(_ s: String) -> Double {
        Swift.Double(s) ?? 0.0
    }

//    static func float(_ s: String) -> Float {
//        Swift.Float(s) ?? 0.0
//    }

    static func stringPadLeftZeros(_ i: Int, _ padAmount: Int) -> String {
        Swift.String(format: "%0" + String(padAmount) + "d", i)
    }

    static func stringPadLeftZeros(_ s: String, _ padAmount: Int) -> String {
        Swift.String(format: "%0" + String(padAmount) + "d", To.int(s))
    }
}
