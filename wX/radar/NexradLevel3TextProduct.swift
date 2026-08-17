// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class NexradLevel3TextProduct {

    // encoding is ISO-8859-1
    static func download(_ product: String, _ radarSite: String) -> String {
        let url = NexradDownload.getRadarFileUrl(radarSite, product, false)
        let byteArray = url.getDataFromUrl()
        var data = ""
        if let retStr1 = String(data: byteArray, encoding: .isoLatin1) { // was .ascii
            data = retStr1
        }
        return data
    }
}
