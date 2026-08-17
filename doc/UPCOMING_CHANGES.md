[TOC]

# Upcoming changes that will impact some or all users / List of priority services

Last updated: 2025-11-08

## Changes
  - (added 2022-04-02) **JNI/Native decode (Android only)** - The option **"Use JNI for radar (beta)"** will be removed after **2022-12-31**. This option was useful +5 years ago when device were not as powerful. It is not recommended to use anymore because it has more bugs, is harder to troubleshoot, confuses users who accidentally turn it on, etc.
  - (added 2022-04-02/updated 2024-04-03) **Level2 if NWS offers Level3 SuperRes on TGFTP** It appears possible (but unlikely at this time) in the future that NWS will offer new Level 3 SuperRes products. If that happens, wX will drop using the existing Level2 files and use the new Level3 ones. For users there won't be much difference other then a substantially smaller download, faster decoding, faster animation, and additional tilts availble. More preliminary information available [here](https://www.weather.gov/media/notification/pdf2/scn21-96_sbn_super-res.pdf).
  - versions of **Android prior to Android 10.0 (API 29) will no longer be supported** after **2026-10-01**. (added 2024-09-26)
  - versions of **Android prior to Android 11.0 (API 30) will no longer be supported** after **2027-10-01**. (added 2025-11-08)
  - versions of **iOS prior to iOS 16 will no longer be supported** after **2026-10-01**. (added 2025-11-08)

## Completed changes
  - versions of **Android prior to Android 9.0 (API 28) will no longer be supported** after **2025-10-01**. (added 2023-12-20)
  - (added 2022-09-01/update 2023-10-26/completed 2024-04-03) **wX Android screen recording will not be available after May 1, 2024** Please use native [screen recording](https://support.google.com/pixelphone/answer/2811098?hl=en) and screen shot capabilities instead. This existing functinality does not fall within Google's accepted "Foreground Service Type" once the app targets API34 (Android 14) which is required by sometime later in 2024.
  - (added 2022-08-17) Android version will have the option **Icons evenly spaced** removed in **Settings->UI**. This was meant to be a bridge from Android 4.4 to Android 5.0 back in Fall 2014. It goes against modern Android design and has caused issues in the past for users who have unknowingly enabled it. This removal will occur **after 2023-12-31** or sooner if the need arises.
  - (completed Nov 2023) after support for Android 7.1 is removed, the option **Settings->Radar->Launch app directly to radar** will be removed since Android 8.0 and higher supports *static pinned launchers* i.e. if you long press on the app icon in the android home screen you can launch the radar directly and also setup another icon to do so.
  - (added 2022-04-02, completed Fall 2023 after NWS AWC website was changed) **NWS Radar Mosaic** provided might change from AWC back to the standard NWS. This will likely occur sometime in 2022 and is due to a possible redesign of the AWC website which appears to no longer offer the mosaic images. The images to be used should be familiar, example [one](https://radar.weather.gov/ridge/lite/SOUTHEAST_0.gif) and [CONUS](https://radar.weather.gov/ridge/lite/CONUS-LARGE_0.gif). Downside is the other AWC products available in the Mosaic viewer will not be available.
  - (added 2023-09-10) **wX Android setting "Radar with transparent toolbars"** will be retired after 2024-09-10
  - (added 2023-09-10) **wX Android setting "Radar with transparent status bar"** will be retired after 2024-09-10
  - (added 2023-09-10) **wX Android setting "Radar: immersive mode"** will be retired after 2024-09-10
  - (added 2023-09-10) **wX Android setting "Main screen radar button (requires restart)"** will be retired after 2024-09-10
  - versions of **Android prior to Android 8.1 (API 27) will no longer be supported** after **2024-10-01**.
  - versions of **Android prior to Android 7.1 will no longer supported** after **2023-10-01**.
  - versions of **Android prior to Android 6.0 will no longer supported** after **2022-10-01**.
  - versions of **iOS prior to iOS 15 will no longer be supported** after **2024-10-01**. (added 2023-12-20)
  - versions of **iOS prior to iOS 13.0 will no longer be supported** after **2022-12-31**.
  - (added 2022-04-02) **Android version will have entries in Settings alphabetized** similar to how iOS version currently is. This may occur **in 2022 or later**.
  - (added 2022-04-02) static **lightning maps from the provider of https://map.blitzortung.org/** will no longer exist as an option to promote the ongoing effort to only use NWS as a data provider. This will occur **after 2022-12-31** unless something necessitates thsi sooner. It is no longer the default as of late last year.
  - (added 2023-05-24) Twitter embedded content was removed as it was no longer working without username/pw and it conflicts with the goal of only using NOAA/NWS data.
  - (added 2022-04-02) Support for most **Canadian weather products** will be removed after **2023-12-31** or sooner if their is API breakage or something else necessitates this removal. Certain weather text products available on NWS servers may continue to be offered. Background: Since this program was started, Environment Canada has now offered an Android Weather app. In addition, another Android Nexrad decoder (paid) offers robust support for Canada binary radar data (which is not freely available and thus not used by wX). EC stopped offered static radar images a few years ago so the existing Canadian products are dwindling. My recommendation if you are using wX for this purpose is to migrate to other solutions. Canadian weather product support was offered as a courtesy initially for those storm chasing north of the border in the Candian prairies, etc. It is not part of the **priority services** listed below. (2023-06-01 update) Ability to add new locations will be disabled. (2023-06-23) Canadian support is now removed.
  - (added 2022-08-17) Android version will have the option **Models: use FAB** removed for single image views. Disabling does not provide a good experience. This will occur **after 2022-12-31**.
  - (added 2022-09-09) versions of **iOS prior to iOS 11.0 will no longer be supported** after **2022-09-14**. Unfortunately Apple's development environment "Xcode" is dropping support for prior versions with latest version.
  - (added 2022-09-01) **wX Android settings "Prevent accidental exit" will be removed** the settings where you need to hit the back button twice from the main screen (in Settings->UI) will be retired before 2023-09-01 due to Google's long term strategy for the back button outlined [here](https://developer.android.com/guide/navigation/predictive-back-gesture)

NOTE: Feel free to email me (my email is displayed in the app itselt in settings->About) and comment about these changes (before the date indicated above) and I will take it into consideration. Please note that it might not change the final outcome. The source code continues to be availabe to all. These changes will allow my limited time to focus on things that benefit the majority of users.

## wX Priority services - these areas continue to be the main focus for the program
  - nexrad level 3 viewer with layers (warnings, watch, mcd/mpd, etc)
  - GOES (ie vis/wv) images
  - local text products like AFD and HWO
  - "Severe Dashboard" the collection of MCD/MPD/Watch/US Alerts/Storm reports/warnings accessible from toolbar
  - SPC
    1. SPC Convective outlook
    1. SPC Fireweather outlooks
    1. SPC Thunderstorm outlook graphics
    1. SPC MCD / Watch
    1. SPC Mesoanalysis (not SPC compmap)
    1. SPC SREF/HREF (not HRRR)
    1. SPC collection of local office storm reports
    1. Sounding images as long as SPC offers them
  - WPC
    1. MPD (precip disc)
    1. Images (Fronts, QPF, Rainfall outlook, etc)
    1. Text products
  - NHC
  - Models
    1. NCEP MAG
    1. not ESRL and other less used or non-PROD models
  - 7 Day and hourly as a convience (because most weather apps offer them)

**NOTE: Widgets/Notifications availabe only in Android will be maintained as much as possible but are not specifically included in the priority above. Supporting widgets and notifications over the years has been unecessarily difficult due to changes by the Platform provider. Further, the Nexrad Widget is not recommended for usage unless you know it's reliably working for you. The radar mosaic would be a better choice.**

NOTE: Notable things missing in the list above:
* Vis images not accessible via the new GOES website, specifcally VIS images from other parts of the world (I don't have absolute confidence NWS will keep these around).
* Distance tool / Drawing tool in nexrad radar



