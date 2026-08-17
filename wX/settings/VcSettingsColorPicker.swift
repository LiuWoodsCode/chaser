// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcSettingsColorPicker: UIwXViewController, HSBColorPickerDelegate {

    private let colorBarSize: CGFloat = 100.0
    private let colorBar = UIView()
    private var newRed: UInt8 = 0
    private var newGreen: UInt8 = 0
    private var newBlue: UInt8 = 0
    private var colorChanged = false
    private var colorButton = ToolbarIcon()
    private var colPicker = HSBColorPicker()
    var colorObject = WXColor()  // set in Route.colorPicker

    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton = ToolbarIcon(self, .done, #selector(doneClicked), forceLight: true)
        let defaultButton = ToolbarIcon("Set to default", self, #selector(saveDefaultColorClicked))
        colorButton = ToolbarIcon(self, nil)
        toolbar.items = ToolbarItems(doneButton, GlobalVariables.flexBarButton, colorButton, defaultButton).items
        colPicker.delegate = self
        refreshViews()
        colorButton.title = "(\(To.string(colorObject.colorsCurrent.red)), \(To.string(colorObject.colorsCurrent.green)), \(To.string(colorObject.colorsCurrent.blue)))"
        colorButton.setColor(colorObject.uiColorCurrent)
        view.addSubview(colPicker)
        view.addSubview(colorBar)
        view.addSubview(toolbar)
    }

    override func doneClicked() {
        if colorChanged {
            colorObject.saveNewColor(newRed, newGreen, newBlue)
        }
        super.doneClicked()
    }

    func HSBColorColorPickerTouched(sender: HSBColorPicker, color: UIColor, point: CGPoint, state: UIGestureRecognizer.State) {
        let colorInt = Color.rgb(color.components.red, color.components.green, color.components.blue)
        newRed = Color.red(colorInt)
        newGreen = Color.green(colorInt)
        newBlue = Color.blue(colorInt)
        colorChanged = true
        colorButton.title = "(\(newRed), \(newGreen), \(newBlue))"
        colorButton.setColor(Color.rgbToUIColor(newRed, newGreen, newBlue))
    }

    @objc func saveDefaultColorClicked() {
        colorObject.saveDefaultColor()
        newRed = colorObject.defaultRed
        newGreen = colorObject.defaultGreen
        newBlue = colorObject.defaultBlue
        colorChanged = true
        colorButton.title = "(\(newRed), \(newGreen), \(newBlue))"
        doneClicked()
    }

    internal func refreshViews() {
        let (width, height) = UtilityUI.getScreenBoundsCGFloat()
        if UtilityUI.isTablet() {
            colPicker.frame = CGRect(
                x: width * 0.25,
                y: toolbar.height + UtilityUI.getTopPadding() + height * 0.25,
                width: width / 2.0,
                height: height / 2.0
                    - toolbar.height * 2
                    - colorBarSize
                    - UtilityUI.getTopPadding()
            )
        } else {
            colPicker.frame = CGRect(
                x: 0,
                y: toolbar.height + UtilityUI.getTopPadding(),
                width: width,
                height: height
                    - toolbar.height * 2
                    - colorBarSize
                    - UtilityUI.getTopPadding()
            )
        }
        colorBar.frame = CGRect(
            x: 0,
            y: height - toolbar.height - colorBarSize,
            width: width,
            height: colorBarSize
        )
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in self.refreshViews() }
    }
}
