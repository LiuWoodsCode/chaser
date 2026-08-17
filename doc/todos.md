# TODOs

Image - cleanup after method arg change
Metar.findClosestMetar


shorten var name - ex. spotter reports
NexradRenderState.gpsLocation handling (don't store reverse from the start and add LatLon.isValid)
WXColor colorToInt
VcSettingsColorPicker (use more func in Color, use To.string)
GPS location marker on main screen vs nexrad is confusing
color selection screen is slow on high resolution devices

* [REF] NumberPicker - have constructor take args to match .kt such as
```
   // default/low/high
   NumberPicker(this, "Wind barbs line size", "RADAR_WB_LINESIZE", R.string.wb_linesize_np, 3, 1, 10)
```
* [REF] PolygonWatch/Warning - fix load to match .kt
* [REF] NHC storm match kt
* [FIX] if dark mode all the time, long press colors are off during the day
* [ADD] in location search show multiple results
* [REF] sync var names in UtilModelNcepInterface
* [REF] sync up ObjectDateTime
* [REF] deal with ColorCompatibility
* [FIX] dark mode radar icon does not show in severe dash and usalerts
* [ADD] NHC - support for central pac 
* [FIX] NHC onrestart has issues (crash and status line data)
* [FIX] have one spc mcd class for summary and one for display
* [FIX] confirm on device: with gps enabled, acccess nexrad, acess dual pane from time, go back, appears GPS is no longer activated
* [REF] settings location download timer for obs?
* [ADD] NWS Radar Mosaic - play icon toggles to stop and add ability to stop animation via button
* [FIX] download warnings in NexradLayerDownload which is now used by LocationFragment, Multipane, and Nexrad new
* [REF] why is handling of submenu different between vcTabParent and other tabs (object tile matrix)?
* [BUG] playlist, play audio, sleep device, wait 30 min, unlock, audio briefly plays and quits
* [ADD] parallel download for nexrad
* [FIX] dual pane does not show radar time for both panes
* [FIX] quad pane runs out of room when warnings selected
* [FIX] rotate main screen on phone results in whitespace due to shrinking bottom nav bar
* OPC Grib2 https://ocean.weather.gov/lightning/lightning_pdd.php
* from Android DistanceUnit: 
    MILE,
    KM,
    NAUTICAL_MILE,

FYI - FoundationNetworking added in later Swift release

old:
button.addTarget(self, action: #selector(test(sender:)), for: .touchUpInside)
@objc func test(sender: UIButton){}

iOS 14 onwards
button.addAction(UIAction(title: "Test Button", handler: { _ in  print("Test")}), for: .touchUpInside)
