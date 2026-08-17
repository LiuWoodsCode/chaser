// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class DownloadImage {

    static func byProduct(_ product: String) -> Bitmap {
        var url = ""
        var bitmap = Bitmap()
        var needsBitmap = true
        switch product {
        case "GOES16":
            needsBitmap = false
            bitmap = UtilityGoes.getImage(Utility.readPref("GOES16_PROD", "02"), Utility.readPref("GOES16_SECTOR", "cgl"))
        case "VIS_CONUS":
            needsBitmap = false
            bitmap = UtilityGoes.getImage("GEOCOLOR", "CONUS")
        case "WEATHERSTORY":
            url = WeatherStory.getImageUrl()
        case "RTMA_DEW":
            url = UtilityRtma.getUrlForHomeScreen("2m_dwpt")
        case "RTMA_TEMP":
            url = UtilityRtma.getUrlForHomeScreen("2m_temp")
        case "RTMA_WIND":
            url = UtilityRtma.getUrlForHomeScreen("10m_wnd")
        case "WFOWARNINGS":
            needsBitmap = false
            bitmap = Bitmap("https://www.weather.gov/wwamap/png/" + Location.wfo.lowercased() + ".png")
        case "RAD_2KM":
            url = UtilityRadarMosaic.get(UtilityRadarMosaic.getNearest(Location.latLon))
        case "USWARN":
            url = "https://forecast.weather.gov/wwamap/png/US.png"
        case "AKWARN":
            url = "https://forecast.weather.gov/wwamap/png/ak.png"
        case "HIWARN":
            url = "https://forecast.weather.gov/wwamap/png/hi.png"
        case "FMAPD1":
            url = GlobalVariables.nwsWPCwebsitePrefix + "/noaa/noaad1.gif"
        case "FMAPD2":
            url = GlobalVariables.nwsWPCwebsitePrefix + "/noaa/noaad2.gif"
        case "FMAPD3":
            url = GlobalVariables.nwsWPCwebsitePrefix + "/noaa/noaad3.gif"
        case "FMAP12":
            url = GlobalVariables.nwsWPCwebsitePrefix + "/basicwx/92fwbg.gif"
        case "FMAP24":
            url = GlobalVariables.nwsWPCwebsitePrefix + "/basicwx/94fwbg.gif"
        case "FMAP36":
            url = GlobalVariables.nwsWPCwebsitePrefix + "/basicwx/96fwbg.gif"
        case "FMAP48":
            url = GlobalVariables.nwsWPCwebsitePrefix + "/basicwx/98fwbg.gif"
        case "FMAP72":
            url = GlobalVariables.nwsWPCwebsitePrefix + "/medr/display/wpcwx+frontsf072.gif"
        case "FMAP96":
            url = GlobalVariables.nwsWPCwebsitePrefix + "/medr/display/wpcwx+frontsf096.gif"
        case "FMAP120":
            url = GlobalVariables.nwsWPCwebsitePrefix + "/medr/display/wpcwx+frontsf120.gif"
        case "FMAP144":
            url = GlobalVariables.nwsWPCwebsitePrefix + "/medr/display/wpcwx+frontsf144.gif"
        case "FMAP168":
            url = GlobalVariables.nwsWPCwebsitePrefix + "/medr/display/wpcwx+frontsf168.gif"
        case "FMAP3D":
            url = GlobalVariables.nwsWPCwebsitePrefix + "/medr/9jhwbg_conus.gif"
        case "FMAP4D":
            url = GlobalVariables.nwsWPCwebsitePrefix + "/medr/9khwbg_conus.gif"
        case "FMAP5D":
            url = GlobalVariables.nwsWPCwebsitePrefix + "/medr/9lhwbg_conus.gif"
        case "FMAP6D":
            url = GlobalVariables.nwsWPCwebsitePrefix + "/medr/9mhwbg_conus.gif"
        case "QPF1":
            url = GlobalVariables.nwsWPCwebsitePrefix + "/qpf/fill_94qwbg.gif"
        case "QPF2":
            url = GlobalVariables.nwsWPCwebsitePrefix + "/qpf/fill_98qwbg.gif"
        case "QPF3":
            url = GlobalVariables.nwsWPCwebsitePrefix + "/qpf/fill_99qwbg.gif"
        case "QPF1-2":
            url = GlobalVariables.nwsWPCwebsitePrefix + "/qpf/d12_fill.gif"
        case "QPF1-3":
            url = GlobalVariables.nwsWPCwebsitePrefix + "/qpf/d13_fill.gif"
        case "QPF4-5":
            url = GlobalVariables.nwsWPCwebsitePrefix + "/qpf/95ep48iwbg_fill.gif"
        case "QPF6-7":
            url = GlobalVariables.nwsWPCwebsitePrefix + "/qpf/97ep48iwbg_fill.gif"
        case "QPF1-5":
            url = GlobalVariables.nwsWPCwebsitePrefix + "/qpf/p120i.gif"
        case "QPF1-7":
            url = GlobalVariables.nwsWPCwebsitePrefix + "/qpf/p168i.gif"
        case "WPC_ANALYSIS":
            url = GlobalVariables.nwsWPCwebsitePrefix + "/images/wwd/radnat/NATRAD_24.gif"
        case "SWOD1":
            needsBitmap = false
            bitmap = UtilitySpcSwo.getImageUrls("1", getAllImages: false)[0]
        case "SWOD2":
            needsBitmap = false
            bitmap = UtilitySpcSwo.getImageUrls("2", getAllImages: false)[0]
        case "SWOD3":
            needsBitmap = false
            bitmap = UtilitySpcSwo.getImageUrls("3", getAllImages: false)[0]
        case "SPCMESO1":
            let param = "500mb"
            needsBitmap = false
            bitmap = UtilitySpcMesoInputOutput.getImage(param, Utility.readPref("SPCMESO" + String(1) + "_SECTOR_LAST_USED", UtilitySpcMeso.defaultSector))
        case "SPCMESO_500":
            let param = "500mb"
            needsBitmap = false
            bitmap = UtilitySpcMesoInputOutput.getImage(param, Utility.readPref("SPCMESO" + String(1) + "_SECTOR_LAST_USED", UtilitySpcMeso.defaultSector))
        case "SPCMESO_MSLP":
            let param = "pmsl"
            needsBitmap = false
            bitmap = UtilitySpcMesoInputOutput.getImage(param, Utility.readPref("SPCMESO" + String(1) + "_SECTOR_LAST_USED", UtilitySpcMeso.defaultSector))
        case "SPCMESO_TTD":
            let param = "ttd"
            needsBitmap = false
            bitmap = UtilitySpcMesoInputOutput.getImage(param, Utility.readPref("SPCMESO" + String(1) + "_SECTOR_LAST_USED", UtilitySpcMeso.defaultSector))
        case "SPCMESO_RGNLRAD":
            let param = "rgnlrad"
            needsBitmap = false
            bitmap = UtilitySpcMesoInputOutput.getImage(param, Utility.readPref("SPCMESO" + String(1) + "_SECTOR_LAST_USED", UtilitySpcMeso.defaultSector))
        case "SPCMESO_LLLR":
            let param = "lllr"
            needsBitmap = false
            bitmap = UtilitySpcMesoInputOutput.getImage(param, Utility.readPref("SPCMESO" + String(1) + "_SECTOR_LAST_USED", UtilitySpcMeso.defaultSector))
        case "SPCMESO_LAPS":
            let param = "laps"
            needsBitmap = false
            bitmap = UtilitySpcMesoInputOutput.getImage(param, Utility.readPref("SPCMESO" + String(1) + "_SECTOR_LAST_USED", UtilitySpcMeso.defaultSector))
        case "CONUSWV":
            needsBitmap = false
            bitmap = UtilityGoes.getImage("09", "CONUS")
        case "LTG":
            needsBitmap = false
            bitmap = UtilityGoes.getImage("GLM", "CONUS")
        case "SND":
            let nwsOffice = SoundingSites.sites.getNearest(Location.latLon)
            needsBitmap = false
            bitmap = UtilitySpcSoundings.getImage(nwsOffice)
        case "STRPT":
            url = GlobalVariables.nwsSPCwebsitePrefix + "/climo/reports/today.gif"
        default:
            bitmap = Bitmap()
            needsBitmap = false
        }
        if needsBitmap {
            bitmap = Bitmap(url)
        }
        return bitmap
    }
}
