// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class Forecast {

    let name: String
    let shortForecast: String
    let detailedForecast: String

    init(
        _ name: String,
        _ temperature: String,
        _ windSpeed: String,
        _ windDirection: String,
        _ icon: String,
        _ shortForecast: String,
        _ detailedForecast: String
    ) {
        self.name = name
        self.shortForecast = shortForecast
        self.detailedForecast = detailedForecast
    }
}
