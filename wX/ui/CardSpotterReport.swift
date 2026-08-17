// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class CardSpotterReport {

    init(_ box: VBox, _ spotterReport: SpotterReports, _ gesture: GestureData) {
        let boxV = VBox()
        var textViews = [Text]()
        let topLine = spotterReport.type + " " + spotterReport.time
        let middleLine = spotterReport.city
        let bottomLine = spotterReport.lastName + ", " + spotterReport.firstName
        textViews.append(Text(boxV, topLine))
        textViews.append(Text(boxV, middleLine))
        textViews.append(Text(boxV, bottomLine))
        textViews[0].font = FontSize.medium.size
        textViews[1].font = FontSize.small.size
        textViews[2].font = FontSize.small.size
        textViews[0].color = ColorCompatibility.highlightText
        textViews[1].color = ColorCompatibility.label
        textViews[2].color = ColorCompatibility.systemGray2
        box.addWidget(Card(boxV))
        boxV.connect(gesture)
    }
}
