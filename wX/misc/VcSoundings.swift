// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit
import MapKit

final class VcSoundings: UIwXViewController, MKMapViewDelegate {

    private var touchImage = TouchImage()
    private var siteButton = ToolbarIcon()
    private let map = Map(.sounding)
    var site = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton = ToolbarIcon(self, .done, #selector(doneClicked), forceLight: true)
        map.setup(self, SoundingSites.sites.codeList)
        let shareButton = ToolbarIcon(self, .share, #selector(share), forceLight: true)
        let textButton = ToolbarIcon(self, #selector(textClicked))
        textButton.title = "TEXT"
        siteButton = ToolbarIcon(self, #selector(mapClicked))
        toolbar.items = ToolbarItems(
            doneButton,
            GlobalVariables.flexBarButton,
            GlobalVariables.fixedSpace,
            textButton,
            siteButton,
            shareButton).items
        touchImage = TouchImage(self, toolbar)
        if site == "" {
            site = SoundingSites.sites.getNearest(Location.latLon)
        }
        getContent(site)
    }

    func getContent(_ wfo: String) {
        siteButton.title = wfo
        _ = FutureBytes2({ UtilitySpcSoundings.getImage(wfo) }, touchImage.set)
    }

    @objc func share(sender: UIButton) {
        UtilityShare.image(self, sender, touchImage.getBitmap())
    }

    @objc func mapClicked() {
        map.toggle(self)
    }

    @objc func textClicked() {
        let textUrl = "https://www.spc.noaa.gov/exper/soundings/LATEST/" + siteButton.title! + ".txt"
        _ = FutureText2({ textUrl.getHtml() }, gotoTextViewer)
    }

    private func gotoTextViewer(_ s: String) {
        Route.textViewer(self, s, isFixedWidth: true)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        map.mapView(annotation)
    }

    func mapView(_ mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        map.isShown = map.mapViewExtra(annotationView, control, mapCall)
    }

    func mapCall(annotationView: MKAnnotationView) {
        getContent((annotationView.annotation!.title!)!)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            self.touchImage.refresh()
            self.map.setupLocations(SoundingSites.sites.codeList)
        }
    }
}
