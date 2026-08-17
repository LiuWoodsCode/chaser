// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit
import Metal
import simd

final class NexradTab {

    var uiv: VcTabLocation!
    private var longPressCount = 0
    let nexradStateHS = NexradStateHS()
    private var nexradTabLongPressMenu: NexradTabLongPressMenu!

    func getNexradRadar(_ stackView: UIStackView) {
        nexradStateHS.setupMetal()
        nexradStateHS.setupMetalLayer(stackView)
        nexradTabLongPressMenu = NexradTabLongPressMenu(uiv, nexradStateHS, radarSiteChanged)
        setupGestures()
        nexradStateHS.getRadar(render)
        getPolygonWarnings()
    }

    func getPolygonWarnings() {
        getPolygonWatchGeneric()
        getPolygonWarningsNonGeneric()
        if PolygonWarning.areAnyEnabled() {
            _ = FutureVoid(getPolygonWarningsGeneric, updatePolygonWarningsGeneric)
        }
    }

    func getPolygonWarningsGeneric() {
        if nexradStateHS.wxMetal[0] != nil {
            nexradStateHS.wxMetal.forEach {
                $0!.construct.alertPolygons($0!.data, $0!.renderFn)
            }
        }
        [PolygonTypeGeneric.SMW, PolygonTypeGeneric.SQW, PolygonTypeGeneric.DSW, PolygonTypeGeneric.SPS].forEach {
            if PolygonWarning.byType[$0]!.isEnabled {
                PolygonWarning.byType[$0]!.download()
            }
        }
    }

    func updatePolygonWarningsGeneric() {
        if nexradStateHS.wxMetal[0] != nil {
            nexradStateHS.wxMetal.forEach {
                $0!.construct.alertPolygons($0!.data, $0!.renderFn)
            }
        }
    }

    func getPolygonWarningsNonGeneric() {
        if PolygonType.TST.display {
            [PolygonTypeGeneric.TOR, PolygonTypeGeneric.TST, PolygonTypeGeneric.FFW].forEach { t in
                updatePolygonWarningsNonGeneric(t)
            }
            [PolygonTypeGeneric.TOR, PolygonTypeGeneric.TST, PolygonTypeGeneric.FFW].forEach { t in
                _ = FutureVoid(PolygonWarning.byType[t]!.download) { self.updatePolygonWarningsNonGeneric(t) }
            }
        }
    }

    func updatePolygonWarningsNonGeneric(_ type: PolygonTypeGeneric) {
        if nexradStateHS.wxMetal[0] != nil {
            nexradStateHS.wxMetal.forEach {
                $0!.construct.alertPolygonsByType(type, $0!.data)
            }
        }
    }

    func getPolygonWatchGeneric() {
        [PolygonEnum.SPCMCD, PolygonEnum.SPCWAT, PolygonEnum.WPCMPD].forEach {
            updatePolygonWatchGeneric($0)
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
        if nexradStateHS.wxMetal[0] != nil {
            nexradStateHS.wxMetal.forEach {
                $0!.construct.watchPolygonsByType(type, $0!.data, $0!.renderFn)
            }
        }
    }

    func render(_ index: Int) {
        guard let drawable = nexradStateHS.metalLayer[index]!.nextDrawable() else { return }
        nexradStateHS.wxMetal[index]?.render(
            commandQueue: nexradStateHS.commandQueue,
            pipelineState: nexradStateHS.pipelineState,
            drawable: drawable,
            parentModelViewMatrix: nexradStateHS.modelMatrix(index),
            projectionMatrix: nexradStateHS.projectionMatrix
        )
    }

    func setupGestures() {
        let gestureRecognizer = GestureData(self, #selector(tapGesture))
        gestureRecognizer.numberOfTapsRequired = 1
        let gestureRecognizer2 = GestureData(self, #selector(tapGestureDouble))
        gestureRecognizer2.numberOfTapsRequired = 2
        uiv.cardRadar.connect(gestureRecognizer)
        uiv.cardRadar.connect(gestureRecognizer2)
        gestureRecognizer.require(toFail: gestureRecognizer2)
        gestureRecognizer.delaysTouchesBegan = true
        gestureRecognizer2.delaysTouchesBegan = true
        uiv.cardRadar.connect(UILongPressGestureRecognizer(target: self, action: #selector(gestureLongPress)))
    }

    @objc func tapGesture(_ gestureRecognizer: GestureData) {
        NexradRenderSurfaceView.singleTap(uiv, nexradStateHS.wxMetal, nexradStateHS.wxMetalTextObject, gestureRecognizer)
    }

    @objc func tapGestureDouble(_ gestureRecognizer: GestureData) {
        NexradRenderSurfaceView.doubleTap(uiv, nexradStateHS.wxMetal, nexradStateHS.wxMetalTextObject, nexradStateHS.numberOfPanes, gestureRecognizer)
    }

    @objc func gestureLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        // removed 2nd option  nexradStateHS.wxMetal,
        longPressCount = NexradRenderSurfaceView.gestureLongPress(uiv.cardRadar.get(), longPressCount, nexradTabLongPressMenu.longPressAction, gestureRecognizer)
    }

    func radarSiteChanged(_ rid: String) {
        getPolygonWarnings()
        nexradStateHS.wxMetal[0]!.resetRadarSiteAndGetData(rid, isHomeScreen: true)
    }
}
