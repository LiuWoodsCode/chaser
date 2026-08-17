// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class Fab: Widget {

    private let floaty = Floaty(frame: UIScreen.main.bounds, size: 56)

    init(_ uiv: UIViewController, _ action: Selector, iconType: IconType = .radar) {
        floaty.sticky = true
        floaty.friendlyTap = false
        floaty.paddingY = 62.0 + UtilityUI.getBottomPadding()
        setColor()
        setImage(iconType)
        floaty.addGestureRecognizer(GestureData(uiv, action))
        uiv.view.addSubview(floaty)
    }

    func setImage(_ iconType: IconType) {
        #if targetEnvironment(macCatalyst)

        #else
        let imageString = ToolbarIcon.iconToString[iconType] ?? ""
        floaty.buttonImage = UtilityImg.resizeImage(UIImage(named: imageString)!, 0.50)
        let configuration = UIImage.SymbolConfiguration(weight: .medium)
        let color = UIColor.white
        let newIconValue = ToolbarIcon.oldIconToNew[imageString]
        if newIconValue != nil {
            let image = UIImage(
                systemName: newIconValue!,
                withConfiguration: configuration
                )?.withTintColor(color, renderingMode: .alwaysOriginal)
            floaty.buttonImage = UtilityImg.resizeImage(image!, 1.00)
        }
        #endif
    }

    func setColor() {
        floaty.buttonColor = AppColors.primaryColorFab
    }

    func resize() {
        floaty.paddingY = 62.0 + UtilityUI.getBottomPadding()
    }

    func setToTheLeft() {
        floaty.paddingX = 76.0
    }

    func close() {
        floaty.close()
    }

    func getView() -> UIView {
        floaty
    }
}
