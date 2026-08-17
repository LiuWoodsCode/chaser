// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcSettingsHomescreen: UIwXViewController {

    private var homeScreenFav = [String]()
    private var addImageButton = ToolbarIcon()
    private var addTextButton = ToolbarIcon()
    private var addButton = ToolbarIcon()

    override func viewDidLoad() {
        super.viewDidLoad()
        addButton = ToolbarIcon(self, .plus, #selector(addClicked))
        let defaultButton = ToolbarIcon("Set default", self, #selector(setToDefault))
        addImageButton = ToolbarIcon("Image", self, #selector(addImageClicked))
        addTextButton = ToolbarIcon("Text", self, #selector(addTextClicked))
        toolbar.items = ToolbarItems(
            doneButton,
            addTextButton,
            addImageButton,
            defaultButton,
            addButton).items
        objScrollStackView = ScrollStackView(self)
        boxMain.constrain(self)
        deSerializeSettings()
        display(saveToDisk: false)

        defaultButton.setText("Set default")
        addImageButton.setText("Image")
        addTextButton.setText("Text")
    }

    override func doneClicked() {
        serializeSettings()
        MyApplication.initPreferences()
        super.doneClicked()
    }

    func serializeSettings() {
        Utility.writePref("HOMESCREEN_FAV", WString.join(":", homeScreenFav))
    }

    func deSerializeSettings() {
        homeScreenFav = WString.split(Utility.readPref("HOMESCREEN_FAV", GlobalVariables.homescreenFavDefault), ":")
    }

    @objc func addClicked() {
        let alert = PopUp(self, addButton, "Product Selection")
        Array(UtilityHomeScreen.localChoicesText.keys).sorted().forEach { item in
            alert.add(Action(UtilityHomeScreen.localChoicesText[item]!) { self.addProduct(item) })
        }
        alert.finish()
    }

    func addProduct(_ selection: String) {
        if homeScreenFav.contains(selection) {
            _ = PopupMessage(selection + " is already in the home screen list.", self, addButton)
        } else {
            homeScreenFav.append(selection)
        }
        display()
    }

    @objc func addImageClicked() {
        let popUp = PopUp(self, addImageButton, "Graphical Products")
        (UtilityHomeScreen.localChoicesImages + GlobalArrays.nwsImageProducts).forEach { item in
            let list = item.split(":")
            popUp.add(Action(list[1]) { self.addProduct("IMG-" + list[0]) })
        }
        popUp.finish()
    }

    @objc func addTextClicked() {
        let popUp = PopUp(self, addTextButton, "Text Products")
        UtilityWpcText.labelsWithCodes.forEach { item in
            let list = item.split(":")
            popUp.add(Action(list[1]) { self.addProduct("TXT-" + list[0]) })
        }
        popUp.finish()
    }

    @objc func setToDefault() {
        homeScreenFav = WString.split(GlobalVariables.homescreenFavDefault, ":")
        display()
    }

    @objc func buttonPressed(sender: GestureData) {
        let index = sender.data
        let title = sender.strData
        let popUp = PopUp(self, addButton, title)
        if index != 0 {
            popUp.add(Action("Move Up") { self.move(index, .up) })
        }
        if index != (homeScreenFav.count - 1) {
            popUp.add(Action("Move Down") { self.move(index, .down) })
        }
        popUp.add(Action("Delete") { self.delete(selection: index) })
        popUp.finish()
    }

    func move(_ from: Int, _ to: MotionType) {
        var delta = 1
        if to == .up {
            delta = -1
        }
        let tmp = homeScreenFav[from + delta]
        homeScreenFav[from + delta] = homeScreenFav[from]
        homeScreenFav[from] = tmp
        display()
    }

    // need to keep the label
    func delete(selection: Int) {
        homeScreenFav.remove(at: selection)
        display()
    }

    private func display(saveToDisk: Bool = true) {
        if saveToDisk {
            serializeSettings()
        }
        boxMain.removeViews()
        homeScreenFav.enumerated().forEach { index, prefVar in
            var title = UtilityHomeScreen.localChoicesText[prefVar]
            let prefVarMod = prefVar.replace("TXT-", "").replace("IMG-", "")
            if title == nil {
                (UtilityHomeScreen.localChoicesImages + GlobalArrays.nwsImageProducts).forEach { label in
                    if label.hasPrefix(prefVarMod + ":") {
                        title = label.split(":")[1]
                    }
                }
            }
            if title == nil {
                UtilityWpcText.labelsWithCodes.forEach { label in
                    if label.hasPrefix(prefVarMod + ":") {
                        title = label.split(":")[1]
                    }
                }
            }
            if let goodTitle = title {
                let text = Text(
                    boxMain,
                    goodTitle.trim(),
                    GestureData(index, goodTitle, self, #selector(buttonPressed))
                )
                text.addSpacing()
                text.isSelectable = false
            } else {
                let text = Text(
                    boxMain,
                    prefVar,
                    GestureData(index, prefVar, self, #selector(buttonPressed))
                )
                text.addSpacing()
                text.isSelectable = false
            }
        }
    }
}
