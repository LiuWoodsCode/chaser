
# wXL23 ChangeLog

Service outages with NWS data will be posted in the [FAQ](https://gitlab.com/joshua.tee/wxl23/-/blob/master/doc/FAQ.md) as I become aware of them. 
FAQ can be accessed via Settings -> About

[Upcoming changes](https://gitlab.com/joshua.tee/wxl23/-/blob/master/doc/UPCOMING_CHANGES.md) impacting all or some users

### version **56183** - released on 2026/03/TBD

* fix: SPC CONUS Convective outlook images for Day1-3 broke after NWS SPC made changes to image format

### version **56182** - released on 2025/12/08

* [ADD] move product button to top in Observations as there was not enough room to fit in the bottom
* [FIX] Settings -> Spotters is working again (latest iOS versions require explicit encoding to be specifed and this seems to be Windows Code Page 1252 (Western European) [1] - determined via `chardetect`
* [FIX] add lock in display method in NhcStorm to prevent occasional crash
* [FIX] Modelviewer would not allow top buttons to be used in iOS 18 or older
* fix: Settings Homescreen is too crowded in bottom toolbar so remove some text

### version **56181** - released on 2025/10/28

* [FIX] app crash when custom images added to homescreen

### version **56179** - released on 2025/10/27

* [ADD] Due to the density of the new iPhone 17 variants iOS26 looks quite different then on most other iPhones. Buttons are shaped differently and have more spacing. As a result the Nexrad radar interface has been forced to change with more usage of a transparent top toolbar. Numerous other screens have changed. While I try to keep the interface stable this was unavoidable. If you have issues please email me a screenshot, your iOS version, and your device type.
* [ADD] Modify AlertsDetail activity which when viewed on the iPhone 17 would show a "blank" button in some situations which on other models would appear hudden as intended.
* [FIX] If Level 2 REF or VEL was the last product viewed in the Nexrad viewer it would not properly show when the activity is started again
* [ADD] dialogue box will now show "Dismiss" instead of "Cancel" at the bottom as it seems more appropriate in all cases
* [FIX] TDWR radar **TADW** (Andrews Air Force Base (ADW)) was not working correctly (wrong LAT/LON)
* [FIX] https://aviationweather.gov/ changed their API w/o following the Service Change Notice
  process, This broke wind barbs in Nexrad
* [FIX] In the color picker change element size from 1 to 10 for faster performance on load (HSBColorPicker.elementSize)
* [FIX] In Nexrad if you are viewing N0S product and switch to TDWR show TV0 instead of nothing (this already occurs for N0U/N0Q)
* [FIX] duplicate hazards from showing up on main screen

### version **56177** - released on 2025/09/03

* [FIX] In Alerts detailed activity if application is resumed duplicate data is shown at the bottom
* [ADD] In **Settings->UI** add "orange" to color them option
* [ADD] in **Settings->UI** change "Hourly screen: show with AM/PM" to "Hourly/Nexrad: show with AM/PM" as nexrad is now impacted by this setting. Note that in Nexrad due to space reasons AM/PM is not shown however if you **long-press* you can see the full timestamp of the radar image at the top.
* [ADD] If **Settings->UI** is visited, force refresh on main screen in case any setting is changed
* [ADD] For non-default text products added to **Home Screen**, add blank line at end to make it more clear on where text products ends (useful if back to back text products configured) - Reminder: you can tap on the text to expand to see the entire text product, tap again to truncate.
* [ADD] In the Nexrad radar viewer in single pane if you tab the timestamp you jump to dual pane. Now
        if you are in dual pane and you tap the timestamp you will jump to quad pane.
* [ADD] In **Settings->Radar** add this in parenthesis to clarify about this option which is not normally needed:
```
Center radar on location (disables pan to move in a direction)
```
* [ADD] updates for NCEP Models for **MAG 6.0 - August 2025** in particular new products for
  National Blend of Models (NBM)

```
precip_p01
1hour_precip_chance
6hour_precip_chance
12hour_precip_chance
precip_duration (NAMER and CONUS domains only)
prob_rain (NAMER, CONUS, and Alaska domains only)
prob_snow (NAMER, CONUS, and Alaska domains only)
prob_sleet (NAMER, CONUS, and Alaska domains only)
prob_freezing_rain (NAMER, CONUS, and Alaska domains only)
snow_liquid_ratio (NAMER, CONUS, and Alaska domains only)
1hour_accu_snow (NAMER, CONUS, and Alaska domains only)
6hour_accu_snow (NAMER, CONUS, and Alaska domains only)
total_accu_snow (NAMER, CONUS, and Alaska domains only)
10th_percentile_1hr_snow (NAMER, CONUS, and Alaska domains only)
50th_percentile_1hr_snow (NAMER, CONUS, and Alaska domains only)
90th_percentile_1hr_snow (NAMER, CONUS, and Alaska domains only)
prob_1h_snow_0.1in (NAMER, CONUS, and Alaska domains only)
prob_1h_snow_0.3in (NAMER, CONUS, and Alaska domains only)
prob_1h_snow_0.5in (NAMER, CONUS, and Alaska domains only)
prob_1h_snow_0.7in (NAMER, CONUS, and Alaska domains only
prob_1h_snow_1in (NAMER, CONUS, and Alaska domains only)
prob_1h_snow_1.5in (NAMER, CONUS, and Alaska domains only)
prob_1h_snow_2in (NAMER, CONUS, and Alaska domains only)
prob_1h_snow_3in (NAMER, CONUS, and Alaska domains only)
prob_1h_snow_4in (NAMER, CONUS, and Alaska domains only)
tstm_coverage
visibility
ceiling
cape
echo_top
prob_tstm
prob_vis_5mi (NAMER and CONUS domains only)
prob_vis_3mi (NAMER and CONUS domains only)
prob_vis_2mi (NAMER and CONUS domains only)
prob_vis_1mi (NAMER and CONUS domains only)
prob_ceil_1000ft (NAMER and CONUS domains only)
prob_ceil_2000ft (NAMER and CONUS domains only)
prob_ceil_3000ft (NAMER and CONUS domains only)
prob_ceil_6500ft (NAMER and CONUS domains only)
```

### version **56176** - released on 2025/06/08

* [FIX] some Nexrad radars were not properly identified as Nexrad as opposed to Tdwr
* [ADD] per *Service Change Notice 25-22 Migration of the Tropical Weather Summary Information from Text Product Format to hurricanes.gov: Effective on or about May 15, 2025*, remove these two text products from the main NHC activity
* [FIX] In NHC Activity remove images "EPAC Daily Analysis" and "ATL Daily Analysis" which no longer
  seem to be available

### version **56175** - released on 2025/04/18

* [FIX] NCEP Models were not working after NWS code change

### version **56174** - released on 2025/04/16

* [FIX] GOES animation on iOS 18 for products other then the default were not working
* [FIX] replace GOES 16 URLS with GOES 19, redirects were in place but better to avoid
* [FIX] NWS API requires Lat/Lon to not have a trailing "0" and to also not allow ".0", adjust LatLon.latForNws/lonForNws, also use UtilityDownloadNws.getLocationPointData in Location.getWfoRadarSiteFromPoint
* [ADD] Models - NCEP MAG comply with Service Change Notice 25-29 which consists of renaming some
  sectors for GEFS-WAVE, GFS-WAVE, and STOFS
* [ADD] in National Images -> CPC add Hawaiian Extended Range Outlooks per SCN25-16
* [ADD] option UI Preferences -> "Hourly screen: show with AM/PM"
* [FIX] OPC "Alaska/Arctic SST/Ice Edge Analysis" - image was no longer working, fix to use new URL
* [ADD] In National Images remove "experimental" from the label for "Week 3-4 Outlooks - Temperature" and "Week 3-4 Outlooks - Precipitation" per *SCN24-104: The Experimental Weeks 3-4 Precipitation Outlooks Will Become Operational on or about January 17, 2025*
* [ADD] "Prognostic Discussion for Week 3-4 Temperature and Precipitation Outlooks" in National Text Product Screen under **General Forecast Discussions**
* [FIX] some additional prognostic text outlooks were not working under iOS 18 and require a differnet download method
* [ADD] "Automated Low Clusters" in National Images per SCN24-108: Termination of the 72-Hour Low Tracks
  Graphic and the Non-Technical 72-Hour Low Tracks Graphic to be Replaced by Automated Low Clusters
  Forecast Tool: Effective January 20, 2025
* [FIX] In National Graphics the URL for **GLSEA Ice Analysis** had changed
* [FIX] add Mist, Light Mist in UtilityMetarConditions
* [FIX] allow save to camera roll in share

### version **56173** - released on 2025/1/21

* [ADD] geographic boundaries for US Virgin Islands and American Samoa
* [ADD] long press in nexrad will now show best vis sat image for Hawaii and areas around Puerto
  Rico
* [ADD] add Metars for Puerto Rico and US Virgin Islands
* [ADD] In hourly, abbreviate "Drizzle" to "Dz" instead of "Drz"
* [ADD] In the adhoc forecast page accessible via "long press" in Nexrad radar, include nearest city
  in at top of screen and if location is saved, a better name will be used.
* [FIX] National Images - show product button label if last image viewed is no longer accessible
* [ADD] In the main submenu under **Observations** add access to new images
  from [Unified Surface Analysis](https://ocean.weather.gov/unified_analysis.php), images jointly
  produced by NCEP, WPC, OPC, NHC, and HFO
* [ADD] per **PNS24-66 Updated** NWS will implement a fix in advance of Dec 22 for the NWS API, thus 7 day forecast is now configurable again and defaults to using the new NWS API
* [ADD] for getting current conditions for main screen do manual retry if needed (like 7-day/hourly)
* [ADD] option in **Settings->User Interface** called *Settings - toggle is on right side*. If you disable this the toggle will be to the left of the text description in settings. This might be helpful on larger screens.
* [ADD] In UsAlerts you can now tape the main image to open it in a dedicated image viewer which allows you to zoom in or share the image out via email.
* [ADD] Similar to SPC Convective Outlook outlines as a preference in Nexrad Radar, make SPC Fire Weather Outlook outlines available as well (BETA - no dry thunderstorm support yet)
* [ADD] Better "Weather Story" handling for image in homescreen (if configured and if your WFO
  offers it or something similar)
* [ADD] In Nexrad "long press" (press and hold), add Observation(Metar) site name next to the
  station code

### version **56172** - released on 2024/11/29

* [ADD] to Settings -> About -> "View data provider: NWS" (information on where data used in this application is sourced from)
* [FIX] app crash when nexrad configured on homescreen

### version **56171** - released on 2024/11/29

NOTE: There is the potential for an outage Dec 22 - Jan 1 for the NWS API servicing forecast and hourly data. This change forces 7 day forecast to use the older API. Since the Hourly forecast has different data elements depending on the API if an outage does in fact occur you will need to toggle the hourly source in Settings -> UI

* [FIX] ESRL models stopped working on iOS18 in the past 1-2 weeks, changed http get to decode UTF8
* [FIX] force 7 day forecast to use older NWS API due to expected outage per **PNS24-66: Potential API Gridded Forecast Data Outage from December 22, 2024 through January 1, 2025**

### version **56170** - released on 2024/11/16

* [FIX] on iOS18, Nexrad text products like TVS/STI/HI were not working, changed text decoder
* [ADD] additional Soundings sites (especially AK/HI), remove some that were obsolete
* [ADD] Nearest Sounding option to Nexrad "Long press" (press and hold) menu - added to bottom (includes direction)
* [ADD] Nexrad "Long press" - add show nearest vis satellite image at bottom
* [ADD] Nexrad "Long press" - add show nearest AFD (area forecast discussion text product)
* [ADD] Nexrad "Long press" - add show nearest SPC Meso sector
* [ADD] Nexrad "Long press" now shows direction in addition to distance for closest radars and observation point
* [ADD] NHC Storm card - show bearing after direction
* [FIX] Nexrad "Long press" - meteogram URL had changed

### version **56169** - released on 2024/10/19

* [ADD] NHC storm summary in NHC activity - show more headlines
* [FIX] SPC HREF was not working on iOS18

### version **56168** - released on 2024/10/10

* [ADD] as stated in [Upcoming changes](https://gitlab.com/joshua.tee/wxl23/-/blob/master/doc/UPCOMING_CHANGES.md) versions of iOS prior to iOS 15 will no longer be supported after 2024-10-01.
* [ADD] NHC Storm: add additional graphics "Peak Storm Surge Forecast" and "Cumulative Wind History"
* [FIX] NHC Storm: if text discussion is changed, WPC Text viewer will show that discussion when accessed from tab. Program should not use that as the last text product viewed.
* [FIX] SPC Compmap - remove product which is no longer available via the website: **3-hr surface pressure change**
* [FIX] SPC Compmap - change references from **HPC** to **WPC**
* [FIX] GOES "Full Disk" (Misc Tab) images location and product names have changed, animations are
  now available for all products. They have been
  moved here (there are many more Himawari images that have been added which are not yet
  incorporated):
    - [https://www.ospo.noaa.gov/products/imagery/meteosat.html](https://www.ospo.noaa.gov/products/imagery/meteosat.html)
    - [https://www.ospo.noaa.gov/products/imagery/meteosatio.html](https://www.ospo.noaa.gov/products/imagery/meteosatio.html)
    - [https://www.ospo.noaa.gov/products/imagery/fulldisk.html](https://www.ospo.noaa.gov/products/imagery/fulldisk.html)
* [FIX] per SCN24-66: Termination of the Day 3-7 Hemispheric Charts: Effective July 24, 2024, remove
  5 images in National Images -> Forecast Maps
* [FIX] remove some of the unhandled options in the share dialogue box
* [ADD] NCEP MAG [v5.1](https://mag.ncep.noaa.gov/version_updates.php):
    - Added the following new domains to NAEFS and GEFS-MEAN-SPRD:
        - Continental United States (CONUS)
        - Alaska
    - Added the following new products to RTMA:
        - Ceiling (ceiling -- not included for Guam)
        - Visibility (vis)

### version **56167** - released on 2024/07/28

* [ADD] NWS API is now the default for forecast (already was default for hourly)
* [ADD] 2nd retry for forecast download with new API
* [ADD] add 1 sec sleep in 2nd retry for hourly download with new API and increase min size
* [FIX] icons for NWS API were broken due to NWS issue, add workaround
* [FIX] SPC SWO Summary, onrestart original images would not clear leading to duplicate images
* [FIX] in **Settings -> About** remove **NWS Status** button. Users should access FAQ to see any app issues including links to NWS status. Also shorten verbiage to match android for FAQ label.
* [REF] per Service Change Notice 24-67 Decommissioning of w2.weather.gov on or about July 23, 2024, use new method to get Great Lakes open water forecasts
* [FIX] URL for **Weeks 2-3 Global Tropics Hazards Outlook (GTH)** had changed, this is accessed under **National Images -> CPC**
* [ADD] In nexrad activity, if you long press and GPS is enabled, it will show the distance from you, not your forecast location
* [FIX] The following text product was not working: High Seas Forecasts - SE Pacific
* [ADD] new text product "hfotwocp: CPAC Tropical Weather Outlook"


### version **56166** - released on 2024/05/11

* [FIX] Misc National Text - fix crash when accessing certain text products

### version **56165** - released on 2024/05/09

* [ADD] In support of **SCN24-02: New Forecast Product “Offshore Waters Forecast for SW N Atlantic Ocean”
  Will Start on March 26, 2024**
  add `offnt5` and rename title for `offnt3`. These products are accessed via "National Text"
  activity.
* [ADD] improvements in current conditions during iOS VoiceOver
* [FIX] if animating nexrad radar, then hit the stop button and switch to nexrad that is not current, the timestamp was not showing in red
* [FIX] For hourly data if initial downlload is to small, attempt again
* [ADD] Hourly, improve abbreviatons so that forecast does not wrap on phones

### version **56163** - released on 2024/03/26

* [ADD] add support for Nexrad "KHDC" for Service Change Notice 24-11 Hammond, LA WSR-88D (KHDC)
  to Begin NEXRAD Level III Product Dissemination on or around March 31, 2024.
  Product Dissemination on or around March 31, 2024
* [FIX]  (thanks to "ski warz" for noticing and providing fix) "Aviation only AFD" was not working
* [ADD] have spotter data match android in presentation
* [ADD] NCEP MAG updates [MAG 5.0 - March 2024](https://mag.ncep.noaa.gov/version_updates.php)
```
Added the following new domain to Global Forecast System (GFS):
  Pacific (PAC-REGION)
Renamed the following products to HREF:
  pmm_refd_1km → pmm_refd_1km_emsl
  pmm_refd_max → pmm_refd_max_emsl


 Added the following products to HREF:
    Ensemble Agreement Scale probability of 0.01” rain in 1 hour (eas_prob_1h_rain_0.01in)
    Ensemble Agreement Scale probability of 0.25” rain in 1 hour (eas_prob_1h_rain_0.25in)
    Ensemble Agreement Scale probability of 0.50” rain in 1 hour (eas_prob_1h_rain_0.50in)
    Ensemble Agreement Scale probability of 0.01” rain in 3 hours (eas_prob_3h_rain_0.01in)
    Ensemble Agreement Scale probability of 0.25” rain in 3 hours (eas_prob_3h_rain_0.25in)
    Ensemble Agreement Scale probability of 0.50” rain in 3 hours (eas_prob_3h_rain_0.50in)
    Ensemble Agreement Scale probability of 0.1” snow in 1 hour (eas_prob_1h_snow_0.1in)
    Ensemble Agreement Scale probability of 0.3” snow in 1 hour (eas_prob_1h_snow_0.3in)
    Ensemble Agreement Scale probability of 0.1” snow in 3 hours (eas_prob_3h_snow_0.1in)
    Ensemble Agreement Scale probability of 0.3” snow in 3 hours (eas_prob_1h_snow_0.1in)
    Localized probability matched mean mean precip 1 hour plot (lpmm_mean_precip_p01)
    Localized probability matched mean mean precip 3 hour plot (lpmm_mean_precip_p03)
    Localized probability matched mean mean precip total hour plot (lpmm_mean_precip_ptot)
    prob_lowIFR_IFR
    pmm_refd_1km
    pmm_refd_max

Added the following products to NAEFS:
    10th_percentile_10m_wnd
    50th_percentile_10m_wnd
    90th_percentile_10m_wnd
    extreme_index_10m_wnd
    10th_percentile_2m_temp
    50th_percentile_2m_temp
    90th_percentile_2m_temp
    extreme_index_2m_temp
    extreme_index_mslp
```

### version **56162** - released on 2023/12/04
* [FIX] KLIX (LA, New Orleans) nexrad radar is being physically moved.
  This update prevents it from being used as an active radar in long press radar
  selection or if adding a new location.
* [FIX] WPC US Hazards Outlook Days 3-7: product discontinued via SCN23-101: Termination of the Weather Prediction Center Day 3-7 Hazards Outlook Discussion Effective November 15, 2023
* [FIX] NHC storm detail - force to mph for wind intensity
* [REF] remove AWC Radar Mosaic as NWS has removed those images from the new AWS website
* [FIX] NWS changed some of the URLs for the SST images accessed in the NHC activity
* [FIX] In Nexrad radar if colormap legend enabled there is not enough space at the bottom for the back arrow on some phone models.
* [FIX] remove 3 obsolete Canadian text products in the National Text Viewer (MISC Tab)

### version **56161** - released on 2023/10/16
* [FIX] Nexrad windbarbs and observations in response to NWS planned AWC website
  upgrade: https://aviationweather.gov/

### version **56160** - released on 2023/09/30
* Add the following in the national image viewer (MISC Tab, 3nd Row, Middle)
```
   "WPC Day 4 Excessive Rainfall Outlook" (Under QPF)
   "WPC Day 5 Excessive Rainfall Outlook" (Under QPF)
   "Space Weather Overview" (Under Space Weather)
```
* Remove the following text products as they are no longer available in the national text product
  viewer (MISC Tab, 4th Row, Right)
```
    "offn11: Navtex Marine fcst for Kodiak, AK (SE)",
    "offn12: Navtex Marine fcst for Kodiak, AK (N Gulf)",
    "offn13: Navtex Marine fcst for Kodiak, AK (West)",

    "fxcn01_d1-3_west: Days 1 to 3 Significant Weather Discussion - West",
    "fxcn01_d4-7_west: Days 4 to 7 Significant Weather Discussion - West",
    "fxcn01_d1-3_east: Days 1 to 3 Significant Weather Discussion - East",
    "fxcn01_d4-7_east: Days 4 to 7 Significant Weather Discussion - East",
```

### version **56159** - released on 2023/09/06
* [ADD] NWS has issued change notification: SCN23-79: Upgrade of Aviation Weather Center Website on September 12, 2023
        This will cause temporary breakage in certain parts of the program such as Windbarbs and Observations in Nexrad and static aviation graphics.
        App updates will be issued as soon as possible after NWS moves over to the new website.
* [ADD] NHC Storm sharing now includes more content in the subject and text product included
* [FIX] NHC Storm rainfall graphic was not working after NWS URL change
* [ADD] NHC Storm add the 2nd rainfall graphic
* [ADD] SPC Thunderstorm Outlooks will now scale graphic size to match how many images are shown
* [ADD] Radar Mosaics are no longer pulled from the AWC Website which is due to be upgraded on Sep 12, 2023.
        It appears the mosaic graphics are no longer going to be provided so the default is to now use the graphics
        used prior to using AWC.

### version **56158** - released on 2023/08/??
* [FIX] SPC Conective outlook was not sharing images and text, only text
* [ADD] Severe Dashboard - don't show warning headers if count is 0 (similar to Android version)
* [FIX] CPAC long range graphic is now 7 days instead of 5 (as accessed via main NHC activity)
* [ADD] NWS has issued change notification: SCN23-79: Upgrade of Aviation Weather Center Website on September 12, 2023
        This will cause temporary breakage in certain parts of the program such as Windbarbs and Observations in Nexrad and static aviation graphics.
        App updates will be issued as soon as possible after NWS moves over to the new website.

### version **56157** - released on 2023/07/05
* [ADD] Ability to view state level SPC Convective Outlooks for Days 4 - 8
* [ADD] For all state level SPC Convective Outlooks show all products available. Reminder that you can tap on an image to view by itself or double tap to zoom in.
* [FIX] In dark mode, radar icon in Severe Dashboard and US Alerts now shows up

### version **56156** - released on 2023/06/14
* [FIX] NSSL WRF model activity was not working at all, remove FV3 which is no longer a supported model at this upstream site
* [ADD] SPC Mesoanalysis, add sectors Intermountain West and Great Lakes

### version **56155** - released on 2023/06/07
* [ADD] Excessive Rainfall Outlook activity (MISC Tab) now shows a Day 4 and Day 5 image. No dedicated text 
        product exists similar to Day1-Day3 and so discussion is included in the PMDEPD "Extended Forecast Discussion"
        more details here:
        [Service Change Notice 23-55](https://www.weather.gov/media/notification/pdf_2023_24/scn23-55_ero_days_4_5_t2o.pdf) and
        [NWS Product Description Document - PDD](https://www.weather.gov/media/notification/PDDs/PDD_ERO_Days_4_5_T2O.pdf)
* [ADD] NCEP MAG models (MISC Upper Left) update "MAG 4.0.0 - May 2023" described here [https://mag.ncep.noaa.gov/version_updates.php](https://mag.ncep.noaa.gov/version_updates.php)
* [FIX] NCEP MAG GFS-WAVE: corrections to some already existing labels
* [REF] deprecate Canada forecast data

### version **56154** - released on 2023/05/27
* [FIX] As communicated in the "upcoming changes" document in April 2022,
        Canadian local forecast support is being removed.
        In support of this the ability to add new Canadian locations is being disabled.

### version **56153** - released on 2023/05/25
* [FIX] NHC - replace retired 5 day outlooks with new 7 day outlooks

### version **56152** - released on 2023/05/23
* [FIX] Access to twitter content for state and tornado is no longer working and has been removed. Please access via your browser if needed.

### version **56151** - released on 2023/03/25
* [FIX] NWS SPC has changed the URL/format type for SPC MCD and thus code updates were required
* [FIX] SPC Meso Violent Tornado Parameter (VTP) was not working as SPC changed the product ID
* [FIX] NWS Has removed static graphic for space weather: Estimated Planetary K index
        and replaced with a web accessible version for this product at https://www.swpc.noaa.gov/products/planetary-k-index
        if you use this data you could access via a browser, etc

### version **56150** - released on 2023/01/22
* [FIX] Settings -> Location -> Edit - name/lat/lon were not editable. (reminder that if you change one of these fields you need to tap the check mark icon to make permanent)
* [ADD] NCEP Models (MISC Tab, upper left) has replaced model "ESTOFS" with "STOFS" (v1.1.1) per https://mag.ncep.noaa.gov/version_updates.php


### version **56149** - released on 2023/01/15
* [FIX] homescreen text products were not expanding/collapsing on single click


### version **56148** - released on 2023/01/05
* [ADD] Hourly using old API no longer shows the date, just weekday/hour similar to Hourly with new API
* [ADD] for some activities invoke an external browser intead of an embedded one (such as the map in NWS observations)
* [ADD] RTMA_TEMP (Real-Time Mesoscale Analysis) as a Homescreen option in the generic images menu

        more details on the product: [https://nws.weather.gov/products/viewItem.php?selrow=539](https://nws.weather.gov/products/viewItem.php?selrow=539)

        graphics are from here: [https://mag.ncep.noaa.gov/observation-type-area.php](https://mag.ncep.noaa.gov/observation-type-area.php)
* [REF] DownloadText - remove QPFPFD which is no longer produced by NWS and was removed from the UI some time ago
* [FIX] Spc Storm reports set min date for cal
* [ADD] Set minimum iOS version to 13.0
* [FIX] NSSL WRF (and other NSSL models) run only once per day, not twice
* [ADD] NCEP HREF now goes out to 48 hours (was 36)
* [FIX] from the national text product viewer remove the following which retired some time ago: "pmdsa: South American Synoptic Discussion"
* [ADD] remove option in Settings->UI, "GOES GLM for lightning (requires restart)". Lightning Maps is being phased out and is no longer an option.
* [ADD] SPC HREF: move reflectivity to new sub-group "Member Viewer"
* [FIX] NWS radar mosaic sector lat/lon SOUTHMISSVLY
* [ADD] long press radar status message shows nearest radar to where long press occurred - not radar currently selected
* [ADD] make "screen on" an option for TTS in text products
* [FIX] handle RSM (radar status message) better for terminal (air port) radars
* [FIX] hail icons are not sized properly on startup
* [FIX] Settings* complete alphabetizing (one or more off in radar)
* [FIX] SPC SWO Day X State graphic - don't show AK/HI in menu as SPC only covers CONUS
* [FIX] memory leak in nexrad radar
* [FIX] adhoc forecast via long press in nexrad was not showing correct sunrise/sunset data
* [ADD] new GOES sector: South Pacific
* [ADD] new GOES sector: Northern Atlantic
* [ADD] Settings->UI option to use Celsius in main screen current conditions / 7day
* [FIX] GOES sector: labels for US Pacific Coast and Tropical Pacific were switched
* [FIX] GOES - disable swipe left/right to change product. It's to easy to do this inadvertently.
* [ADD] NHC and Severe Dashboard - optimize downloads with a timer, if navigating to a child screen check downloads on return if needed
* [REF] main screen long press - revamp verbiage to match dedicated viewer
* [FIX] The following model is being removed from the program due to it's experimental nature and numerous breaking changes over the years:
        **it was accessible only via the NHC activity**: Great Lakes Coastal Forecasting System, GLCFS
        You can access it via a web browser here: https://www.glerl.noaa.gov/res/glcfs/
        As a reminder the best model interface in terms of stability continues to be MAG NCEP (MISC Tab - upper left)
        I believe all other models with interfaces provided are not considered true production services, please contact me if I am wrong


### version **56147** - released on 2022/09/17
* [FIX] update NWS Radar Mosaic URL in response to [PNS22-09](https://www.weather.gov/media/notification/pdf2/pns22-09_ridge_ii_public_local_standard_radar_pages_aaa.pdf)
* [FIX] NHC Storm images not working for atlantic storms

### version **56146** - released on 2022/08/25
* [ADD] (REVERT) Nexrad Level2: in response to 24+ hr maint on 2022-04-19 to nomands, change URL to backup
* [REF] in ForecastIcon, use system font instead of HelveticaNeue-Bold to make program more robust to future IOS versions
* [REF] in Hourly, use system font instead of fixed width courier to make program more robust to future IOS versions
* [ADD] framework for new NWS Mosaic (to replace AWC later this year), main menu
* [ADD] Option to use new NWS Radar Mosaic (restart required). This is a temporary option as it appears likely the default mosaic will switch to NWS (away from AWC) later this year
* [FIX] in settings->radar, add "SPC" to start of label "Day 1 Convective Outlook"
* [ADD] SPC Meso: under "Winter Weather" add "Winter Skew-T Maps" skewt-winter (not available in CONUS view)
* [ADD] NHC framework for Central Pacific hurr/ts
* [FIX] some text products in the national product viewer were not working

### version **56145** - released on 2022/07/03
* [FIX] prevent nexrad radar from showing stale SPC Convective outlook data
* [FIX] terminal radar TICH (Wichita, KS) was not properly coded (was TICT), it is now available for use

### version **56144** - released on 2022/04/16
* [ADD] Nexrad Level2: in response to 24+ hr maint on 2022-04-19 to nomands, change URL to backup
  - [https://www.weather.gov/media/notification/pdf2/scn22-35_nomads_outage_apr_aaa.pdf](https://www.weather.gov/media/notification/pdf2/scn22-35_nomads_outage_apr_aaa.pdf)
  - A [reminder](https://gitlab.com/joshua.tee/wxl23/-/blob/master/doc/FAQ.md#why-is-level-2-radar-not-the-default) on Level 2 support within wX


### version **56143** - released on 2022/03/06
* [ADD] Detect if location obs is more then 2 hours out of date, if so , show next closest
* [ADD] Models NCEP NAM, add sector "CONUS"
* [FIX] GOES GLM (lightning) animation was not working
* [FIX] NWS is deprecating this website on 3/22 (substitute NWS observation point, etc): https://www.wrh.noaa.gov/mesowest/timeseries.php?sid=KCAR
  in favor of: https://www.weather.gov/wrh/timeseries?site=KCAR
  Thus updated the activity accessed through the "MISC" tab to reflect this
* [FIX] bottom tab bar layout issue on larger devices
* [FIX] remove observation point KSTF (Starkville, MS) as it's impacting users.
* [FIX] remove decomissioned text products
  - "mimpac: Marine Weather disc for N PAC Ocean"
  - "mimatn: Marine disc for N Atlantic Ocean"

### version **56142** - released on 2021/11/27
* [FIX] GOES Viewer, eep Eastern East Pacific image was not working after NOAA changed image resolution
* [ADD] National Images - add "_conus" to end of filename for SNOW/ICE Day1-3 for better graphic
* [ADD] SPC HRRR - add back SCP/STP param
* [ADD] switch to non-experimental WPC winter weather forecasts day 4-7
* [ADD] SPC Meso in "Multi-Parameter Fields" add "Bulk Shear - Sfc-3km / Sfc-3km MLCAPE"
* [FIX] SPC Meso in "Upper Air" change ordering for "Sfc Frontogenesis" to match SPC website

### version **56141** - released on 2021/10/23
* FIX - navigation bottom bar was truncated on first launch for large iphone devices after compiling with xcode13

### version **56140** - released on 2021/10/21
* FIX - NWS html format changed caused 7 day forecast icons to break
* ChangeLog and FAQ now stored in gitlab and not google docs
* Add additional GOES products FireTemperature, Dust, GLM

