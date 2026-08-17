// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit
import CoreLocation

final class NexradUI {

    //
    // Map for selecting radar
    // GPS
    // Auto update
    //

    var inOglAnim = false
    let map = Map(.radar)
    private let mapKitBaseLayer = NexradMapKitBaseLayer()
    var locationManager = CLLocationManager()
    var oneMinRadarFetch = Timer()
    var mapIndex = 0
    var longPressCount = 0
    var timer: CADisplayLink!

    func setupMetal(_ uiv: UIViewController, _ nexradState: NexradState, _ render: @escaping (Int) -> Void, _ selectornewFrame: Selector) {
        nexradState.wxMetalRenders.forEach {
            $0?.setRenderFunction(render)
        }
        // Below two lines enable continuous updates
        if RadarPreferences.nexradContinuousMode {
            timer = CADisplayLink(target: uiv, selector: selectornewFrame)
            timer.add(to: RunLoop.main, forMode: RunLoop.Mode.default)
        }
    }

    func setupUIInitial(_ uiv: VcNexradRadar, _ nexradState: NexradState, _ numberOfPanes: Int) {
        uiv.view.backgroundColor = UIColor.black
        nexradState.numberOfPanes = numberOfPanes
        nexradState.paneRange = 0..<nexradState.numberOfPanes
        UtilityFileManagement.deleteAllFiles()
        map.setup(uiv, RadarSites.nexradRadars() + RadarSites.tdwrRadars())
    }

    func hideMap(_ uiv: UIViewController) {
        map.toggle(uiv)
    }

    func setupMapKitBaseLayer(_ uiv: UIViewController, _ nexradState: NexradState) {
        mapKitBaseLayer.setup(uiv.view, nexradState.numberOfPanes)
        updateMapKitBaseLayer(uiv, nexradState)
    }

    func updateMapKitBaseLayer(_ uiv: UIViewController, _ nexradState: NexradState) {
        mapKitBaseLayer.update(uiv, nexradState)
    }

    func removeMapKitBaseLayer() {
        mapKitBaseLayer.remove()
    }

    func setupGps(_ uiv: VcNexradRadar) {
        if RadarPreferences.locdotFollowsGps {
            locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = uiv
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
                locationManager.distanceFilter = 10
            }
        }
    }

    func resumeGps() {
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }

    func stopGps() {
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
    }

    func setupAutoRefresh(_ uiv: UIViewController, _ selectorGetRadarEveryMinute: Selector) { // #selector(getRadarEveryMinute) _ selectorGetRadarEveryMinute: Selector
        if RadarPreferences.wxoglRadarAutorefresh {
            UIApplication.shared.isIdleTimerDisabled = true
            oneMinRadarFetch = Timer.scheduledTimer(
                timeInterval: 60.0 * Double(RadarPreferences.dataRefreshInterval),
                target: uiv,
                selector: selectorGetRadarEveryMinute,
                userInfo: nil,
                repeats: true
            )
        }
    }

    func setupObservers(
        _ uiv: UIViewController,
        _ selectorinvalidateGps: Selector,
        _ selectoronPause: Selector,
        _ selectoronResume: Selector
    ) {
        if RadarPreferences.locdotFollowsGps {
            NotificationCenter.default.addObserver(
                uiv,
                selector: selectorinvalidateGps,
                name: UIApplication.willResignActiveNotification,
                object: nil
            )
        }
        NotificationCenter.default.addObserver(
            uiv,
            selector: selectoronPause,
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            uiv,
            selector: selectoronResume,
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
}
