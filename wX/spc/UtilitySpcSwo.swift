// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class UtilitySpcSwo {

    // https://www.spc.noaa.gov/partners/outlooks/state/images/MS_swody1_TORN.png
    static func getSwoStateUrl(_ state: String, _ day: String) -> [String] {
        switch day {
        case "1", "2":
            return [
                GlobalVariables.nwsSPCwebsitePrefix + "/partners/outlooks/state/images/" + state + "_swody" + day + ".png",
                GlobalVariables.nwsSPCwebsitePrefix + "/partners/outlooks/state/images/" + state + "_swody" + day + "_TORN.png",
                GlobalVariables.nwsSPCwebsitePrefix + "/partners/outlooks/state/images/" + state + "_swody" + day + "_HAIL.png",
                GlobalVariables.nwsSPCwebsitePrefix + "/partners/outlooks/state/images/" + state + "_swody" + day + "_WIND.png"
                ]
        case "3":
            return [
                GlobalVariables.nwsSPCwebsitePrefix + "/partners/outlooks/state/images/" + state + "_swody" + day + ".png",
                GlobalVariables.nwsSPCwebsitePrefix + "/partners/outlooks/state/images/" + state + "_swody" + day + "_PROB.png"
                ]
        case "48":
            return [
                GlobalVariables.nwsSPCwebsitePrefix + "/partners/outlooks/state/images/" + state + "_swody" + "4" + "_PROB.png",
                GlobalVariables.nwsSPCwebsitePrefix + "/partners/outlooks/state/images/" + state + "_swody" + "5" + "_PROB.png",
                GlobalVariables.nwsSPCwebsitePrefix + "/partners/outlooks/state/images/" + state + "_swody" + "6" + "_PROB.png",
                GlobalVariables.nwsSPCwebsitePrefix + "/partners/outlooks/state/images/" + state + "_swody" + "7" + "_PROB.png",
                GlobalVariables.nwsSPCwebsitePrefix + "/partners/outlooks/state/images/" + state + "_swody" + "8" + "_PROB.png"
                ]
        default:
            return []
        }
    }

    static func getImageUrls(_ day: String, getAllImages: Bool = true) -> [Bitmap] {
        var urls = [String]()
        if day == "48" {
            urls = (4...8).map { GlobalVariables.nwsSPCwebsitePrefix + "/products/exper/day4-8/day" + String($0) + "prob.gif" }
            return urls.map { Bitmap($0) }
        }
        let html = (GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day" + day + "otlk.html").getHtml()
        let time = html.parseFirst("show_tab\\(.otlk_([0-9]{4}).\\)")
        switch day {
        case "1", "2":
            let baseUrl = GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day" + day + "probotlk_"
            urls.append(GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day" + day + "otlk_" + time + ".png")
            ["_torn.png", "_hail.png", "_wind.png"].forEach {
                urls.append(baseUrl + time + $0)
            }
        case "3":
            ["otlk_", "prob_"].forEach {
                urls.append(GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day" + day + $0 + time + ".png")
            }
        default:
            break
        }
        if getAllImages {
            return urls.map { Bitmap($0) }
        } else {
            return [Bitmap(urls[0])]
        }
    }

    static func getUrls(_ day: String) -> [String] {
        var urls = [String]()
        if day == "4-8" || day == "48" || day == "4" {
            (4...8).forEach {
                urls.append(GlobalVariables.nwsSPCwebsitePrefix + "/products/exper/day4-8/day" + To.string($0) + "prob.gif")
            }
            return urls
        } else {
            let html = (GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day" + day + "otlk.html").getHtml()
            let time = html.parse("show_tab\\(.otlk_([0-9]{4}).\\)")
            switch day {
            case "1", "2":
                let baseUrl = GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day" + day + "probotlk_"
                urls.append(GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day" + day + "otlk_" + time + ".png")
                let z1 = ["_torn.png", "_hail.png", "_wind.png"]
                for urlEnd in z1 {
                    urls.append(baseUrl + time + urlEnd)
                }
            case "3":
                let z2 = ["otlk_", "prob_"]
                for urlEnd in z2 {
                    urls.append(GlobalVariables.nwsSPCwebsitePrefix + "/products/outlook/day" + day + urlEnd + time + ".png")
                }
            default:
                break
            }
            return urls
        }
    }

    static func getImageUrlsDays48(_ day: String) -> String {
        GlobalVariables.nwsSPCwebsitePrefix + "/products/exper/day4-8/day" + day + "prob.gif"
    }
}
