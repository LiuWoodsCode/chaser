// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class FutureText2 {

    private let updateFunc: (String) -> Void

    init(_ downloadFunc: @escaping () -> String, _ updateFunc: @escaping (String) -> Void) {
        self.updateFunc = updateFunc
        DispatchQueue.global(qos: .userInitiated).async {
            let s = downloadFunc()
            DispatchQueue.main.async { self.updateFunc(s) }
        }
    }
}
