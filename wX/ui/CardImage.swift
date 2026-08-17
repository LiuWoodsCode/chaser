// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class CardImage: Widget {

    private let imageView = UIImageView()

    init(sizeFactor: CGFloat = 1.0) {
        let size = CGFloat(UIPreferences.nwsIconSize)
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: size * sizeFactor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: size * sizeFactor).isActive = true
    }

    func setBitmap(_ bitmap: Bitmap) {
        imageView.image = bitmap.image
    }

    func setImage(_ image: UIImage) {
        imageView.image = image
    }

    func connect(_ gesture: GestureData) {
        imageView.addGestureRecognizer(gesture)
    }

    func getView() -> UIView {
        imageView
    }
}
