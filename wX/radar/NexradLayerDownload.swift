// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class NexradLayerDownload {

    private let semaphore = DispatchSemaphore(value: 1)
    let nexradState: NexradState
    let nexradSubmenu: NexradSubmenu

    init(_ nexradState: NexradState, _ nexradSubmenu: NexradSubmenu) {
        self.nexradState = nexradState
        self.nexradSubmenu = nexradSubmenu
    }

    func updatePolygonWarningsGeneric() {
        semaphore.wait()
        if nexradState.wxMetalRenders[0] != nil {
            nexradState.wxMetalRenders.forEach {
                $0!.construct.alertPolygons($0!.data, $0!.renderFn)
            }
        }
        nexradSubmenu.updateWarningsInToolbar()
        semaphore.signal()
    }

    func updatePolygonWarningsNonGeneric(_ type: PolygonTypeGeneric) {
        semaphore.wait()
        if nexradState.wxMetalRenders[0] != nil {
            nexradState.wxMetalRenders.forEach {
                $0!.construct.alertPolygonsByType(type, $0!.data)
            }
        }
        nexradSubmenu.updateWarningsInToolbar()
        semaphore.signal()
    }

    // warnings fall under generic vs non-generic
    // non-generic is tied to settings -> radar -> warnings (ie PolygonType.TST.display)
    // it would be nice to treat them all the same and consolidate to a common method
    func getPolygonWarnings() {
        nexradSubmenu.updateWarningsInToolbar()
        getPolygonWatchGeneric()
        getPolygonWarningsNonGeneric()
        if PolygonWarning.areAnyEnabled() {
            _ = FutureVoid(getPolygonWarningsGeneric, updatePolygonWarningsGeneric)
        }
    }

    private func getPolygonWarningsGeneric() {
        if nexradState.wxMetalRenders[0] != nil {
            nexradState.wxMetalRenders.forEach {
                $0!.construct.alertPolygons($0!.data, $0!.renderFn)
            }
        }
        for t in [PolygonTypeGeneric.SMW, PolygonTypeGeneric.SQW, PolygonTypeGeneric.DSW, PolygonTypeGeneric.SPS] {
            if PolygonWarning.byType[t]!.isEnabled {
                PolygonWarning.byType[t]!.download()
            }
        }
    }

    func getPolygonWarningsNonGeneric() {
        if PolygonType.TST.display {
            for t in [PolygonTypeGeneric.TOR, PolygonTypeGeneric.TST, PolygonTypeGeneric.FFW] {
                updatePolygonWarningsNonGeneric(t)
            }
            for t in [PolygonTypeGeneric.TOR, PolygonTypeGeneric.TST, PolygonTypeGeneric.FFW] {
                _ = FutureVoid(PolygonWarning.byType[t]!.download) { self.updatePolygonWarningsNonGeneric(t) }
            }
        }
    }

    func getPolygonWatchGeneric() {
        for t in [PolygonEnum.SPCMCD, PolygonEnum.SPCWAT, PolygonEnum.WPCMPD] {
            updatePolygonWatchGeneric(t)
        }
        if PolygonType.MCD.display {
            _ = FutureVoid(PolygonWatch.byType[PolygonEnum.SPCMCD]!.download) { self.updatePolygonWatchGeneric(PolygonEnum.SPCMCD) }
        }
        if PolygonType.WATCH.display {
            _ = FutureVoid(PolygonWatch.byType[PolygonEnum.SPCWAT]!.download) { self.updatePolygonWatchGeneric(PolygonEnum.SPCWAT) }
        }
        if PolygonType.MPD.display {
            _ = FutureVoid(PolygonWatch.byType[PolygonEnum.WPCMPD]!.download) { self.updatePolygonWatchGeneric(PolygonEnum.WPCMPD) }
        }
    }

    func updatePolygonWatchGeneric(_ type: PolygonEnum) {
        semaphore.wait()
        if nexradState.wxMetalRenders[0] != nil {
            nexradState.wxMetalRenders.forEach {
                $0!.construct.watchPolygonsByType(type, $0!.data, $0!.renderFn)
            }
        }
        nexradSubmenu.updateWarningsInToolbar()
        semaphore.signal()
    }
}
