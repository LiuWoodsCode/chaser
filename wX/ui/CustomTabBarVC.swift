// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation
import UIKit

#if targetEnvironment(macCatalyst)
import AppKit
#endif

final class CustomTabBarVC: UITabBarController, UITabBarControllerDelegate {

    #if targetEnvironment(macCatalyst)
    private var macToolbarController: MacToolbarController?
    #endif

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .white
        if let items = tabBar.items {
            items.forEach {
                if let image = $0.image { $0.image = image.withRenderingMode(.alwaysOriginal) }
            }
        }
        #if targetEnvironment(macCatalyst)
        delegate = self
        tabBar.isHidden = true
        #endif
        // To remove dependancy on storyboard uncomment the following and 3 lines in AppDelegate.application
        // In Deployment Info change Main Interface from Main to ""
        /*
        let firstViewController = vcTabLocation()
        firstViewController.tabBarItem = UITabBarItem(title: "LOCAL", image: nil, tag: 0)
        let secondViewController = vcTabSpc()
        secondViewController.tabBarItem = UITabBarItem(title: "SPC", image: nil, tag: 1)
        let thirdViewController = vcTabMisc()
        thirdViewController.tabBarItem = UITabBarItem(title: "MISC", image: nil, tag: 2)
        let tabBarList = [firstViewController, secondViewController, thirdViewController]
        viewControllers = tabBarList
         */
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        #if targetEnvironment(macCatalyst)
        installMacToolbar()
        #endif
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        #if targetEnvironment(macCatalyst)
        macToolbarController?.setSelectedTab(selectedIndex)
        #endif
    }

    #if targetEnvironment(macCatalyst)
    private func installMacToolbar() {
        guard let titlebar = view.window?.windowScene?.titlebar else { return }
        if macToolbarController == nil {
            macToolbarController = MacToolbarController(tabBarController: self)
        }
        macToolbarController?.install(in: titlebar)
    }
    #endif
}

#if targetEnvironment(macCatalyst)
private final class MacToolbarController: NSObject, NSToolbarDelegate {

    private enum Identifier {
        static let toolbar = NSToolbar.Identifier("com.dapixelprowler.wxl23.main-toolbar")
        static let tabs = NSToolbarItem.Identifier("com.dapixelprowler.wxl23.main-toolbar.tabs")
        static let dashboard = NSToolbarItem.Identifier("com.dapixelprowler.wxl23.main-toolbar.dashboard")
        static let wfoText = NSToolbarItem.Identifier("com.dapixelprowler.wxl23.main-toolbar.wfo-text")
        static let clouds = NSToolbarItem.Identifier("com.dapixelprowler.wxl23.main-toolbar.clouds")
        static let radar = NSToolbarItem.Identifier("com.dapixelprowler.wxl23.main-toolbar.radar")
        static let more = NSToolbarItem.Identifier("com.dapixelprowler.wxl23.main-toolbar.more")
    }

    private weak var tabBarController: CustomTabBarVC?
    private weak var tabGroup: NSToolbarItemGroup?
    private let toolbar = NSToolbar(identifier: Identifier.toolbar)

    init(tabBarController: CustomTabBarVC) {
        self.tabBarController = tabBarController
        super.init()
        toolbar.delegate = self
        toolbar.displayMode = .iconOnly
        toolbar.allowsUserCustomization = false
        if #available(macCatalyst 16.0, *) {
            toolbar.centeredItemIdentifiers = [Identifier.tabs]
        }
    }

    func install(in titlebar: UITitlebar) {
        titlebar.toolbarStyle = .unified
        titlebar.toolbar = toolbar
        titlebar.autoHidesToolbarInFullScreen = true
        setSelectedTab(tabBarController?.selectedIndex ?? 0)
    }

    func setSelectedTab(_ index: Int) {
        tabGroup?.selectedIndex = index
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [
            Identifier.tabs,
            .flexibleSpace,
            Identifier.dashboard,
            Identifier.wfoText,
            Identifier.clouds,
            Identifier.radar,
            Identifier.more
        ]
    }

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        [
            Identifier.tabs,
            Identifier.dashboard,
            Identifier.wfoText,
            Identifier.clouds,
            Identifier.radar,
            Identifier.more,
            .flexibleSpace,
            .space
        ]
    }

    func toolbar(
        _ toolbar: NSToolbar,
        itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
        willBeInsertedIntoToolbar flag: Bool
    ) -> NSToolbarItem? {
        switch itemIdentifier {
        case Identifier.tabs:
            return makeTabItem()
        case Identifier.dashboard:
            return makeActionItem(
                itemIdentifier,
                title: "Severe Dashboard",
                systemImageName: "exclamationmark.shield.fill",
                action: #selector(showSevereDashboard(_:))
            )
        case Identifier.wfoText:
            return makeActionItem(
                itemIdentifier,
                title: "WFO Text",
                systemImageName: "doc.circle.fill",
                action: #selector(showWfoText(_:))
            )
        case Identifier.clouds:
            return makeActionItem(
                itemIdentifier,
                title: "Clouds",
                systemImageName: "cloud.fill",
                action: #selector(showClouds(_:))
            )
        case Identifier.radar:
            return makeActionItem(
                itemIdentifier,
                title: "Radar",
                systemImageName: "bolt.fill",
                action: #selector(showRadar(_:))
            )
        case Identifier.more:
            return makeMoreItem(itemIdentifier)
        default:
            return nil
        }
    }

    private func makeTabItem() -> NSToolbarItem {
        let group = NSToolbarItemGroup(
            itemIdentifier: Identifier.tabs,
            titles: ["Local", "SPC", "Misc"],
            selectionMode: .selectOne,
            labels: ["Local", "SPC", "Misc"],
            target: self,
            action: #selector(tabChanged(_:))
        )
        group.label = "Tabs"
        group.paletteLabel = "Tabs"
        group.visibilityPriority = .user
        group.selectedIndex = tabBarController?.selectedIndex ?? 0
        tabGroup = group
        return group
    }

    private func makeActionItem(
        _ itemIdentifier: NSToolbarItem.Identifier,
        title: String,
        systemImageName: String,
        action: Selector
    ) -> NSToolbarItem {
        let image = UIImage(systemName: systemImageName)
        let barButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: action)
        barButtonItem.accessibilityLabel = title

        let item = NSToolbarItem(itemIdentifier: itemIdentifier, barButtonItem: barButtonItem)
        item.target = self
        item.action = action
        item.label = title
        item.paletteLabel = title
        item.toolTip = title
        item.visibilityPriority = .high
        return item
    }

    private func makeMoreItem(_ itemIdentifier: NSToolbarItem.Identifier) -> NSToolbarItem {
        let image = UIImage(systemName: "ellipsis")
        let menu = Route.subMenu { [weak self] in self?.activeController }
        let barButtonItem = UIBarButtonItem(
            title: nil,
            image: image,
            primaryAction: nil,
            menu: menu
        )
        barButtonItem.accessibilityLabel = "More"

        let item = NSToolbarItem(itemIdentifier: itemIdentifier, barButtonItem: barButtonItem)
        item.label = "More"
        item.paletteLabel = "More"
        item.toolTip = "More"
        item.visibilityPriority = .high
        item.itemMenuFormRepresentation = menu
        return item
    }

    private var activeController: UIViewController? {
        guard let tabBarController else { return nil }
        return tabBarController.selectedViewController ?? tabBarController
    }

    @objc private func showSevereDashboard(_ sender: Any?) {
        guard let activeController else { return }
        Route.severeDashboard(activeController)
    }

    @objc private func showWfoText(_ sender: Any?) {
        guard let activeController else { return }
        Route.wfoText(activeController)
    }

    @objc private func showClouds(_ sender: Any?) {
        guard let activeController else { return }
        Route.goes(activeController)
    }

    @objc private func showRadar(_ sender: Any?) {
        guard let activeController else { return }
        Route.radarFromMainScreen(activeController)
    }

    @objc private func tabChanged(_ sender: NSToolbarItemGroup) {
        guard let tabBarController else { return }
        guard let viewControllers = tabBarController.viewControllers else { return }
        let selectedIndex = sender.selectedIndex
        guard selectedIndex >= 0 && selectedIndex < viewControllers.count else { return }
        tabBarController.selectedIndex = selectedIndex
        setSelectedTab(selectedIndex)
    }
}
#endif
