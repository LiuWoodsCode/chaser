// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit
import MapKit

final class NexradMapKitBaseLayer {

    private var mapViews = [MKMapView]()

    func setup(_ view: UIView, _ numberOfPanes: Int) {
        remove()
        guard RadarPreferences.useMapKitBaseLayer else { return }
        (0..<numberOfPanes).forEach { _ in
            let mapView = MKMapView(frame: .zero)
            mapView.isUserInteractionEnabled = false
            mapView.mapType = .standard
            mapView.showsBuildings = false
            mapView.showsCompass = false
            mapView.showsScale = false
            mapView.showsTraffic = false
            mapView.backgroundColor = UIColor.clear
            view.insertSubview(mapView, at: 0)
            mapViews.append(mapView)
        }
    }

    func update(_ uiv: UIViewController, _ nexradState: NexradState) {
        guard RadarPreferences.useMapKitBaseLayer else {
            remove()
            return
        }
        if mapViews.count != nexradState.numberOfPanes {
            setup(uiv.view, nexradState.numberOfPanes)
        }
        nexradState.paneRange.forEach { index in
            guard let wxMetal = nexradState.wxMetalRenders[index], let metalLayer = nexradState.metalLayer[index] else { return }
            let mapView = mapViews[index]
            mapView.frame = metalLayer.frame
            mapView.setRegion(region(uiv, wxMetal, nexradState.ortInt, metalLayer.frame), animated: false)
            uiv.view.sendSubviewToBack(mapView)
        }
    }

    func remove() {
        mapViews.forEach { $0.removeFromSuperview() }
        mapViews.removeAll()
    }

    private func region(_ uiv: UIViewController, _ wxMetal: NexradRender, _ ortInt: Float, _ frame: CGRect) -> MKCoordinateRegion {
        let center = coordinate(uiv, wxMetal, ortInt, CGPoint(x: frame.midX, y: frame.midY))
        let top = coordinate(uiv, wxMetal, ortInt, CGPoint(x: frame.midX, y: frame.minY))
        let bottom = coordinate(uiv, wxMetal, ortInt, CGPoint(x: frame.midX, y: frame.maxY))
        let left = coordinate(uiv, wxMetal, ortInt, CGPoint(x: frame.minX, y: frame.midY))
        let right = coordinate(uiv, wxMetal, ortInt, CGPoint(x: frame.maxX, y: frame.midY))
        var longitudeDelta = abs(right.longitude - left.longitude)
        if longitudeDelta > 180.0 {
            longitudeDelta = 360.0 - longitudeDelta
        }
        return MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(
                latitudeDelta: boundedDelta(abs(top.latitude - bottom.latitude)),
                longitudeDelta: boundedDelta(longitudeDelta)
            )
        )
    }

    private func coordinate(_ uiv: UIViewController, _ wxMetal: NexradRender, _ ortInt: Float, _ point: CGPoint) -> CLLocationCoordinate2D {
        let latLon = NexradRenderUI.getLatLonFromScreenPosition(
            uiv,
            wxMetal,
            wxMetal.state.numberOfPanes,
            ortInt,
            point.x,
            point.y
        )
        return CLLocationCoordinate2D(
            latitude: min(max(latLon.lat, -85.0), 85.0),
            longitude: normalizedLongitude(latLon.lon)
        )
    }

    private func boundedDelta(_ delta: CLLocationDegrees) -> CLLocationDegrees {
        min(max(delta, 0.01), 170.0)
    }

    private func normalizedLongitude(_ longitude: CLLocationDegrees) -> CLLocationDegrees {
        var normalized = longitude
        while normalized < -180.0 {
            normalized += 360.0
        }
        while normalized > 180.0 {
            normalized -= 360.0
        }
        return normalized
    }
}
