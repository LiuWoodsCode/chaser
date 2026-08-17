// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class PopUp {

    private let alert: UIAlertController
    private let uiv: UIViewController
    private let button: UIBarButtonItem

    init(_ uiv: UIViewController, _ button: UIBarButtonItem, _ title: String, _ message: String = "") {
        alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet)
        alert.view.tintColor = ColorCompatibility.label
        self.button = button
        self.uiv = uiv
    }

    convenience init(_ uiv: UIViewController,
                     title: String = "Product Selection",
                     _ button: UIBarButtonItem,
                     _ list: [String],
                     _ fn: @escaping (String) -> Void,
    ) {
        self.init(uiv, button, title)
        list.forEach { item in
            var code = item
            if item.contains(":") {
                code = item.firstToken(":")
            }
            add(UIAlertAction(item) { _ in fn(code) })
        }
        finish()
    }

    convenience init(_ uiv: UIViewController,
                     title: String = "Product Selection",
                     _ button: UIBarButtonItem,
                     _ list: [Int],
                     _ fn: @escaping (Int) -> Void
    ) {
        self.init(uiv, button, title)
        list.forEach { item in
            add(UIAlertAction(To.string(item)) { _ in fn(item) })
        }
        finish()
    }

    convenience init(_ uiv: UIViewController,
                     title: String = "Product Selection",
                     _ button: UIBarButtonItem,
                     _ list: [String],
                     _ fn: @escaping (Int) -> Void
    ) {
        self.init(uiv, button, title)
        list.forEach { item in
            let index = list.firstIndex(of: item)!
            add(UIAlertAction(item) { _ in fn(index) })
        }
        finish()
    }

    convenience init(_ uiv: UIViewController,
                     _ title: String,
                     _ button: UIBarButtonItem,
                     _ list: [MenuTitle],
                     _ fn: @escaping (Int) -> Void
    ) {
        self.init(uiv, button, title)
        list.enumerated().forEach { index, title in
            add(UIAlertAction(title.title) { _ in fn(index) })
        }
        finish()
    }

    convenience init(_ uiv: UIViewController,
                     _ button: UIBarButtonItem,
                     _ list: [MenuTitle],
                     _ index: Int,
                     _ menuData: MenuData,
                     _ fn: @escaping (Int) -> Void
    ) {
        let title = list[index].title
        self.init(uiv, button, title)
        let startIdx = MenuTitle.getStart(list, index)
        let count = list[index].count
        (startIdx..<(startIdx + count)).forEach { idx in
            let paramTitle = menuData.paramLabels[idx]
            alert.addAction(UIAlertAction(paramTitle) { _ in fn(idx) })
        }
        finish()
    }

    func add(_ action: UIAlertAction) {
        alert.addAction(action)
    }

    func add(_ action: Action) {
        alert.addAction(action.uiAlertAction)
    }

    func finish() {
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: nil))
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = button
        }
        uiv.present(alert, animated: UIPreferences.backButtonAnimation, completion: nil)
    }
}
