// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Metal

final class NexradRenderRadar {

    static func downloadRadar(_ url: String, _ data: NexradRenderData, _ state: NexradRenderState, _ fileStorage: FileStorage) {
        if url == "" {
            NexradDownload.getRadarFile(url, state.radarSite, state.product, state.isTdwr, fileStorage)
        } else {
            // url will contain "nexrad_anim" with old method
            if url.contains("nexrad_anim") {
                state.isAnimating = true
                data.radarBuffers.fileName = url
            } else {
                state.isAnimating = true
                state.animationIndex = To.int(url)
                fileStorage.memoryBuffer = fileStorage.animationMemoryBuffer[state.animationIndex]
            }
        }
    }

    static func constructPolygons(_ data: NexradRenderData, _ state: NexradRenderState, _ fileStorage: FileStorage, _ device: MTLDevice) -> Int {
        data.radarBuffers.metalBuffer = []
        // TODO redo this to match wxqt, don't want radarBuffers in NexradLevelData
        data.radarBuffers.levelData = NexradLevelData(
            state.product,
            data.radarBuffers,
            state.indexString,
            fileStorage,
            state.isAnimating,
            state.animationIndex)
        return data.radarBuffers.levelData.decodeAndGenerateRadials(device)
//        data.radarBuffers.levelData.decode()
//        data.radarBuffers.initialize()
//        let totalBins = data.radarBuffers.generateRadials()
//        data.radarBuffers.setToPositionZero()
//        data.radarBuffers.setCount()
//        data.radarBuffers.generateMtlBuffer(device)
//        return totalBins
    }
}
