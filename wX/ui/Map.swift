// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit
import MapKit

final class Map {

    private let mapView = MKMapView()
    private var mapShown = false
    private let officeType: OfficeTypeEnum
    private let mapRegionRadius = 1000000.0

    init(_ officeType: OfficeTypeEnum) {
        self.officeType = officeType
    }

    private func setDelegate(_ fn: MKMapViewDelegate) {
        mapView.delegate = fn
    }

    func setup(_ fn: MKMapViewDelegate, _ itemList: [String]) {
        setDelegate(fn)
        setupLocations(itemList)
    }

    func setupLocations(_ itemList: [String]) {
        let locations = createLocationsList(itemList)
        var annotations = [MKPointAnnotation]()
        locations.forEach { dictionary in
            let latitude = CLLocationDegrees(Double(dictionary["latitude"]!)!)
            let longitude = CLLocationDegrees(Double(dictionary["longitude"]!)!)
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            annotation.title = dictionary["name"]!
            annotation.subtitle = dictionary["mediaURL"]
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
        centerMapOnLocation(
            location: CLLocationCoordinate2D(latitude: Location.latLon.lat, longitude: Location.latLon.lon),
            regionRadius: mapRegionRadius
        )
    }

    private func createLocationsList(_ offices: [String]) -> [[String: String]] {
        var locations = [[String: String]]()
        offices.forEach { item in
            let items = item.split(":")
            let latLon: LatLon
            switch officeType {
            case .wfo:
                latLon = WfoSites.sites.byCode[items[0]]!.latLon
            case .radar:
                latLon = RadarSites.getLatLon(items[0])
            case .sounding:
                latLon = SoundingSites.sites.byCode[items[0]]!.latLon
            }
            if items.count > 1 {
                let officeDict = [
                    "name": items[0],
                    "latitude": latLon.latString,
                    "longitude": latLon.lonString,
                    "mediaURL": items[1]
                ]
                locations.append(officeDict)
            } else {
                let officeDict = [
                    "name": items[0],
                    "latitude": latLon.latString,
                    "longitude": latLon.lonString,
                    "mediaURL": ""
                ]
                locations.append(officeDict)
            }
        }
        return locations
    }

    private func centerMapOnLocation(location: CLLocationCoordinate2D, regionRadius: Double) {
        let coordinateRegion = MKCoordinateRegion(
            center: location,
            latitudinalMeters: regionRadius * 2.0,
            longitudinalMeters: regionRadius * 2.0
        )
        let (width, height) = UtilityUI.getScreenBoundsCGFloat()
//        if #available(iOS 26, *) {
//            mapView.frame = CGRect(
//                x: 0,
//                y: UtilityUI.getTopPadding(),
//                width: width,
//                height: height
//                - UtilityUI.getBottomPadding()
//                - UtilityUI.getTopPadding()
//            )
//        } else {
            mapView.frame = CGRect(
                x: 0,
                y: UtilityUI.getTopPadding(),
                width: width,
                height: height
                - UIPreferences.toolbarHeight
                - UtilityUI.getBottomPadding()
                - UtilityUI.getTopPadding()
            )
//        }
        mapView.setRegion(coordinateRegion, animated: true)
    }

    func toggle(_ uiv: UIViewController) {
        if mapShown {
            mapView.removeFromSuperview()
            mapShown = false
        } else {
            mapShown = true
            uiv.view.addSubview(mapView)
        }
    }

    func mapView(_ annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "pin"
        var pin = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            pin!.pinTintColor = .red
            pin!.canShowCallout = true
            pin!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pin!.annotation = annotation
        }
        return pin
    }

    func mapViewExtra(_ annotationView: MKAnnotationView, _ control: UIControl, _ localChanges: (MKAnnotationView) -> Void) -> Bool {
        var mapShown = true
        if control == annotationView.rightCalloutAccessoryView {
            mapView.removeFromSuperview()
            mapShown = false
            localChanges(annotationView)
        }
        return mapShown
    }

    static func centerMapOnLocationEdit(_ mapView: MKMapView, location: CLLocationCoordinate2D, regionRadius: Double) {
        let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        let (width, _) = UtilityUI.getScreenBoundsCGFloat()
        mapView.frame = CGRect(x: 0, y: UtilityUI.getTopPadding(), width: width, height: width)
        mapView.setRegion(coordinateRegion, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
    }

    static func centerMapForMapKit(_ mapView: MKMapView, location: CLLocationCoordinate2D, regionRadius: Double) {
        let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        let (width, height) = UtilityUI.getScreenBoundsCGFloat()
        if #available(iOS 26, *) {
            mapView.frame = CGRect(
                x: 0,
                y: UtilityUI.getTopPadding(),
                width: width,
                height: height
                    - UtilityUI.getBottomPadding()
                    - UtilityUI.getTopPadding()
            )
        } else {
            mapView.frame = CGRect(
                x: 0,
                y: UtilityUI.getTopPadding(),
                width: width,
                height: height
                    - UIPreferences.toolbarHeight
                    - UtilityUI.getBottomPadding()
                    - UtilityUI.getTopPadding()
            )
        }
        mapView.setRegion(coordinateRegion, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
    }

    var isShown: Bool {
        get { mapShown }
        set { mapShown = newValue }
    }
}
