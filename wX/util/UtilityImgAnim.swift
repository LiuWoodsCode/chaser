// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class UtilityImgAnim {

    static func getAnimationDrawableFromBitmapListForModels(_ bitmaps: [Bitmap]) -> AnimationDrawable {
        let animDrawable = AnimationDrawable()
        bitmaps.filter { $0.isValid }.forEach {
            animDrawable.addFrame($0)
        }
        return animDrawable
    }

    static func getAnimationDrawableFromUrlList(_ urls: [String], addWhiteBg: Bool = false) -> AnimationDrawable {
        var bitmaps = [Bitmap](repeating: Bitmap(), count: urls.count)
        let dispatchGroup = DispatchGroup()
        for (index, url) in urls.enumerated() {
            dispatchGroup.enter()
            DispatchQueue.global().async {
                if addWhiteBg {
                    bitmaps[index] = Bitmap(url, addWhiteBg: true)
                } else {
                    bitmaps[index] = Bitmap(url)
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.wait()
        let animDrawable = AnimationDrawable()
        bitmaps.filter { $0.isValid }.forEach {
            animDrawable.addFrame($0)
        }
        return animDrawable
    }
}
