// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit
import MapKit

final class VcMapKitView: UIwXViewController, MKMapViewDelegate {

    private var latLonButton = ToolbarIcon()
    private let mapView = MKMapView()
    var mapKitLat = ""
    var mapKitLon = ""
    var mapKitRadius = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton = ToolbarIcon(self, .done, #selector(doneClicked), forceLight: true)
        mapView.delegate = self
        let locationC = CLLocationCoordinate2D(latitude: To.double(mapKitLat), longitude: To.double(mapKitLon))
        Map.centerMapForMapKit(mapView, location: locationC, regionRadius: mapKitRadius)
        latLonButton = ToolbarIcon(self, #selector(showExternalMap))
        latLonButton.title = mapKitLat + ", " + mapKitLon
        toolbar.items = ToolbarItems(doneButton, GlobalVariables.flexBarButton, latLonButton).items
        view.addSubview(mapView)
        view.sendSubviewToBack(mapView)
    }

    @objc func showExternalMap() {
        let directionsURL = "https://maps.apple.com/?daddr=" + mapKitLat + "," + mapKitLon
        guard let url = URL(string: directionsURL) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
