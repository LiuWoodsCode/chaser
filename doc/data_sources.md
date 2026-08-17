[TOC]

# All data used in wX and wXL23  originates from the National Weather Service (NWS)
All data used in **wX** and **wXL23** (and associated desktop ports) originates from the [National Weather Service (NWS)](https://www.weather.gov/) 
which is part of [National Oceanic and Atmospheric Administration (NOAA)](https://www.noaa.gov/) 
which falls under [US Department of Commerce (DOC)](https://www.commerce.gov/). 
This data is in the *public domain* as specified at [Use of NOAA/NWS Data and Products](https://www.weather.gov/disclaimer/). 
Please view [Use of NOAA/NWS Data and Products](https://www.weather.gov/disclaimer/) for full details. 
More details on the NWS including it's history can be found at the [National Weather Service's About page](https://www.weather.gov/about/) and at 
* [National Weather Service - Wikipedia](https://en.wikipedia.org/wiki/National_Weather_Service)
* [National Oceanic and Atmospheric Administration - Wikipedia](https://en.wikipedia.org/wiki/National_Oceanic_and_Atmospheric_Administration)
* [United States Department of Commerce - Wikipedia](https://en.wikipedia.org/wiki/United_States_Department_of_Commerce)

The one exception is **Spotter data** which originates from [Spotter Network](https://www.spotternetwork.org/).

## [Wikipedia: NOAA under the second presidency of Donald Trump](https://en.wikipedia.org/wiki/NOAA_under_the_second_presidency_of_Donald_Trump)

## NWS in the news (Feb-Jul 2025)
* [NPR: Trump administration layoffs hit NOAA, agency that forecasts weather, hurricanes](https://www.npr.org/2025/02/27/nx-s1-5298738/trump-administration-layoffs-hit-noaa-the-agency-that-forecasts-weather-and-hurricanes)
  - NPR, by Alejandra Borunda, Michael Copley, Lauren Sommer, Hansi Lo Wang, Feb 27, 2025
* [The US faces ‘devastating’ losses for weather forecasts, federal workers say](https://www.theverge.com/news/622990/trump-doge-government-layoffs-doge-weather-forecasts-noaa)
  - The Verge, by Justine Calma, March 3, 2025
* [NOAA Hurricane Hunter layoffs threaten to degrade hurricane forecasts](https://yaleclimateconnections.org/2025/03/noaa-hurricane-hunter-layoffs-threaten-to-degrade-hurricane-forecasts/)
  - Yale Climate Connections, by Jeff Masters, March 6, 2025
* [Trump administration cancels disaster training for meteorologists amid staffing, travel cuts](https://thehill.com/policy/energy-environment/5189128-trump-administration-cancels-disaster-training-national-weather-service-meteorologists/)
  - The Hill, by Rachel Frazin, 2025-03-11
* [NOAA to layoff 1,000 more workers at already depleted weather agency: ‘There’s going to be pain and a lot of it’](https://www.independent.co.uk/news/science/noaa-layoffs-doge-trump-federal-cuts-b2713188.html)
  - The Independent, Julia Musto, 2025-03-11
* [‘Chaos’: Trump cuts to Noaa disrupt staffing and weather forecasts](https://www.theguardian.com/us-news/2025/apr/01/trump-cuts-noaa-spam-emails)
  - The Guardian, by Oliver Milman, 2025-04-01
* [Scoop: NOAA operations impaired by Commerce chief's approval mandate](https://www.axios.com/2025/04/01/noaa-commerce-department-contracts-weather-climate)
  - AXIOS, by Andrew Freedman, 2025-04-01
* [NOAA contracts are being reviewed one by one. It's throwing the agency into chaos](https://www.npr.org/2025/04/09/nx-s1-5356166/noaa-contracts-reviewed-one-by-one)
  - NPR, by Alejandra Borunda, 2025-04-09
* [‘These cuts will literally cost lives’ Meteorologists say federal plan to eliminate weather research labs will mean less-accurate forecasts—for everyone](https://kfor.com/news/local/these-cuts-will-literally-cost-lives-meteorologists-say-federal-plan-to-eliminate-weather-research-labs-will-mean-less-accurate-forecasts-for-everyone/)
  - KFOR, by Spencer Humphrey, 2025-07-01
* [Updated NOAA budget plan to eliminate OU's weather research institute, cut 220 employees if passed](https://www.oudaily.com/news/noaa-budget-cuts-could-close-ou-weather-research-institute-cut-employees-research-initiatives/article_ab40a517-070e-41df-81d8-6900ba9d30fb.html)
  - StateImpact Oklahoma, by Chloe Bennett-Steele, 2025-07-02


## URLs for data sources used in **wX** and **wXL23** and associated desktop ports.

### Main screen
  - 7 day forecast, Local alerts, Hourly
    - [NWS API](https://api.weather.gov/)
    - [NWS API General FAQ](https://weather-gov.github.io/api/general-faqs)
    - [NWS API Specification](https://www.weather.gov/documentation/services-web-api)
    - [NWS API discussions](https://github.com/weather-gov/api/discussions)
  - [GOES - Visible satellite, Water Vapor etc](https://www.star.nesdis.noaa.gov/goes/)
  - Severe Dashboard
    - [WPC MPD](https://www.wpc.ncep.noaa.gov/metwatch/metwatch_mpd.php)
    - [SPC](https://www.spc.noaa.gov) MCD/Watches (URLs below)
  - Area forecast discussion
    - change issuedby and product, etc in [url](https://forecast.weather.gov/product.php?site=NWS&issuedby=LWX&product=AFD&format=ci&version=1&glossary=1&highlight=off)
  - [Nexrad radar raw data](https://tgftp.nws.noaa.gov/SL.us008001/DF.of/DC.radar/)

### Main submenu
  - [Radar Mosaics](https://radar.weather.gov/ridge/standard/)
  - [Soundings (SPC)](https://www.spc.noaa.gov/exper/soundings/)
  - Observations
    - [North American Surface Analysis (WPC)](https://www.wpc.ncep.noaa.gov/html/sfc2.shtml)
    - [Unified Surface Analysis by WPC/OPC/NHC/HFO](https://ocean.weather.gov/unified_analysis.php)
  - US Alerts
    - via NWS API at [https://api.weather.gov/alerts/active?region_type=land](https://api.weather.gov/alerts/active?region_type=land)
  - [Spotter Data](https://www.spotternetwork.org/)

### SPC Tab
  - [SPC SREF](https://www.spc.noaa.gov/exper/sref/)
  - [SPC Mesoanalysis](https://www.spc.noaa.gov/exper/mesoanalysis/)
  - [SPC HRRR](https://www.spc.noaa.gov/exper/hrrr/)
  - [SPC HREF](https://www.spc.noaa.gov/exper/href/)
  - [SPC Compmap](https://www.spc.noaa.gov/exper/compmap/)
  - [SPC Convective Outlook](https://www.spc.noaa.gov/products/outlook/)
  - [Storm Reports via SPC](https://www.spc.noaa.gov/climo/reports/today.html)
  - [SPC Mesoscale discussions](https://www.spc.noaa.gov/products/md/)
  - [SPC current convective watches](https://www.spc.noaa.gov/products/watch/)
  - [SPC Fire Weather outlook](https://www.spc.noaa.gov/products/fire_wx/overview.html)
  - [SPC Thunderstorm outlook](https://www.spc.noaa.gov/products/exper/enhtstm/)

### MISC Tab
  - [NCEP Models](https://mag.ncep.noaa.gov/model-guidance-model-area.php)
  - ESRL [HRRR](https://rapidrefresh.noaa.gov/hrrr/)/[RAP](https://rapidrefresh.noaa.gov/)
  - [NHC](https://www.nhc.noaa.gov/)
  - [OPC](https://ocean.weather.gov/)
  - [WPC Images](https://www.wpc.ncep.noaa.gov/) and [WPC Text products](https://www.wpc.ncep.noaa.gov/html/discuss.shtml)
  - GOES Full Disk
    - [https://www.ospo.noaa.gov/products/imagery/meteosat.html](https://www.ospo.noaa.gov/products/imagery/meteosat.html)
    - [https://www.ospo.noaa.gov/products/imagery/meteosatio.html](https://www.ospo.noaa.gov/products/imagery/meteosatio.html)
    - [https://www.ospo.noaa.gov/products/imagery/fulldisk.html](https://www.ospo.noaa.gov/products/imagery/fulldisk.html)
