// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcTabMisc: VcTabParent {

    private var tilesPerRow = UIPreferences.tilesPerRow

    override func viewDidLoad() {
        super.viewDidLoad()
        objTileMatrix = TileMatrix(self, boxMain, .misc)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if tilesPerRow != UIPreferences.tilesPerRow {
            boxMain.removeArrangedViews()
            tilesPerRow = UIPreferences.tilesPerRow
            objTileMatrix = TileMatrix(self, boxMain, .misc)
        }
        updateColors()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle && UIApplication.shared.applicationState == .inactive {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                AppColors.update()
            } else {
                AppColors.update()
            }
            updateColors()
        }
    }

    override func updateColors() {
        objTileMatrix.toolbar.setColorToTheme()
        super.updateColors()
    }
}
