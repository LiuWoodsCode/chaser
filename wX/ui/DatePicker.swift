// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class DatePicker: Widget {

    private let datePicker = UIDatePicker()

    init() {
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.maximumDate = Date()

        // SPC Storem reports: 2011-05-27 was the earliest date for filtered, moved to non-filtered and can go back to 2004-03-23
        let calendar = Calendar.current
        var minDateComponent = calendar.dateComponents([.day, .month, .year], from: Date())
        minDateComponent.day = 23
        minDateComponent.month = 03
        minDateComponent.year = 2004
        let minDate = calendar.date(from: minDateComponent)
        datePicker.minimumDate = minDate
    }

    func connect(_ uiv: UIViewController, _ selector: Selector) {
        datePicker.addTarget(uiv, action: selector, for: .valueChanged)
    }

    var date: Date {
        datePicker.date
    }

    var calendar: Calendar {
        datePicker.calendar
    }

    func getView() -> UIView {
        datePicker
    }
}
