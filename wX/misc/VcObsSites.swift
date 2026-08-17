// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcObsSites: UIwXViewController {

    private var listCity = [String]()
    private var stateSelected = ""
    private var siteButton = ToolbarIcon()
    private var mapButton = ToolbarIcon()
    private let prefToken = "NWS_OBSSITE_LAST_USED"
    private let obsSiteBaseUrl = "https://www.weather.gov/wrh/timeseries?site="

    override func viewDidLoad() {
        super.viewDidLoad()
        siteButton = ToolbarIcon(self, #selector(siteClicked))
        mapButton = ToolbarIcon(self, #selector(mapClicked))
        toolbar.items = ToolbarItems(doneButton, GlobalVariables.flexBarButton, mapButton, siteButton).items
        objScrollStackView = ScrollStackView(self)
        boxMain.constrain(self)
        constructStateView()
        siteButton.setText("Last Used: " + Utility.readPref(prefToken, ""))
        mapButton.setText("Map")
    }

    @objc func goToState(sender: GestureData) {
        stateSelected = sender.strData.split(":")[0]
        showState()
    }

    func showState() {
        listCity = ["..Back to state list"]
        var listIds = ["..Back to state list"]
        var listSort = [String]()
        Metar.sites.sites.forEach {
            if $0.fullName.hasPrefix(stateSelected.uppercased()) {
                listSort.append($0.fullName + "," + $0.codeName)
            }
        }
        listSort = listSort.sorted()
        listSort.forEach { item in
            let list = item.split(",")
            let id = list[2]
            let city = list[1]
            listCity.append(id + ": " + city)
            listIds.append(id)
        }
        boxMain.removeViews()
        listCity.enumerated().forEach { index, city in
            let text = Text(boxMain, city, GestureData(index, self, #selector(gotoObsSite)))
            text.addSpacing()
            text.isSelectable = false
        }
        scrollView.scrollToTop()
    }

    @objc func gotoObsSite(sender: GestureData) {
        if sender.data == 0 {
            constructStateView()
        } else {
            let site = listCity[sender.data].split(":")[0]
            Utility.writePref(prefToken, site)
            siteButton.title = "Last Used: " + site
            Route.web(self, obsSiteBaseUrl + site)
        }
    }

    func constructStateView() {
        boxMain.removeViews()
        GlobalArrays.states.forEach { state in
            let text = Text(boxMain, state, GestureData(state, self, #selector(goToState)))
            text.addSpacing()
            text.isSelectable = false
        }
    }

    @objc func siteClicked() {
        Route.web(self, obsSiteBaseUrl + Utility.readPref(prefToken, ""))
    }

    @objc func mapClicked() {
        Route.web(self, "https://www.wrh.noaa.gov/map/?obs=true&wfo=" + Location.wfo.lowercased())
    }
}
