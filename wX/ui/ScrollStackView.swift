// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class ScrollStackView {

    var fragmentHeightAnchor1: NSLayoutConstraint?
    var fragmentHeightAnchor2: NSLayoutConstraint?
    var fragmentWidthAnchor1: NSLayoutConstraint?
    var fragmentWidthAnchor2: NSLayoutConstraint?

    static func applyTopToolbarContentInset(to scrollView: UIScrollView) {
        #if targetEnvironment(macCatalyst)
        return
        #else
        if #available(iOS 26, *) {
            let topInset = UIPreferences.toolbarHeight
            let previousTopInset = scrollView.contentInset.top
            let wasAtTop = scrollView.contentOffset.y <= -previousTopInset + 1.0

            var contentInset = scrollView.contentInset
            var verticalScrollIndicatorInsets = scrollView.verticalScrollIndicatorInsets
            guard abs(contentInset.top - topInset) > 0.5 || abs(verticalScrollIndicatorInsets.top - topInset) > 0.5 else { return }

            contentInset.top = topInset
            verticalScrollIndicatorInsets.top = topInset
            scrollView.contentInset = contentInset
            scrollView.verticalScrollIndicatorInsets = verticalScrollIndicatorInsets

            if wasAtTop {
                scrollView.contentOffset.y = -topInset
            }
        }
        #endif
    }

    init(_ uiv: UIwXViewController) {
        uiv.scrollView.backgroundColor = ColorCompatibility.systemGray5
        uiv.scrollView.translatesAutoresizingMaskIntoConstraints = false
        uiv.view.addSubview(uiv.scrollView)
        uiv.scrollView.leadingAnchor.constraint(equalTo: uiv.view.leadingAnchor).isActive = true
        uiv.scrollView.trailingAnchor.constraint(equalTo: uiv.view.trailingAnchor).isActive = true
        uiv.scrollView.centerXAnchor.constraint(equalTo: uiv.view.centerXAnchor).isActive = true
        let topSpace = UtilityUI.getTopPadding()
        var bottomSpace: CGFloat
        if #available(iOS 26, *) {
            bottomSpace = 0.0 // -(UtilityUI.getBottomPadding())
        } else {
            bottomSpace = -(UtilityUI.getBottomPadding() + UIPreferences.toolbarHeight)
        }
        uiv.scrollView.topAnchor.constraint(equalTo: uiv.view.topAnchor, constant: topSpace).isActive = true
        uiv.scrollView.bottomAnchor.constraint(equalTo: uiv.view.bottomAnchor, constant: bottomSpace).isActive = true
        uiv.boxMain.get().translatesAutoresizingMaskIntoConstraints = false
        uiv.boxMain.get().axis = .vertical
        uiv.boxMain.spacing = UIPreferences.stackviewCardSpacing
        uiv.scrollView.addSubview(uiv.boxMain.get())
        uiv.boxMain.get().leadingAnchor.constraint(equalTo: uiv.scrollView.leadingAnchor).isActive = true
        uiv.boxMain.get().trailingAnchor.constraint(equalTo: uiv.scrollView.trailingAnchor).isActive = true
        uiv.boxMain.get().topAnchor.constraint(equalTo: uiv.scrollView.topAnchor).isActive = true
        uiv.boxMain.get().bottomAnchor.constraint(equalTo: uiv.scrollView.bottomAnchor).isActive = true
        uiv.view.addSubview(uiv.toolbar)
        if #available(iOS 26, *) {
            uiv.scrollView.bottomAnchor.constraint(equalTo: uiv.toolbar.bottomAnchor).isActive = true
        } else {
            uiv.scrollView.bottomAnchor.constraint(equalTo: uiv.toolbar.topAnchor).isActive = true
        }
    }

    init(_ uiv: UIViewController, _ scrollView: UIScrollView, _ stackView: UIStackView) {
        scrollView.backgroundColor = AppColors.primaryBackgroundBlueUIColor
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        uiv.view.addSubview(scrollView)
        let topSpace: CGFloat
        #if targetEnvironment(macCatalyst)
        topSpace = UtilityUI.getTopPadding()
        #else
        if #available(iOS 26, *) {
            topSpace = 0.0
        } else {
            topSpace = UtilityUI.getTopPadding() + UIPreferences.toolbarHeight
        }
        #endif
        let bottomSpace: CGFloat
        #if targetEnvironment(macCatalyst)
        bottomSpace = 0.0
        #else
        if #available(iOS 26, *) {
            bottomSpace = 0.0 // -1.0 * UtilityUI.getBottomPadding()
        } else {
            bottomSpace = -1.0 * (UIPreferences.tabBarHeight + UtilityUI.getBottomPadding())
        }
        #endif
        fragmentHeightAnchor1 = scrollView.bottomAnchor.constraint(equalTo: uiv.view.bottomAnchor, constant: bottomSpace)
        fragmentHeightAnchor2 = scrollView.topAnchor.constraint(equalTo: uiv.view.topAnchor, constant: topSpace)
        fragmentWidthAnchor1 = scrollView.leadingAnchor.constraint(equalTo: uiv.view.leadingAnchor)
        fragmentWidthAnchor2 = scrollView.widthAnchor.constraint(equalTo: uiv.view.widthAnchor)
        uiv.view.addConstraints([fragmentHeightAnchor1!, fragmentHeightAnchor2!, fragmentWidthAnchor1!, fragmentWidthAnchor2!])
        Self.applyTopToolbarContentInset(to: scrollView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = UIPreferences.stackviewCardSpacing
        stackView.alignment = .center
        scrollView.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
}
