// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class DownloadText {

    static let useNwsApi = false

    static func byProduct(_ product: String) -> String {
        var text = ""
        if product == "AFDLOC" {
            text = byProduct("AFD" + Location.wfo.uppercased())
        } else if product == "HWOLOC" {
            text = byProduct("HWO" + Location.wfo.uppercased())
        } else if product == "HOURLY" {
            let textArr = UtilityHourly.get(Location.getCurrentLocation())
            text = textArr[0]
        } else if product == "SWPC3DAY" {
            text = (GlobalVariables.nwsSwpcWebSitePrefix + "/text/3-day-forecast.txt").getHtml()
        } else if product == "SWPC27DAY" {
            text = (GlobalVariables.nwsSwpcWebSitePrefix + "/text/27-day-outlook.txt").getHtml()
        } else if product == "SWPCWWA" {
            text = (GlobalVariables.nwsSwpcWebSitePrefix + "/text/advisory-outlook.txt").getHtml()
        } else if product == "SWPCHIGH" {
            text = (GlobalVariables.nwsSwpcWebSitePrefix + "/text/weekly.txt").getHtml()
        } else if product == "SWPCDISC" {
            text = (GlobalVariables.nwsSwpcWebSitePrefix + "/text/discussion.txt").getHtml()
        } else if product == "SWPC3DAYGEO" {
            text = (GlobalVariables.nwsSwpcWebSitePrefix + "/text/3-day-geomag-forecast.txt").getHtml()
        } else if product.contains("MIATCP") || product.contains("MIATCM")
            || product.contains("MIATCD") || product.contains("MIAPWS")
            || product.contains("MIAHS") || product.contains("HFOTCP") {
            let textUrl = "https://www.nhc.noaa.gov/text/" + product + ".shtml"
            text = textUrl.getHtmlUtf8()
//            text = textUrl.getHtmlSep()
            text = text.parse(GlobalVariables.pre2Pattern)
        } else if product.contains("MIAT") || product == "HFOTWOCP"
                    || product.hasPrefix("HFOTCP") || product.hasPrefix("HFOTCD")
                    || product.hasPrefix("HFOTCM") || product.hasPrefix("HFOPWS") {
            text = ("https://www.nhc.noaa.gov/ftp/pub/forecasts/discussion/" + product).getHtml()
            if product == "MIATWOAT"
                || product == "MIATWDAT" || product == "MIATWOEP"
                || product == "MIATWDEP" {
                text = text.replaceAll("<br><br>", "<BR><BR>")
                text = text.replaceAll("<br>", " ")
            }
        } else if product.hasPrefix("SCCNS") {
            let textUrl = GlobalVariables.nwsWPCwebsitePrefix + "/discussions/nfd" + product.lowercased().replace("ns", "") + ".html"
            text = textUrl.getHtml()
            text = UtilityString.extractPre(text)
        } else if product.contains("SPCMCD") {
            let no = product.substring(6)
            let textUrl = GlobalVariables.nwsSPCwebsitePrefix + "/products/md/md" + no + ".html"
            text = textUrl.getHtml()
            text = text.parse(GlobalVariables.pre2Pattern)
            text = text.removeLineBreaks().replaceAll("  ", " ")
        } else if product.contains("SPCWAT") {
            let no = product.substring(6)
            let textUrl = GlobalVariables.nwsSPCwebsitePrefix + "/products/watch/ww" + no + ".html"
            text = textUrl.getHtml()
            text = text.parseFirst(GlobalVariables.pre2Pattern)
            text = text.removeLineBreaks()
        } else if product == "FWDDY1" {
            let url = GlobalVariables.nwsSPCwebsitePrefix + "/products/fire_wx/fwdy1.html"
            text = url.getNwsHtml()
            text = UtilityString.extractPre(text).removeLineBreaks().removeHtml()
        } else if product == "FWDDY2" {
            let url = GlobalVariables.nwsSPCwebsitePrefix + "/products/fire_wx/fwdy2.html"
            text = url.getNwsHtml()
            text = UtilityString.extractPre(text).removeLineBreaks().removeHtml()
        } else if product == "FWDDY38" {
            let url = GlobalVariables.nwsSPCwebsitePrefix + "/products/exper/fire_wx/"
            text = url.getNwsHtml()
            text = UtilityString.extractPre(text).removeLineBreaks().removeHtml()
        } else if product.hasPrefix("GLF") {
            if product.lowercased() == "glfsc" {
                let url = "https://tgftp.nws.noaa.gov/data/raw/fz/fzus63.kdtx.glf.sc.txt"
                text = url.getNwsHtml()
            } else if product.lowercased() == "glfsl" {
                let url = "https://tgftp.nws.noaa.gov/data/raw/fz/fzus61.kbuf.glf.sl.txt"
                text = url.getNwsHtml()
            } else {
                let productType = product.substring(0, 3)
                let site = product.substring(3, 5)
                let url = "https://forecast.weather.gov/product.php?site=NWS&product=" + productType + "&issuedby=" + site
                let html = url.getNwsHtml()
                text = UtilityString.extractPreLsr(html).removeHtml()
            }
        } else if product.contains("QPF94E") {
            let textUrl = "https://www.wpc.ncep.noaa.gov/qpf/ero.php?opt=curr&day=" + "1"
            let html = textUrl.getHtml()
            text = UtilityString.extractPre(html).removeSingleLineBreaks().removeHtml()
        } else if product.contains("QPF98E") {
            let textUrl = "https://www.wpc.ncep.noaa.gov/qpf/ero.php?opt=curr&day=" + "2"
            let html = textUrl.getHtml()
            text = UtilityString.extractPre(html).removeSingleLineBreaks().removeHtml()
        } else if product.contains("QPF99E") {
            let textUrl = "https://www.wpc.ncep.noaa.gov/qpf/ero.php?opt=curr&day=" + "3"
            let html = textUrl.getHtml()
            text = UtilityString.extractPre(html).removeSingleLineBreaks().removeHtml()
        } else if product.contains("WPCMPD") {
            let no = product.substring(6)
            let textUrl = GlobalVariables.nwsWPCwebsitePrefix + "/metwatch/metwatch_mpd_multi.php?md=" + no
            text = textUrl.getHtml()
            text = text.parse(GlobalVariables.pre2Pattern)
            text = text.removeLineBreaks()
        } else if product.hasPrefix("GLF") && !product.contains("%") {
            text = byProduct(product + "%")
        } else if product.contains("FOCN45") {
            text = (GlobalVariables.tgftpSitePrefix + "/data/raw/fo/focn45.cwwg..txt").getHtml()
            text = text.removeLineBreaks()
        } else if product.hasPrefix("VFD") {
            let t2 = product.substring(3)
            text = (GlobalVariables.nwsAWCwebsitePrefix + "/api/data/fcstdisc?cwa=K" + t2 + "&type=afd").getNwsHtml()
        } else if product.hasPrefix("AWCN") {
            text = (GlobalVariables.tgftpSitePrefix + "/data/raw/aw/" + product.lowercased() + ".cwwg..txt").getHtml()
        } else if product == "HSFSP" {
            text = "https://tgftp.nws.noaa.gov/data/forecasts/marine/high_seas/south_hawaii.txt".getHtml().removeHtml()
        } else if product.contains("NFD") {
            text = (GlobalVariables.nwsOpcWebsitePrefix + "/mobile/mobile_product.php?id=" + product.uppercased()).getHtml().removeHtml()
        } else if product.contains("FWDDY38") {
            let textUrl = GlobalVariables.nwsSPCwebsitePrefix + "/products/exper/fire_wx/"
            text = textUrl.getHtml()
            text = text.parse(GlobalVariables.pre2Pattern)
        } else if product.contains("FPCN48") {
            text = (GlobalVariables.tgftpSitePrefix + "/data/raw/fp/fpcn48.cwao..txt").getHtml()
        } else if product.contains("OFF") || product == "UVICAC" || product == "RWRMX" || product.hasPrefix("TPT") {
            let productType: String
            let site: String
            if product.count == 5 {
                productType = product.substring(0, 3)
                site = product.substring(3, 5)
            } else {
                productType = product.substring(0, 3)
                site = product.substring(3, 6)
            }
            let url = "https://forecast.weather.gov/product.php?site=NWS&issuedby=" + site + "&product=" + productType + "&format=txt&version=1&glossary=0"
            let html = url.getNwsHtml()
            text = UtilityString.extractPreLsr(html)
        } else if product.contains("WEEK34") {
            // https://www.cpc.ncep.noaa.gov/products/predictions/WK34/index.php
            let textUrl = "https://www.cpc.ncep.noaa.gov/products/predictions/WK34/texts/week34fcst.txt"
            text = textUrl.getHtmlUtf8()
            text = text.removeHtml()
          } else if product.contains("PMD30D") {
            let textUrl = "https://tgftp.nws.noaa.gov/data/raw/fx/fxus07.kwbc.pmd.30d.txt"
            text = textUrl.getHtmlUtf8()
            text = text.removeLineBreaks()
        } else if product.contains("PMD90D") {
            let textUrl = "https://tgftp.nws.noaa.gov/data/raw/fx/fxus05.kwbc.pmd.90d.txt"
            text = textUrl.getHtmlUtf8()
            text = text.removeLineBreaks()
        } else if product.contains("PMDHCO") {
            let textUrl = "https://tgftp.nws.noaa.gov/data/raw/fx/fxhw40.kwbc.pmd.hco.txt"
            text = textUrl.getHtmlUtf8()
        } else if product.contains("USHZD37") {
            text = "product discontinued via SCN23-101: Termination of the Weather Prediction Center Day 3-7 Hazards Outlook Discussion Effective November 15, 2023"
        } else if product.hasPrefix("RTP") && product.count == 5 {
            let productType = product.substring(0, 3)
            let location = product.substring(3, 5)
            let url = GlobalVariables.nwsApiUrl + "/products/types/" + productType + "/locations/" + location
            let html = url.getNwsHtml()
            let urlProd = GlobalVariables.nwsApiUrl + "/products/" + html.parseFirst("\"id\": \"(.*?)\"")
            let prodHtml = urlProd.getNwsHtml()
            text = prodHtml.parseFirst("\"productText\": \"(.*?)\\}")
            text = text.replace("\\n", "\n")
        } else if product.hasPrefix("FTM") {
            let radarSite = product.substring(3, 6)
            let url = "https://forecast.weather.gov/product.php?site=NWS&product=FTM&issuedby=" + radarSite
            text = url.getHtml()
            text = UtilityString.extractPreLsr(text)
            text = text.replace("<br>", "\n")
        } else if product.hasPrefix("RWR") || product.hasPrefix("RTP") {
            let productType = product.substring(0, 3)
            let location = product.substring(3).replace("%", "")
            let locationName = WfoSites.sites.byCode[location]!.fullName  // UtilityLocation.getWfoSiteName(location)
            var site = locationName.split(",")[0]
            if product.hasPrefix("RTP") {
                site = location
            }
            let url = "https://forecast.weather.gov/product.php?site=" + location + "&issuedby=" + site + "&product=" + productType
            // https://forecast.weather.gov/product.php?site=ILX&issuedby=IL&product=RWR
            text = url.getHtml()
            text = UtilityString.extractPreLsr(text)
            text = text.replace("<br>", "\n")
        } else if product.hasPrefix("CLI") {
            let location = product.substring(3, 6).replace("%", "")
            let wfo = product.substring(6).replace("%", "")
            text = ("https://forecast.weather.gov/product.php?site=" + wfo + "&product=CLI&issuedby=" + location).getHtml()
            text = UtilityString.extractPreLsr(text)
            text = text.replace("<br>", "\n")
        } else {
            let t1 = product.substring(0, 3)
            let t2 = product.substring(3).replace("%", "")
            // Feb 8 2020 Sat
            // The NWS API for text products has been unstable Since Wed Feb 5
            // resorting to alternatives
            if useNwsApi {
                let html = ("https://api.weather.gov/products/types/" + t1 + "/locations/" + t2).getNwsHtml()
                let urlProd = "https://api.weather.gov/products/" + html.parseFirst("\"id\": \"(.*?)\"")
                let prodHtml = urlProd.getNwsHtml()
                text = prodHtml.parseFirst("\"productText\": \"(.*?)\\}")
                if !product.hasPrefix("RTP") {
                    text = text.replace("\\n\\n", "\n")
                    text = text.replace("\\n", " ")
                } else {
                    text = text.replace("\\n", "\n")
                }
            } else {
                switch product {
                case "SWOMCD":
                    let url = "https://forecast.weather.gov/product.php?site=NWS&issuedby=MCD&product=SWO&format=CI&version=1&glossary=1"
                    let html = url.getNwsHtml()
                    text = UtilityString.extractPreLsr(html).removeLineBreaks().removeHtml().removeDuplicateSpaces()
                case "SWODY1":
                    let url = GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day1otlk.html"
                    let html = url.getNwsHtml()
                    text = UtilityString.extractPreLsr(html).removeLineBreaks().removeHtml().removeDuplicateSpaces()
                case "SWODY2":
                    let url = GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day2otlk.html"
                    let html = url.getNwsHtml()
                    text = UtilityString.extractPreLsr(html).removeLineBreaks().removeHtml().removeDuplicateSpaces()
                case "SWODY3":
                    let url = GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day3otlk.html"
                    let html = url.getNwsHtml()
                    text = UtilityString.extractPreLsr(html).removeLineBreaks().removeHtml().removeDuplicateSpaces()
                case "SWOD48":
                    let url = GlobalVariables.nwsSPCwebsitePrefix + "/products/exper/day4-8/"
                    let html = url.getNwsHtml()
                    text = UtilityString.extractPreLsr(html).removeLineBreaks().removeHtml().removeDuplicateSpaces()
                case "PMDSPD", "PMDEPD", "PMDHMD", "PMDHI", "PMDAK", "QPFERD", "QPFHSD":
                    let url = GlobalVariables.nwsWPCwebsitePrefix + "/discussions/hpcdiscussions.php?disc=" + product.lowercased()
                    let html = url.getNwsHtml()
                    text = UtilityString.extractPreLsr(html).removeLineBreaks().removeHtml()
                case "PMDSA":
                    let url = GlobalVariables.nwsWPCwebsitePrefix + "/discussions/hpcdiscussions.php?disc=fxsa20"
                    let html = url.getNwsHtml()
                    text = UtilityString.extractPreLsr(html).removeLineBreaks().removeHtml()
                case "PMDCA":
                    let url = GlobalVariables.nwsWPCwebsitePrefix + "/discussions/hpcdiscussions.php?disc=fxca20"
                    let html = url.getNwsHtml()
                    text = UtilityString.extractPreLsr(html).removeLineBreaks().removeHtml()
                case "PMDMRD":
                    let textUrl = GlobalVariables.tgftpSitePrefix + "/data/raw/fx/fxus06.kwbc.pmd.mrd.txt"
                    text = textUrl.getNwsHtml()
                case "PMDTHR":
                    let url = GlobalVariables.nwsCPCNcepWebsitePrefix + "/products/predictions/threats/threats.php"
                    text = url.getNwsHtml()
                    text = text.parse("<div id=\"discDiv\">(.*?)</div>").replace("<br>", GlobalVariables.newline).removeHtml()
                default:
                    // https://forecast.weather.gov/product.php?site=DTX&issuedby=DTX&product=AFD&format=txt&version=1&glossary=0
                    let urlToGet = "https://forecast.weather.gov/product.php?site=" + t2 + "&issuedby=" + t2 + "&product=" + t1 + "&format=txt&version=1&glossary=0"
                    let prodHtmlFuture = urlToGet.getNwsHtml()
                    if product.hasPrefix("RTP") ||
                        product.hasPrefix("LSR") ||
                        product.hasPrefix("ESF") ||
                        product.hasPrefix("NSH") ||
                        product.hasPrefix("PNS") ||
                        product.hasPrefix("RVA") {
                        text = UtilityString.extractPreLsr(prodHtmlFuture)
                    } else {
                        text = UtilityString.extractPreLsr(prodHtmlFuture).removeLineBreaks()
                    }
                }
            }
        }
        UtilityPlayList.checkAndSave(product, text)
        return text
    }

    static func getTextProductWithVersion(_ product: String, _ version: Int) -> String {
        let prodLocal = product.uppercased()
        let t1 = prodLocal.substring(0, 3)
        let t2 = prodLocal.substring(3)
        let textUrl = "https://forecast.weather.gov/product.php?site=NWS&product=" + t1 + "&issuedby=" + t2 + "&version=" + String(version)
        var text = textUrl.getHtml()
        text = text.parse(GlobalVariables.prePattern)
        text = text.replace("Graphics available at <a href=\"/basicwx/basicwx_wbg.php\">" + "<u>www.wpc.ncep.noaa.gov/basicwx/basicwx_wbg.php</u></a>", "")
        text = text.replaceAll("^<br>", "")
        if t1 != "RTP" {
            text = text.removeLineBreaks()
        }
        return text
    }
}
