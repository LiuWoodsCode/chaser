// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcSpcMcdWatchMpdViewer: UIwXViewControllerWithAudio {

    //
    // View a single image/text for a given watch/mcd/mpd
    // called from Route.spcMcdWatchItem
    //

    private var bitmap = Bitmap()
    private var html = ""
    private var url = ""
    private var productNumber = ""
    private var objectWatchProduct: ObjectWatchProduct?
    var watchMcdMpdNumber = ""
    var watchMcdMpdType = PolygonEnum.SPCWAT

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = UIPreferences.screenOnForTts
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        let radarButton = ToolbarIcon(self, .radar, #selector(radarClicked))
        productNumber = watchMcdMpdNumber
        if productNumber != "" {
            watchMcdMpdNumber = ""
        }
        toolbar.items = ToolbarItems(
            doneButton,
            GlobalVariables.flexBarButton,
            playButton,
            playListButton,
            shareButton,
            radarButton).items
        objScrollStackView = ScrollStackView(self)
        getContent()
    }

    override func doneClicked() {
        UIApplication.shared.isIdleTimerDisabled = false
        super.doneClicked()
    }

    override func willEnterForeground() {}

    override func getContent() {
        let number = To.stringPadLeftZeros(productNumber, 4)
        objectWatchProduct = ObjectWatchProduct(watchMcdMpdType, number)
        _ = FutureVoid(downloadImage, display)
        _ = FutureVoid({ self.html = self.objectWatchProduct!.getDataTextOnly() }, display)
    }

    private func downloadImage() {
        url = objectWatchProduct!.imgUrl
        bitmap = Bitmap(url)
    }

    @objc func imageClicked() {
        Route.imageViewer(self, url)
    }

    override func shareClicked(sender: UIButton) {
        if let object = objectWatchProduct {
            UtilityShare.image(self, sender, bitmap, object.text)
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
        boxMain.removeChildren()
        _ = ImageAndText(self, bitmap, html)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in self.display() }
    }
}
