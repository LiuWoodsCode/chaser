// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class Hazards {

    var data = ""

    func process(_ location: LatLon) {
        data = ("https://api.weather.gov/alerts?point=\(location.latForNws),\(location.lonForNws)&active=1").getNwsHtml()
    }
}
