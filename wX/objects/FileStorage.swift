// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class FileStorage {

    var memoryBuffer = MemoryBuffer()
    var memoryBufferL2 = MemoryBuffer()
    var animationMemoryBuffer = [MemoryBuffer]()
    var animationMemoryBufferL2 = [MemoryBuffer]()
    var stiList = [Double]()
    var hiData = [Double]()
    var tvsData = [Double]()
    // wind barbs
    var obsArr = [String]()
    var obsArrExt = [String]()
    var obsArrWb = [String]()
    var obsArrWbGust = [String]()
    var obsArrX = [Double]()
    var obsArrY = [Double]()
    var obsArrAviationColor = [Int]()
    var obsOldRadarSite = ""
    var obsDownloadTimer = DownloadTimer("OBS_AND_WIND_BARBS" + String(ObjectDateTime.currentTimeMillis()))
}
