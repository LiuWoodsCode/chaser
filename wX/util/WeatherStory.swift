// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class WeatherStory {

    static func getImageUrl() -> String {
        var productUrl = ""
        let site = Location.wfo.lowercased()
        var url = "https://www.weather.gov/\(site)/weatherstory"
        var html = UtilityIO.getStringFromUrlUtf8(url)
        var scrapeUrl = UtilityString.parseFirst(
            html,
            "src=.(https://www.weather.gov/?/images/.../wxstory/Tab.FileL.png). "
        )
        if scrapeUrl != "" {
            productUrl = scrapeUrl
        } else {
            scrapeUrl =
                UtilityString.parse(html, "a href=.(/images/\\w{3}/features/weatherstory.png).")
            if scrapeUrl != "" {
                productUrl = "https://www.weather.gov/\(scrapeUrl)"
            } else {
                scrapeUrl =
                    UtilityString.parse(
                        html,
                        "[=o].(/images/\\w{3}/[wW]eather[Ss]tory.(gif|jpg|png))."
                    )
                if scrapeUrl != "" {
                    productUrl = "https://www.weather.gov/\(scrapeUrl)"
                } else {
                    scrapeUrl =
                        UtilityString.parse(
                            html,
                            "img src=.(https://www.weather.gov/?/images/\\w{3}/WxStory/WeatherStory[1-9].png)."
                        )
                    if scrapeUrl != "" {
                        productUrl = scrapeUrl
                    } else {
                        scrapeUrl =
                            UtilityString.parse(
                                html,
                                "[= o].(/images/\\w{3}/[Ww]eather[Ss]tory/weatherstory.(png|gif))."
                            )
                        if scrapeUrl != "" {
                            productUrl = "https://www.weather.gov/\(scrapeUrl)"
                        } else {
                            url = "https://weather.gov/\(site)"
                            html = UtilityIO.getHtml(url)
                            let scrapeUrls1 = UtilityString.parseColumn(
                                html,
                                "src=.(https?://www.weather.gov/images/?/.../graphicast/\\S*?[0-9]{0,1}.png). "
                            )
                            let scrapeUrls2 = UtilityString.parseColumn(
                                html,
                                "src=.(https?://www.weather.gov/images/?/.../graphicast/\\S*?[0-9]{0,1}.jpg). "
                            )
                            let scrapeUrls3 = UtilityString.parseColumn(
                                html,
                                "src=.(https?://www.weather.gov/images/?/.../graphicast/\\S*?[0-9]{0,1}.gif). "
                            )
                            let scrapeUrlsAll = scrapeUrls1 + scrapeUrls2 + scrapeUrls3
                            if scrapeUrlsAll.count > 0 {
                                productUrl = scrapeUrlsAll[0]
                            } else {
                                let scrapeUrls = UtilityString.parseColumn(
                                    html,
                                    "src=.(https?://www.weather.gov/?/images/?/.../WxStory/\\S*?[0-9].png). "
                                )
                                if scrapeUrls.count > 0 {
                                    productUrl = scrapeUrls[0]
                                }
                            }
                        }
                    }
                }
            }
        }
        return productUrl
    }
}
