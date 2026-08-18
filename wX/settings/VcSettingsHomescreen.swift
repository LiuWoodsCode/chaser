// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcSettingsHomescreen: UIwXViewController {

    private enum ProductPickerType {
        case local
        case image
        case text
    }

    private var homeScreenFav = [String]()
    private var leftPaneFav = [String]()
    private var rightPaneFav = [String]()
    private var addImageButton = ToolbarIcon()
    private var addTextButton = ToolbarIcon()
    private var addButton = ToolbarIcon()

    private var usePaneEditor: Bool {
        UtilityHomeScreen.usesTwoPaneRedesign
    }

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
        if usePaneEditor {
            UtilityHomeScreen.writePaneFavorites(left: leftPaneFav, right: rightPaneFav)
        } else {
            UtilityHomeScreen.writeFavorites(homeScreenFav)
        }
    }

    func deSerializeSettings() {
        homeScreenFav = UtilityHomeScreen.getFavorites()
        let paneFavorites = UtilityHomeScreen.getPaneFavorites()
        leftPaneFav = paneFavorites.left
        rightPaneFav = paneFavorites.right
    }

    @objc func addClicked() {
        startAddProduct(.local, button: addButton)
    }

    @objc func addImageClicked() {
        startAddProduct(.image, button: addImageButton)
    }

    @objc func addTextClicked() {
        startAddProduct(.text, button: addTextButton)
    }

    private func startAddProduct(_ pickerType: ProductPickerType, button: UIBarButtonItem) {
        if usePaneEditor {
            let popUp = PopUp(self, button, "Add to Pane")
            popUp.add(Action("Left Pane") { self.showProductPicker(pickerType, pane: .left, button: button) })
            popUp.add(Action("Right Pane") { self.showProductPicker(pickerType, pane: .right, button: button) })
            popUp.finish()
        } else {
            showProductPicker(pickerType, pane: nil, button: button)
        }
    }

    private func showProductPicker(
        _ pickerType: ProductPickerType,
        pane: UtilityHomeScreen.Pane?,
        button: UIBarButtonItem
    ) {
        let popUp = PopUp(self, button, productPickerTitle(pickerType), prefersCatalystList: true)
        switch pickerType {
        case .local:
            Array(UtilityHomeScreen.localChoicesText.keys).sorted().forEach { item in
                let title = UtilityHomeScreen.localChoicesText[item] ?? item
                popUp.add(Action(title) { self.addProduct(item, to: pane, button: button) })
            }
        case .image:
            (UtilityHomeScreen.localChoicesImages + GlobalArrays.nwsImageProducts).forEach { item in
                let list = item.split(":")
                popUp.add(Action(list[1]) { self.addProduct("IMG-" + list[0], to: pane, button: button) })
            }
        case .text:
            UtilityWpcText.labelsWithCodes.forEach { item in
                let list = item.split(":")
                popUp.add(Action(list[1]) { self.addProduct("TXT-" + list[0], to: pane, button: button) })
            }
        }
        popUp.finish()
    }

    private func productPickerTitle(_ pickerType: ProductPickerType) -> String {
        switch pickerType {
        case .local:
            return "Product Selection"
        case .image:
            return "Graphical Products"
        case .text:
            return "Text Products"
        }
    }

    func addProduct(_ selection: String) {
        addProduct(selection, to: nil, button: addButton)
    }

    private func addProduct(_ selection: String, to pane: UtilityHomeScreen.Pane?, button: UIBarButtonItem) {
        if usePaneEditor, let pane {
            if leftPaneFav.contains(selection) || rightPaneFav.contains(selection) {
                _ = PopupMessage(selection + " is already in the home screen list.", self, button)
            } else {
                append(selection, to: pane)
            }
        } else if homeScreenFav.contains(selection) {
            _ = PopupMessage(selection + " is already in the home screen list.", self, button)
        } else {
            homeScreenFav.append(selection)
        }
        display()
    }

    @objc func setToDefault() {
        if usePaneEditor {
            let paneFavorites = UtilityHomeScreen.splitIntoPaneFavorites(
                UtilityHomeScreen.splitFavorites(GlobalVariables.homescreenFavDefault)
            )
            leftPaneFav = paneFavorites.left
            rightPaneFav = paneFavorites.right
        } else {
            homeScreenFav = UtilityHomeScreen.splitFavorites(GlobalVariables.homescreenFavDefault)
        }
        display()
    }

    @objc func buttonPressed(sender: GestureData) {
        let index = sender.data
        guard homeScreenFav.indices.contains(index) else { return }
        let title = UtilityHomeScreen.title(for: homeScreenFav[index])
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

    @objc func paneButtonPressed(sender: GestureData) {
        let index = sender.data
        guard let pane = UtilityHomeScreen.Pane(rawValue: sender.strData) else { return }
        let favorites = favorites(for: pane)
        guard favorites.indices.contains(index) else { return }
        let title = UtilityHomeScreen.title(for: favorites[index])
        let popUp = PopUp(self, addButton, title)
        if index != 0 {
            popUp.add(Action("Move Up") { self.move(index, .up, in: pane) })
        }
        if index != (favorites.count - 1) {
            popUp.add(Action("Move Down") { self.move(index, .down, in: pane) })
        }
        popUp.add(Action("Move to " + paneTitle(otherPane(for: pane))) { self.moveToOtherPane(index, from: pane) })
        popUp.add(Action("Delete") { self.delete(selection: index, from: pane) })
        popUp.finish()
    }

    func move(_ from: Int, _ to: MotionType) {
        let delta = to == .up ? -1 : 1
        let newIndex = from + delta
        guard homeScreenFav.indices.contains(from), homeScreenFav.indices.contains(newIndex) else { return }
        let tmp = homeScreenFav[newIndex]
        homeScreenFav[newIndex] = homeScreenFav[from]
        homeScreenFav[from] = tmp
        display()
    }

    private func move(_ from: Int, _ to: MotionType, in pane: UtilityHomeScreen.Pane) {
        var favorites = favorites(for: pane)
        let delta = to == .up ? -1 : 1
        let newIndex = from + delta
        guard favorites.indices.contains(from), favorites.indices.contains(newIndex) else { return }
        let tmp = favorites[newIndex]
        favorites[newIndex] = favorites[from]
        favorites[from] = tmp
        setFavorites(favorites, for: pane)
        display()
    }

    private func moveToOtherPane(_ index: Int, from pane: UtilityHomeScreen.Pane) {
        var sourceFavorites = favorites(for: pane)
        guard sourceFavorites.indices.contains(index) else { return }
        let selection = sourceFavorites.remove(at: index)
        setFavorites(sourceFavorites, for: pane)
        append(selection, to: otherPane(for: pane))
        display()
    }

    // need to keep the label
    func delete(selection: Int) {
        guard homeScreenFav.indices.contains(selection) else { return }
        homeScreenFav.remove(at: selection)
        display()
    }

    private func delete(selection: Int, from pane: UtilityHomeScreen.Pane) {
        var favorites = favorites(for: pane)
        guard favorites.indices.contains(selection) else { return }
        favorites.remove(at: selection)
        setFavorites(favorites, for: pane)
        display()
    }

    private func display(saveToDisk: Bool = true) {
        if saveToDisk {
            serializeSettings()
        }
        boxMain.removeViews()
        if usePaneEditor {
            displayPaneEditor()
        } else {
            displaySingleListEditor()
        }
    }

    private func displaySingleListEditor() {
        homeScreenFav.enumerated().forEach { index, prefVar in
            addProductRow(prefVar, index: index)
        }
    }

    private func displayPaneEditor() {
        addPaneSection("Left Pane", .left, leftPaneFav)
        addPaneSection("Right Pane", .right, rightPaneFav)
    }

    private func addPaneSection(_ title: String, _ pane: UtilityHomeScreen.Pane, _ favorites: [String]) {
        let header = Text(boxMain, title, FontSize.extraLarge.size)
        header.addSpacing()
        header.color = ColorCompatibility.highlightText
        header.isSelectable = false
        if favorites.isEmpty {
            let emptyText = Text(boxMain, "No products", FontSize.medium.size)
            emptyText.addSpacing()
            emptyText.isSelectable = false
        } else {
            favorites.enumerated().forEach { index, prefVar in
                addProductRow(prefVar, index: index, pane: pane)
            }
        }
    }

    private func addProductRow(_ prefVar: String, index: Int, pane: UtilityHomeScreen.Pane? = nil) {
        let selector = pane == nil ? #selector(buttonPressed) : #selector(paneButtonPressed)
        let gesture = GestureData(index, pane?.rawValue ?? "", self, selector)
        let text = Text(
            boxMain,
            UtilityHomeScreen.title(for: prefVar),
            gesture
        )
        text.addSpacing()
        text.isSelectable = false
    }

    private func favorites(for pane: UtilityHomeScreen.Pane) -> [String] {
        switch pane {
        case .left:
            return leftPaneFav
        case .right:
            return rightPaneFav
        }
    }

    private func setFavorites(_ favorites: [String], for pane: UtilityHomeScreen.Pane) {
        switch pane {
        case .left:
            leftPaneFav = favorites
        case .right:
            rightPaneFav = favorites
        }
    }

    private func append(_ selection: String, to pane: UtilityHomeScreen.Pane) {
        switch pane {
        case .left:
            leftPaneFav.append(selection)
        case .right:
            rightPaneFav.append(selection)
        }
    }

    private func otherPane(for pane: UtilityHomeScreen.Pane) -> UtilityHomeScreen.Pane {
        switch pane {
        case .left:
            return .right
        case .right:
            return .left
        }
    }

    private func paneTitle(_ pane: UtilityHomeScreen.Pane) -> String {
        switch pane {
        case .left:
            return "Left Pane"
        case .right:
            return "Right Pane"
        }
    }
}
