// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcSpcWatchMcdMpd: UIwXViewControllerWithAudio {

    //
    // Provides a group of images of multiple watch/mpd/mcd or if only one show image/text
    // called from Route.spcMcdWatchSummary
    //

    private var bitmaps = [Bitmap]()
    private var numbers = [String]()
    private var listOfText = [String]()
    private var urls = [String]()
    private var objectWatchProduct: ObjectWatchProduct?
    var watchMcdMpdType = PolygonEnum.SPCWAT

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = UIPreferences.screenOnForTts
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        let radarButton = ToolbarIcon(self, .radar, #selector(radarClicked))
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, playButton, playListButton, shareButton, radarButton]).items
        objScrollStackView = ScrollStackView(self)
        getContent()
    }

    override func doneClicked() {
        UIApplication.shared.isIdleTimerDisabled = false
        super.doneClicked()
    }

    override func willEnterForeground() {}

    override func getContent() {
        _ = FutureVoid(download, display)
    }

    private func download() {
        let productNumberList = ObjectWatchProduct.getNumberList(watchMcdMpdType)
        productNumberList.forEach {
            let number = To.stringPadLeftZeros($0, 4)
            objectWatchProduct = ObjectWatchProduct(watchMcdMpdType, number)
            objectWatchProduct!.getData()
            listOfText.append(objectWatchProduct!.text)
            urls.append(objectWatchProduct!.imgUrl)
            bitmaps.append(objectWatchProduct!.bitmap)
            numbers.append(number)
        }
    }

    @objc func imageClicked(sender: GestureData) {
        if bitmaps.count == 1 {
            Route.imageViewer(self, urls[0])
        } else {
            Route.spcMcdWatchItem(self, watchMcdMpdType, numbers[sender.data])
        }
    }

    override func shareClicked(sender: UIButton) {
        if let object = objectWatchProduct {
            UtilityShare.image(self, sender, bitmaps, object.text)
        }
    }

    override func playlistClicked() {
        if let object = objectWatchProduct {
            _ = UtilityPlayList.add(objectWatchProduct!.prod, object.text, self, playListButton)
        }
    }

    @objc func radarClicked() {
        Route.radarNoSave(self, objectWatchProduct?.getClosestRadar() ?? "")
    }

    private func display() {
        var tabletInLandscape = UtilityUI.isTablet() && UtilityUI.isLandscape() && bitmaps.count == 1
        #if targetEnvironment(macCatalyst)
        tabletInLandscape = bitmaps.count == 1
        #endif
        if tabletInLandscape {
            boxMain.axis = .horizontal
            boxMain.alignment = .firstBaseline
        }
        var views = [UIView]()
        if bitmaps.count > 0 {
            bitmaps.enumerated().forEach {
                let objectImage: Image
                if tabletInLandscape {
                    objectImage = Image(
                        boxMain,
                        $1,
                        GestureData($0, self, #selector(imageClicked(sender:))),
                        widthDivider: 2
                    )
                } else {
                    objectImage = Image(
                        boxMain,
                        $1,
                        GestureData($0, self, #selector(imageClicked(sender:)))
                    )
                }
                objectImage.accessibilityLabel = listOfText[$0]
                objectImage.isAccessibilityElement = true
                views.append(objectImage.getView())
            }
            if bitmaps.count == 1 {
                if tabletInLandscape {
                    textMain = Text(boxMain, objectWatchProduct?.text ?? "", widthDivider: 2)
                } else {
                    textMain = Text(boxMain, objectWatchProduct?.text ?? "")
                }
                textMain.isAccessibilityElement = true
                views.append(textMain.get())
            }
        } else {
            let message = objectWatchProduct?.getTextForNoProducts() ?? "No active " + String(describing: watchMcdMpdType) + "s"
            let text = Text(boxMain, message)
            text.isAccessibilityElement = true
            text.constrain(scrollView)
            views += [text.get()]
            text.accessibilityLabel = message
        }
        view.bringSubviewToFront(toolbar)
        scrollView.accessibilityElements = views
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            self.boxMain.removeChildren()
            self.display()
        }
    }
}
