// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class NexradColorLegend {

    var uiColorLegend = UIColorLegend()

    func updateColorLegend(_ view: UIView, _ nexradState: NexradState) {
        if RadarPreferences.showLegend && nexradState.numberOfPanes == 1 {
            uiColorLegend.removeFromSuperview()
            uiColorLegend = UIColorLegend(
                nexradState.wxMetalRenders[0]!.state.product,
                CGRect(
                    x: 0,
                    y: UIPreferences.statusBarHeight,
                    width: 100,
                    height: view.frame.size.height
                        - UIPreferences.toolbarHeight
                        - UIPreferences.statusBarHeight
                        - 100
                )
            )
            uiColorLegend.backgroundColor = UIColor.clear
            uiColorLegend.isOpaque = false
            view.addSubview(uiColorLegend)
        }
    }
}
