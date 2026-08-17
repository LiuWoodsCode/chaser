// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class CardSunRise {

    private let text: Text
    private let latLon: LatLon

    init(_ box: CardHomeScreen, _ latLon: LatLon, _ gesture: GestureData) {
        self.latLon = latLon
        text = Text(box, "", FontSize.small.size, ColorCompatibility.label)
        text.textAlignment = .center
        text.connect(gesture)
        update()
    }

    func update() {
        let sunriseSunset = UtilityTimeSunMoon.getSunTimesForHomeScreen(latLon)
        let gmtTimeText = ObjectDateTime.gmtTime()
        text.text = sunriseSunset + GlobalVariables.newline + gmtTimeText
    }

    func resetTextSize() {
        text.font = FontSize.small.size
    }
}
