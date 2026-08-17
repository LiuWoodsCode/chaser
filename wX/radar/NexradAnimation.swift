// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class NexradAnimation {

    private let nexradUI: NexradUI
    private let wxMetalRenders: [NexradRender?]
    private let nexradSubmenu: NexradSubmenu
    private let nexradLayerDownload: NexradLayerDownload

    init(_ nexradUI: NexradUI, _ wxMetalRenders: [NexradRender?], _ nexradSubmenu: NexradSubmenu, _ nexradLayerDownload: NexradLayerDownload) {
        self.nexradUI = nexradUI
        self.wxMetalRenders = wxMetalRenders
        self.nexradSubmenu = nexradSubmenu
        self.nexradLayerDownload = nexradLayerDownload
    }

    func stop() {
        if nexradUI.inOglAnim {
            nexradUI.inOglAnim = false
            nexradSubmenu.animateButton.set(.play)
            if wxMetalRenders[0] != nil {
                wxMetalRenders.forEach {
                    $0!.state.isAnimating = false
                    $0!.getRadar("")
                }
                nexradLayerDownload.getPolygonWarnings()
            }
        }
        nexradSubmenu.updateWarningsInToolbar()
    }

    func start(_ frameCnt: Int) {
        if !nexradUI.inOglAnim {
            nexradUI.inOglAnim = true
            nexradSubmenu.animateButton.set(.stop)
            run(frameCnt)
        } else {
            stop()
        }
    }

    func run(_ frameCnt: Int) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.wxMetalRenders.forEach { wxMetalRender in
                _ = NexradDownload.getRadarFilesForAnimation(frameCnt, wxMetalRender!.state.product, wxMetalRender!.state.radarSite, wxMetalRender!.fileStorage)
            }
            var scaleFactor = 1
            while self.nexradUI.inOglAnim {
                for frame in (0..<frameCnt) {
                    if self.nexradUI.inOglAnim {
                        self.wxMetalRenders.forEach { wxMetalRender in
                            let buttonText = " (" + String(frame + 1) + "/" + String(frameCnt) + ")"
                            wxMetalRender!.getRadar(String(frame), buttonText)
                            scaleFactor = 1
                        }
                        var interval = UIPreferences.animInterval
                        if self.wxMetalRenders[0]!.state.product.hasPrefix("L2") {
                            if interval < 12 {
                                interval = 12
                            }
                        }
                        usleep(UInt32(100000 * interval * scaleFactor))
                    } else {
                        break
                    }
                }
            }
            DispatchQueue.main.async {
            }
        }
    }
}
