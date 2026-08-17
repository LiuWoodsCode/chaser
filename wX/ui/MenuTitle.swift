// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class MenuTitle {

    let title: String
    let count: Int

    init(_ title: String, _ count: Int) {
		self.title = title
        self.count = count
	}

    static func getStart(_ titles: [MenuTitle], _ index: Int) -> Int {
        if index == 0 {
            return 0
        }
        var sum = 0
        (0..<index).forEach {
            sum += titles[$0].count
        }
        return sum
    }
}
