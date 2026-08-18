// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class Toolbar: UIToolbar {

    private var toolbarHeightConstraint: NSLayoutConstraint?

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func setConfigWithUiv(_ uiv: UIViewController, toolbarType: ToolbarType = .bottom) {
        switch toolbarType {
        case .bottom:
            let bottomSpace = -1 * UtilityUI.getBottomPadding()
            translatesAutoresizingMaskIntoConstraints = false
            bottomAnchor.constraint(equalTo: uiv.view.bottomAnchor, constant: bottomSpace).isActive = true
            heightAnchor.constraint(equalToConstant: UIPreferences.toolbarHeight).isActive = true
            leftAnchor.constraint(equalTo: uiv.view.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: uiv.view.rightAnchor).isActive = true
        case .top:
            translatesAutoresizingMaskIntoConstraints = false
            toolbarHeightConstraint = topAnchor.constraint(equalTo: uiv.view.topAnchor, constant: UtilityUI.getTopPadding())
            uiv.view.addConstraint(toolbarHeightConstraint!)
            leftAnchor.constraint(equalTo: uiv.view.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: uiv.view.rightAnchor).isActive = true
            heightAnchor.constraint(equalToConstant: UIPreferences.toolbarHeight).isActive = true
        }
        setColorToTheme()
    }

    func resize(uiv: UIViewController) {
        if toolbarHeightConstraint != nil {
            uiv.view.removeConstraint(toolbarHeightConstraint!)
        }
        toolbarHeightConstraint = topAnchor.constraint(equalTo: uiv.view.topAnchor, constant: UtilityUI.getTopPadding())
        uiv.view.addConstraint(toolbarHeightConstraint!)
    }

    func setColorToTheme() {
        if #available(iOS 26, *) {
            useSystemLiquidGlassAppearance()
            return
        }

        barTintColor = UIColor(
            red: AppColors.primaryColorRed,
            green: AppColors.primaryColorGreen,
            blue: AppColors.primaryColorBlue,
            alpha: CGFloat(1.0)
        )
    }

    func setTransparent() {
        if #available(iOS 26, *) {
            useSystemLiquidGlassAppearance()
            return
        }

        setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        setShadowImage(UIImage(), forToolbarPosition: .any)
    }

    private func useSystemLiquidGlassAppearance() {
        barTintColor = nil
        backgroundColor = nil
        isTranslucent = true
        setBackgroundImage(nil, forToolbarPosition: .any, barMetrics: .default)
        setBackgroundImage(nil, forToolbarPosition: .any, barMetrics: .compact)
        setShadowImage(nil, forToolbarPosition: .any)
    }

    var height: CGFloat { frame.size.height }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
