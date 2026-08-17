// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class ObjectAnimate: NSObject {

    let uiv: UIViewController
    let image: TouchImage
    let animateButton: ToolbarIcon
    let downloadFunction: (Int) -> Void
    let countList: [Int]

    init(
        _ uiv: UIViewController,
        _ image: TouchImage,
        _ animateButton: ToolbarIcon,
        _ downloadFunction: @escaping (Int) -> Void,
        _ countList: [Int]
    ) {
        self.uiv = uiv
        self.image = image
        self.animateButton = animateButton
        self.downloadFunction = downloadFunction
        self.countList = countList
    }

    @objc func animateClicked() {
        if countList.count > 0 {
            if image.isAnimating() {
                image.stopAnimating()
                animateButton.set(.play)
            } else {
                _ = PopUp(
                        uiv,
                        title: "Select number of animation frames:",
                        animateButton,
                        countList,
                        getAnimation
                    )
            }
        } else {
            getAnimation(0)
        }
    }

    @objc func getAnimation(_ frameCount: Int) {
        if !image.isAnimating() {
            animateButton.set(.stop)
            downloadFunction(frameCount)
        } else {
            image.stopAnimating()
            animateButton.set(.play)
        }
    }
}
