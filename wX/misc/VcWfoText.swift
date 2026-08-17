// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit
import MapKit

final class VcWfoText: UIwXViewControllerWithAudio, MKMapViewDelegate {

    private var productButton = ToolbarIcon()
    private var siteButton = ToolbarIcon()
    var wfo = Location.wfo
    var sectorSpecified = false
    private let map = Map(.wfo)

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = UIPreferences.screenOnForTts
        product = "AFD"
        map.setup(self, WfoSites.sites.codeList)
        productButton = ToolbarIcon(self, #selector(productClicked))
        siteButton = ToolbarIcon(self, #selector(mapClicked))
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ToolbarItems(
            doneButton,
            GlobalVariables.flexBarButton,
            siteButton,
            productButton,
            playButton,
            playListButton,
            shareButton).items
        objScrollStackView = ScrollStackView(self)
        textMain = Text(boxMain)
        textMain.constrain(scrollView)
        if !sectorSpecified {
            if Utility.readPref("WFO_REMEMBER_LOCATION", "") == "true" {
                wfo = Utility.readPref("WFO_LAST_USED", Location.wfo)
            } else {
                wfo = Location.wfo
            }
        }
        product = Utility.readPref("WFOTEXT_PARAM_LAST_USED", product)
        getContent()
    }

    override func doneClicked() {
        UIApplication.shared.isIdleTimerDisabled = false
        super.doneClicked()
    }

    override func getContent() {
        _ = FutureText2(download, display)
    }

    private func download() -> String {
        return DownloadText.byProduct(product + wfo)
    }

    private func display(_ html: String) {
        productButton.setText(product)
        siteButton.setText(wfo)
        if html == "" {
            textMain.text = "None issued by this office recently."
        } else {
            textMain.text = html
        }
        if UtilityWfoText.needsFixedWidthFont(product) {
            textMain.font = FontSize.hourly.size
        } else {
            textMain.font = FontSize.medium.size
        }
        Utility.writePref("WFOTEXT_PARAM_LAST_USED", product)
        Utility.writePref("WFO_LAST_USED", wfo)
        scrollView.scrollToTop()
    }

    @objc func productClicked() {
        _ = PopUp(self, productButton, UtilityWfoText.wfoProdListNoCode, productChanged)
    }

    func productChanged(_ index: Int) {
        product = UtilityWfoText.wfoProdList[index].split(":")[0]
        UtilityAudio.resetAudio(self)
        playButton.set(.play)
        getContent()
    }

    override func shareClicked(sender: UIButton) {
        UtilityShare.share(self, sender, textMain.text)
    }

    @objc func mapClicked() {
        map.toggle(self)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        map.mapView(annotation)
    }

    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        map.isShown = map.mapViewExtra(annotationView, control, mapCall)
    }

    func mapCall(annotationView: MKAnnotationView) {
        scrollView.scrollToTop()
        wfo = (annotationView.annotation!.title!)!
        UtilityAudio.resetAudio(self)
        playButton.set(.play)
        getContent()
    }

    override func playlistClicked() {
        _ = UtilityPlayList.add(product + wfo, textMain.text, self, playListButton)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in self.map.setupLocations(WfoSites.sites.codeList) }
    }
}
