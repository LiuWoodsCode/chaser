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
        if let image = ToolbarIcon.symbolImage(iconType, color: UIColor.white) {
            floaty.buttonImage = UtilityImg.resizeImage(image, 1.00)
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
