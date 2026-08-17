// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class UtilityNhc {

    static let textProductCodes = [
        "MIATWOAT",
        "MIATWDAT",
        "MIATWOEP",
        "MIATWDEP",
        "HFOTWOCP"
    ]

    static let textProductLabels = [
        "ATL Tropical Weather Outlook",
        "ATL Tropical Weather Discussion",
        "EPAC Tropical Weather Outlook",
        "EPAC Tropical Weather Discussion",
        "CPAC Tropical Weather Outlook"
    ]

    static let imageTitles = [
        "EPAC Daily SST Analysis",
        "ATL Daily SST Analysis",
        "EPAC SST Anomaly",
        "ATL SST Anomaly"
    ]

    static let imageUrls = [
        GlobalVariables.nwsNhcWebsitePrefix + "/tafb/sst_loop/14_pac.png",
        GlobalVariables.nwsNhcWebsitePrefix + "/tafb/sst_loop/14_atl.png",
        GlobalVariables.nwsNhcWebsitePrefix + "/tafb/sst_loop/14_pac_anom.png",
        GlobalVariables.nwsNhcWebsitePrefix + "/tafb/sst_loop/14_atl_anom.png"
    ]
}
