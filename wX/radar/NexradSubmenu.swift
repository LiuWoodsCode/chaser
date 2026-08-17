// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class NexradSubmenu {

    let toolbar = Toolbar()
    var doneButton = ToolbarIcon()
    var timeButton = ToolbarIcon()
    var warningButton = ToolbarIcon()
    var radarSiteButton = ToolbarIcon()
    var productButton = [ToolbarIcon]()
    var animateButton = ToolbarIcon()
    var siteButton = [ToolbarIcon]()
    let nexradState: NexradState

    init(_ nexradState: NexradState) {
        self.nexradState = nexradState
    }

    func setupToolbar(
        _ uiv: UIViewController,
        _ toolbarTop: Toolbar,
        _ radarSiteClicked: Selector,
        _ timeClicked: Selector,
        _ warningClicked: Selector
    ) {
        var items = [UIBarButtonItem]()
        if nexradState.numberOfPanes < 4 {
            timeButton = ToolbarIcon("", uiv, timeClicked)
        }
        if nexradState.numberOfPanes == 1 {
            warningButton = ToolbarIcon("", uiv, warningClicked)
            items.append(timeButton)
            items.append(warningButton)
        } else {
            warningButton = ToolbarIcon("", uiv, warningClicked)
            items.append(timeButton)
            items.append(warningButton)
        }
        uiv.view.addSubview(toolbarTop)
        toolbarTop.setConfigWithUiv(uiv, toolbarType: .top)
        if nexradState.numberOfPanes > 1 {
            nexradState.paneRange.forEach { index in
                siteButton.append(ToolbarIcon("L", uiv, radarSiteClicked, tag: index))
            }
            items.append(GlobalVariables.flexBarButton)
            nexradState.paneRange.forEach { index in
                items.append(siteButton[index])
            }
        }
        toolbarTop.items = ToolbarItems(items).items
        if UIPreferences.radarToolbarTransparent {
            toolbarTop.setTransparent()
        }
        uiv.view.addSubview(toolbar)
        toolbar.setConfigWithUiv(uiv)
        if UIPreferences.radarToolbarTransparent {
            toolbar.setTransparent()
        }
    }

    func setupButtons(_ uiv: UIViewController,
                      _ doneClicked: Selector,
                      _ productClicked: Selector,
                      _ radarSiteClicked: Selector,
                      _ animateClicked: Selector
    ) {
        doneButton = ToolbarIcon(uiv, .done, doneClicked, forceLight: true)
        nexradState.paneRange.forEach { index in
            productButton.append(ToolbarIcon("", uiv, productClicked, tag: index))
        }
        radarSiteButton = ToolbarIcon("", uiv, radarSiteClicked)
        animateButton = ToolbarIcon(uiv, .play, animateClicked, forceLight: true)
        var toolbarButtons = [UIBarButtonItem]()
        toolbarButtons.append(doneButton)

        toolbarButtons += [GlobalVariables.flexBarButton, animateButton, GlobalVariables.fixedSpace]
        nexradState.paneRange.forEach {
            toolbarButtons.append(productButton[$0])
        }
        if nexradState.numberOfPanes == 1 {
            toolbarButtons.append(radarSiteButton)
        }
        toolbar.items = ToolbarItems(toolbarButtons).items
    }

    func updateWarningsInToolbar() {
        if RadarPreferences.warnings {
            warningButton.title = Warnings.getCountString()
        }
    }
}
