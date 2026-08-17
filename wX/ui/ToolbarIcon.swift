// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class ToolbarIcon: UIBarButtonItem, Widget {

    static let iconToSymbolName: [IconType: String] = [
        .share: "square.and.arrow.up",
        .pause: "pause.fill",
        .play: "play.fill",
        .playList: "folder.badge.plus",
        .stop: "stop.fill",
        .done: "chevron.left",
        .radar: "bolt.fill",
        .plus: "plus.app.fill",
        .cloud: "cloud.fill",
        .save: "checkmark",
        .search: "magnifyingglass",
        .delete: "trash.fill",
        .gps: "location.fill",
        .submenu: "ellipsis",
        .wfo: "doc.circle.fill",
        .severeDashboard: "exclamationmark.shield.fill",
        .leftArrow: "chevron.left",
        .rightArrow: "chevron.right",
        .download: "arrow.2.circlepath.circle.fill"
    ]

    static let iconToAccessibilityLabel: [IconType: String] = [
        .share: "share content",
        .pause: "pause",
        .play: "play",
        .playList: "play list",
        .stop: "stop",
        .done: "go back",
        .radar: "radar",
        .plus: "add",
        .cloud: "cloud",
        .save: "save",
        .search: "search",
        .delete: "delete",
        .gps: "GPS",
        .submenu: "More",
        .wfo: "wfo",
        .severeDashboard: "severe dashboard",
        .leftArrow: "go left",
        .rightArrow: "go right",
        .download: "download"
    ]

    private var button = UIButton()
    private var forceLight = false

    override init() {
        super.init()
    }

    convenience init(_ uiv: UIViewController, _ symbolName: String, _ action: Selector, isLabel: Bool = false, forceLight: Bool = false) {
        self.init()
        self.forceLight = forceLight
        if #available(iOS 26, *) {
            hidesSharedBackground = isLabel
        }
        button = makeButton(symbolName: symbolName, color: symbolColor(forceLight: forceLight))
        customView = button
        button.addTarget(uiv, action: action, for: .touchUpInside)
        constrainButton()
    }

    // severe dashboard and us alerts
    convenience init(_ iconType: IconType, _ gesture: GestureData) {
        self.init()
        let symbolName = ToolbarIcon.iconToSymbolName[iconType] ?? ""
        var color = UIColor.black
        if UITraitCollection.current.userInterfaceStyle == .dark {
            color = UIColor.white
        }
        button = makeButton(symbolName: symbolName, color: color)
        customView = button
        button.addGestureRecognizer(gesture)
        constrainButton()
    }

    convenience init(_ uiv: UIViewController, _ iconType: IconType, _ action: Selector, isLabel: Bool = false, forceLight: Bool = false) {
        self.init(uiv, ToolbarIcon.iconToSymbolName[iconType] ?? "", action, isLabel: isLabel, forceLight: forceLight)
        button.isAccessibilityElement = true
        button.accessibilityLabel = ToolbarIcon.iconToAccessibilityLabel[iconType] ?? "No label"
    }

    convenience init(_ target: UIViewController, _ action: Selector?, isLabel: Bool = false) {
        self.init(title: "", style: UIBarButtonItem.Style.plain, target: target, action: action)
        if #available(iOS 26, *) {
            hidesSharedBackground = isLabel
        }
    }

    convenience init(_ title: String, _ target: UIViewController, _ action: Selector?, isLabel: Bool = false) {
        self.init(title: title, style: UIBarButtonItem.Style.plain, target: target, action: action)
        if #available(iOS 26, *) {
            hidesSharedBackground = isLabel
        }
        setText(title)
    }

    convenience init(_ title: String, _ target: UIViewController, _ action: Selector?, tag: Int) {
        self.init(title: title, style: UIBarButtonItem.Style.plain, target: target, action: action)
        setText(title)
        self.tag = tag
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func set(_ iconType: IconType) {
        button.setImage(Self.symbolImage(iconType, color: symbolColor(forceLight: forceLight)), for: .normal)
    }

    static func symbolImage(_ iconType: IconType, color: UIColor) -> UIImage? {
        let symbolName = iconToSymbolName[iconType] ?? ""
        return symbolImage(named: symbolName, color: color)
    }

    static func symbolImage(named symbolName: String, color: UIColor) -> UIImage? {
        let configuration = UIImage.SymbolConfiguration(pointSize: 20.0, weight: .medium)
        return UIImage(systemName: symbolName, withConfiguration: configuration)?
            .withTintColor(color, renderingMode: .alwaysOriginal)
    }

    func setColor(_ uicolor: UIColor) {
//        tintColor = UIColor(red: CGFloat(Double(red) / 255.0), green: CGFloat(Double(green) / 255.0), blue: CGFloat(Double(blue) / 255.0), alpha: 1.0)
        // Define text attributes
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: uicolor
            // .font: UIFont.systemFont(ofSize: 17, weight: .bold) // Optional: set font
        ]
        // Apply attributes to the bar button item for a specific state
        setTitleTextAttributes(attributes, for: .normal)
    }

    func setText(_ s: String, forceLight: Bool = false) {
        title = s
        if #available(iOS 26, *) {
            var color = UIColor.black
            if UITraitCollection.current.userInterfaceStyle == .dark {
                color = UIColor.white
            }
            if forceLight {
                color = UIColor.white
            }
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: color
            ]
            setTitleTextAttributes(attributes, for: .normal)
        }
    }

    func setMenu(_ menu: UIMenu) {
        self.menu = menu
        primaryAction = nil
        target = nil
        action = nil
        button.removeTarget(nil, action: nil, for: .allEvents)
        button.menu = menu
        button.showsMenuAsPrimaryAction = true
        button.accessibilityLabel = "More"
    }

    func getView() -> UIView {
        button
    }

    private func makeButton(symbolName: String, color: UIColor) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: UIPreferences.toolbarHeight, height: UIPreferences.toolbarHeight))
        button.setImage(Self.symbolImage(named: symbolName, color: color), for: .normal)
        button.tintColor = color
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }

    private func constrainButton() {
        let widthConstraint = button.widthAnchor.constraint(equalToConstant: UIPreferences.toolbarHeight)
        let heightConstraint = button.heightAnchor.constraint(equalToConstant: UIPreferences.toolbarHeight)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
    }

    private func symbolColor(forceLight: Bool) -> UIColor {
        var color = UIColor.white
        if #available(iOS 26, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                color = UIColor.white
            } else {
                color = UIColor.black
            }
            if forceLight {
                color = UIColor.white
            }
        }
        return color
    }
}
