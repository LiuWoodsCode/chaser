# App status history (primary NWS data issues)

**Last Updated:  2026-07-16 8:00 EDT**

Some GOES images are not updating. See the [GOES Image Viewer website](https://www.star.nesdis.noaa.gov/goes/index.php) for the latest status.

**Last Updated:  2026-06-28 10:00 EST**

*NWS has confirmed issues with weather.gov and forecast.weather.gov thus making parts of the app unusable.*

**2025-10/28 and 10/29 AWC issues**

*On May 27, 2025, NWS released the following [PNS25-37: Soliciting Feedback through June 26, 2025 on the Potential Retirement of the Model Analysis and Guidance (MAG) Website](https://www.weather.gov/media/notification/pdf_2025/pns25-37_mag_webpage.pdf) which asks for comments on "potential retirement of the Model Analysis and Guidance (MAG) website". If this moves forward the largest and most stable source of model imagery used in wX/wXL23 will no longer be available. These images are currently accessed via the top left icon in the MISC tab. In addition the RTMA images are sourced from this website as well.*

**2025-02-05 05:30 EST (resolved by 2/7 noon)**

*Models hosted at ESRL (NCEP/HRRR) are not responding, website is down. [https://rapidrefresh.noaa.gov/](https://rapidrefresh.noaa.gov/) The parent organizations website is also down [https://www.esrl.noaa.gov/](https://www.esrl.noaa.gov/). You can read more about ESRL at wikipedia [https://en.wikipedia.org/wiki/Earth_System_Research_Laboratories](https://en.wikipedia.org/wiki/Earth_System_Research_Laboratories) Email sent to webmaster@noaa.gov for lack of a better contact.*

**2025-01-26 11:30 EST (resolved by 17:00 EST)**
*GOES satellite imagery is not working at this time, it appears the server in question has an expired SSL certificate:* [https://cdn.star.nesdis.noaa.gov](https://cdn.star.nesdis.noaa.gov)


Issue noticed: 2024-08-23 13:20 EDT
Last Updated:  2024-08-24 05:15 EDT
**Current Status: Access to Nexrad Radar and Observations (among other things) is not working for the Android version. NWS TOC notified of potential CERT issue (missing intermediate). UPDATE SAT AM: Although NWS has not updated INC0485804, access to TGFTP which provides Nexrad and obs is working.**


2024-07-07 08:00 EDT
**After the NWS IT disruption in late June minor nexrad radar delays seem to be occuring on some days around 12:00 EDT - 13:30 EDT. This can be noticed by the radar time showing in red text in the Nexrad radar viewer. Emailed NWS NCO OPS Mon 7/1 16:35 EDT.**

**The NWS IT disurption impacting many services including Nexrad radar and current conditions has been mostly resolved (INC0476209). NWS continues to monitor. At this time minor nexrad radar delays seem to be occuring, most recently observed at Sat 6/29 06:30 EDT and Fri 6/28 13:15 EDT. This can be noticed by the radar time showing in red text in the Nexrad radar viewer. Resolution usually takes 30-60 minutes. I am recording data for further escalation to NWS. UPDATE: emailed NWS NCO OPS Mon 7/1 16:35 EDT, problem not seen on 7/5 (or sooner)**

2024-06-24 18:00 - 2024-06-25 14:00 - Major impact, Nexrad radar and current conditions (TGFTP) down or showing only data for almost 18 hours:

Tue June 24th 7:30pm EDT: Nexrad radar and current conditions are not working (additional impacts as well) as the following NWS website is not responding or more recently is not showing current data, NWS TOC has been notified. As of June 25th 05:00 EDT the issue is ongoing, NWS is tracking under INC0476209:
[https://tgftp.nws.noaa.gov/SL.us008001/DF.of/DC.radar/](https://tgftp.nws.noaa.gov/SL.us008001/DF.of/DC.radar/)

The message from NWS is at [https://forecast.weather.gov/product.php?site=NWS&product=ADM&issuedby=SDM](https://forecast.weather.gov/product.php?site=NWS&product=ADM&issuedby=SDM)

```
410
NOUS42 KWNO 250915
ADMSDM

SENIOR DUTY METEOROLOGIST NWS ADMINISTRATIVE MESSAGE
NWS NCEP CENTRAL OPERATIONS COLLEGE PARK MD
0905Z TUE JUN 25 2024


...SEVERE NETWORK INSTABILITY AT NCWCP...

Troubleshooting teams continue to narrow down the source of the
severe network instability at NCWCP. Numerous NWS services remain
down/degraded. No ETR.

Known Operational Impacts:
-Several IDP applications, which are used to disseminate WWAs
and/or access model/observational data are down and/or degraded
(this includes Caphandler, MADIS, FTPPRD, TGFTP, SPADES, EDIS,
NWWS-OI, IRIS/iNWS).
-A portion of TG applications, which are used to send/receive
meteorological data to local, national, and international
partners are down (this includes FTPS services).
-NWS Cloud Services, GIS and NWPS, are degraded due to various
datasets not updating.
-OPC and WPC forecast operations are severely degraded.
-WPC, OPC, AWC, and NCO`s websites are not updating with current
data.
-Critical NWS systems and network monitoring are down.
-Internet is not accessible while on NCEP CP VPN.


Gerhardt/SDM/NCO/NCEP
```



 2023-12-24 - 2024-01-01: The NWS API which can be used for 7 day forecast and hourly data is not working. To overcome this, please see FAQ item #1 below. NWS does mention this at [https://www.nco.ncep.noaa.gov/status/messages/](https://www.nco.ncep.noaa.gov/status/messages/) and it will not be fixed until at least Jan 1, 2024. thanks

2023-06-22 12:15 EDT: (appears to be resolved) TGTFP is not responding causing Nexrad Radar, Current Conditions, and other services to not work. The Android update released today is not causing this but is impacted by this as are the iOS and desktop versions.


2023-06-13: It is noticed that the NSSL WRF/FV3 model activity is not working due to upstream changes. A future release will have this tile removed until it can be fixed. In the meantime you can access the [website](https://cams.nssl.noaa.gov/) directly.

**Fri Mar 24 05:00AM EDT - NWS SPC has updated the image type/URL for SPC MCD and thus the images are not showing in both the Android/iOS versions. A fix will be expedited. Update: iOS fix was delivered Sat Mar 25. Android fix was releasted to beta on the same day with expected production fix by end of month.**

**2022-10-15 (lasted ~90min)
Sat Oct 15 8am EDT - Current conditions data is old and windbarbs in radar are not working due to unexpected METAR data format from AWC. NWS does have the following posted which is possibly related:
```
DATAFLOW ISSUE...

NCO is aware of and investigating a dataflow issue that began
around 11Z...more information to come.
```

**2022-08-30 16:00 - seven day forecast and possibly other services not working due to NWS IT service outage. You can view the 2nd URL below for status updates.** (24+ hrs)

2022-05-24 Tue 7pm EDT - [https://tgftp.nws.noaa.gov/](https://tgftp.nws.noaa.gov/) is not accessible. Nexrad radar, current observations and other services will not work until NWS fixes. **Wed 6am EDT update** Issue was resolved twice over night and then it stopped working again, NWS continues to investigate. At this point it is best to get updates from this URL [https://www.nco.ncep.noaa.gov/status/messages/](https://www.nco.ncep.noaa.gov/status/messages/) which is always listed at the top of this FAQ.

2022-04-09
11:15am EDT - 7 day forecast using old API (the default) is not working.
Multiple services including Hourly, and SMW alerts not working on nexrad, URL is now showing data [https://api.weather.gov/alerts/active?event=Special%20Marine%20Warning](https://api.weather.gov/alerts/active?event=Special%20Marine%20Warning). There is mention of data center issues in the NWS status message URL below.


2022-03-26
Sat 3/26 6:00am EST: Various products including 7 day, old hourly, and some text products are not working. NWS has ackn the issue at the 2nd URL below. Please see the first FAQ item for a [workaround](https://gitlab.com/joshua.tee/wxl23/-/blob/master/doc/FAQ.md#the-hourly-forecast-or-7-day-forecast-is-not-working-correctly-is-there-a-workaround)

2022-03-17
*UPDATE* - NWS indicates services were restored around 10pm EDT
Thur 3/17 - various NWS services like 7 day forecast have been sporadically not working during the day due to a planned NWS change. After patching an unexpected issue has occured. You can read about this and track it in the 2nd URL below.

2022-03-12
Sat 3/12 11:30am EST: Various products including 7 day, old hourly, and some text products are not working. NWS has ackn the issue at the 2nd URL below. (NWS mentions resolved by 1pm)

2022-02-19
**Feb 19 4pm EST: Nexrad radar not updating for all sites. You can monitor status here: [https://radar3pub.ncep.noaa.gov/](https://radar3pub.ncep.noaa.gov/)**
**Feb 19 6pm EST update: most sites have current data but gaps when animating are likely for the next few hours.**

2022-01-04
Slowness in Nexrad radar and possibly other features like current conditions. NWS states per URL below:
*FTPPRD/TGFTP/GIS/RIDGE2 access and slowness problems started around 07Z.  NCO support is investigating.*


2021-12-15 (evening)
**Dec 15 5:50pm EST - ~7:00pm EST: Nexrad radar is slow to respond at times. This might impact location based current conditions as well**


2021-12-05 (evening)

**Status: SPC Convective Outlook Day 1 images are old **

The Day 1 URL is showing 0100 UTC data for images but the text product is current:
[https://www.spc.noaa.gov/products/outlook/day1otlk.html](https://www.spc.noaa.gov/products/outlook/day1otlk.html)

2021-12-05 (afternoon)
All GOES 16-17 images are not available due to the following website being non-responsive: [https://www.star.nesdis.noaa.gov/goes/index.php](https://www.star.nesdis.noaa.gov/goes/index.php)

Various parts of wX/wXL23 use api.weather.gov so you might see disruptions or degradations:

SENIOR DUTY METEOROLOGIST NWS ADMINISTRATIVE MESSAGE
NWS NCEP CENTRAL OPERATIONS COLLEGE PARK MD
2040Z TUE SEP 28 2021

...API.WEATHER.GOV DEGRADED...

API remains degraded following patching. NCO is investigating the
issue.

Liddick/SDM/NCO/NCEP

Resolved before 4am EDT 9/18 
9/17 3pm EDT: Current conditions for all locations are not updating, for example:
https://tgftp.nws.noaa.gov//data/observations/metar/decoded/KWHP.TXT
NWS TOC was contacted and they were already aware and tracking under INC0300383
Fri Aug 27 6am EDT: NCEP Models and NWS WPC content not working (or showing old data) due to NWS website not responding: https://mag.ncep.noaa.gov/ 
https://www.wpc.ncep.noaa.gov/
GOES also not current: https://www.star.nesdis.noaa.gov/GOES/index.php

More details at: https://www.nco.ncep.noaa.gov/status/messages/

Thur Aug 12 (resolved same day but please note below) - Lightning graphics are showing but showing no lightning strikes. NOTE: This data provider has had a number of outages this year and so an alternative is being looked into. The only suitable alternative I have found so far is the following and this will likely become the default in the next month:
https://www.star.nesdis.noaa.gov/GOES/conus_band.php?sat=G16&band=EXTENT&length=12

Sat Aug 7 - NHC Storm is not displaying any details for NHC PTC Jimena. (storm is no longer active anyway as of 6:45am EDT)

2021-07-19 12:10pm EDT https://tgftp.nws.noaa.gov/ not responding or showing old data impacting current conditions, nexrad radar. Example of old data (all radar sites are impacted)
https://tgftp.nws.noaa.gov/SL.us008001/DF.of/DC.radar/DS.p94r0/SI.kcys/

UPDATE 4:30pm EDT: appears to be resolving.


2021-06-03 12:00pm EDT - some nexrad radar sites not updated on https://tgftp.nws.noaa.gov 
since roughly 10:45am EDT. You can see status here https://radar3pub.ncep.noaa.gov/
https://www.nco.ncep.noaa.gov/status/messages/

UPDATE: 1pm EDT - per web page above (https://radar3pub.ncep.noaa.gov/) things are back to normal for Nexrad Level 3 data.

2021-05-25 1:00pm EDT https://tgftp.nws.noaa.gov/ not responding impacting current conditions, nexrad radar.

2021-05-14 12:00pm EDT - NWS not updating for 7day/ hourly / some text products

2021-04-26 Many NWS WPC image products and an advertised “current” MPD are from 2020. (last less then one day)
https://www.wpc.ncep.noaa.gov/#page=ovw
https://www.wpc.ncep.noaa.gov/metwatch/metwatch_mpd_multi.php

Sun 4/11 - lightning images are not working (non-NWS provider). Example:
http://images.lightningmaps.org/blitzortung/america/index.php?map=usa_big&period=0.25

Mon Mar 29 9am EDT - Tue afternoon
Major NWS IT outage (started Mon morning) impacting most products presented by wX app. Some things such as AWC Radar Mosaic and GOES images might continue to work but they are the exception. Updates being posted here (this URL is not really working as of Tue morning)
https://www.nco.ncep.noaa.gov/status/messages/

SENIOR DUTY METEOROLOGIST NWS ALERT ADMINISTRATIVE MESSAGE
NWS NCEP CENTRAL OPERATIONS COLLEGE PARK MD
2027Z TUE MAR 30 2021

The earlier network firewall issue that impacted several NWS
applications
and services was corrected around 1745Z...external customers
should see
most/all impacts mitigated at this point. The few residual
internal NWS
network issues are being updated on the NWS IT Status Dashboard.

Handel/SDM/NCO/NCEP

Upcoming NWS outage Mar 27 impacting Level 2 Nexrad:
https://www.weather.gov/media/notification/pdf2/pns21-17national_level_II_outage.pdf

The NWS Radar Operations Center will perform required network maintenance at its data center in Norman, OK, on Saturday, March 27, from 8 am to 10 am EDT. The date and time of this required maintenance window was determined using forecast information to occur at a period of lower weather activity and risk. During this 2-hour period, NEXRAD and Terminal Doppler Weather Radar (TDWR) National Level II data will be unavailable. These data are primarily provided to the commercial, private sector and academia, and some mobile apps or third-party software may be affected. NEXRAD and TDWR Level III data will be disseminated as normal.

2021 Mar 11 - Mar 20 - Lightning maps does not appear to be working, default images uses this URL:
https://images.lightningmaps.org/blitzortung/america/index.php?map=usa_big&period=0.25
I’ll need to investigate if they have changed the URL or if it’s a legitimate server issue. UPDATE: appears to be a data center issue per the front page. Service might not be restored for days. (Outage 3/11/2021 - 3/20/2021)

3/9 (15min): 7 day forecast (old API) not responding as seen on forecast.weather.gov (12:45pm EDT)

3/2: Looks like image based widgets for those using them and running the latest version of Android might not be working. Appears to be caused by new restrictions set forward by Google in the latest Android version when app is target SDK 30. A fix has been submitted to google for approval (noon EDT 3/2) and is now available for update.

3/2: Update to both Android and iOS version released in the past day, should resolve all known issues related to flaky 7 day forecast, traditional radar mosaic no longer available, and severe weather alerts not showing or causing crashes.

	UPDATE 2/24: the iOS version released on Feb 24 resolves issues #2 and #3 below. Android version submitted for approval on March 1. New version is no longer using the new NWS API by default for 7 day forecast.

It was noticed on Feb 25 that a suspected change in the NWS data url for alerts is causing a crash for 
Long press in nexrad to show severe warnings
Tapping for details on severe warnings in severe dashboard
	This will be looked into the next time severe warnings are present during hours I am available to work on it. A fix is already released in Beta for Android (without testing). Hoping for scenarios to test with today. This impact other things related to individual alerts such as notifications.
Dec 20 2020: NWS has temporarily suspended the default Radar Mosaic images until Feb 26, 2021. This change appears related to the main NWS nexrad radar page update but no advanced notice was given on this suspension of mosaic data. In the meantime you can go to Settings -> UI and choose to use the “AWC” radar mosaic images instead. It’s unclear if the URLs will change on Feb 26 so an update to the app might be needed as well.Update, there is no longer a date given so AWC will be the only option going forward unless things change, see https://www.weather.gov/media/notification/pdf2/scn20-117radar_emwinaaa.pdf
(the next version of wX/wXL23 will no longer use the new NWS API for 7 day) No need to report 7 day or hourly issues, please see below): 

July 17 2020:  Earlier this week a user reported an issue with the 7 day forecast. Upon contacting NWS I received the following reply (below). The bottomline is until they fix this issue there is no need to report an issue to me as when I report it to them they will just state what is below. Please note in many cases you can add another location (~30 miles) away, and if it’s in another forecast zone it should work fine until your original location starts working again. However, if your zone doesn’t work for more then one week and you are able to share your forecast zone URL (settings -> About , at the bottom) , I can share these with NWS.:
NWS TOC response: We have a ticket opened for  (500, 502, 503 API errors). Our programming/developing team, are looking to resolve the issue with a SW patch, after it's been successfully tested on our DEV system. How long will that take? I don't know, but I can tell you it's being worked. I'll add you to the ticket so you can keep track of developments.

I suspect it’s this.

Fri 2/26 3pm EST - looks like radar data is showing old data all of a sudden from around 10am this morning, example can be seen here (likely impacting all nexrad directories) https://tgftp.nws.noaa.gov/SL.us008001/DF.of/DC.radar/DS.p94r0/SI.kcle/ ( look at sn.last )  NWS TOC notified. Update 3:15pm EST (TOC stated service should be restored “shortly”) UPDATE2: at 6:30pm EST issue appears resolved.


Mon 2/15 Afternoon - NWS API not working that well impacting 7 day, hazards. 


1/26 7pm EDT: Nexrad radar (Level 3) not current past ~6:15pm EDT. NWS notified (and responded with estimated resolution before 9pm EDT). For example see sn.last file in 
https://tgftp.nws.noaa.gov/SL.us008001/DF.of/DC.radar/DS.p94r0/SI.klot/

(2021/01/24 8pm EDT) https://api.weather.gov shows “bad gateway”, emailed NWS TOC 5AM Sat impacts 7day/hourly/alerts. Mostly resolved Sat night but issue returned Sun night, resolved by Monday 9am per TOC INC0247201


(2021/01/23) https://api.weather.gov shows “bad gateway”, emailed NWS TOC 5AM Sat impacts 7day/hourly/alerts. Mostly resolved Sat night. TOC INC0247201

(2021/01/21) Upcoming NWS outage impacting Level 2: Jan 21 12 to 07z following day. Details.

10/28 pm 5:15pm EDT  https://tgftp.nws.noaa.gov/ slow to respond (or not at all) impacting Nexrad radar and current conditions.

NWS IT Outage impacting Level 2 radar data Oct 22  1100z to 1700z
https://www.weather.gov/media/notification/SCN20-93_Updated_NOMADS_website_outage.pdf

NWS IT Outage Sep 28 (resched from 9/21) 06z-09z impacting numerous things including nexrad:
https://www.weather.gov/media/notification/pdf2/scn20-86noaaport_outage.pdf


2020-09-10 7:00am EDT, nexrad radar and observations intermittent due to issues with
http://https://tgftp.nws.noaa.gov

Wed 9/9 12:15pm EDT - looks like the website for nexrad radar data and location observations is not responding:
https://tgftp.nws.noaa.gov/
It looks like the website for 7 day / hourly / alerts is having an issue as well:
https://api.weather.gov/
Issue with MAG NCEP models as well.

2020-09-07 4:30am EDT - nexrad data files not updating at https://tgftp.nws.noaa.gov/SL.us008001/DF.of/DC.radar/DS.p94r0/ , last update roughly 06Z. NWS TOC notified.
Workaround use Radar mosaic.

Sunday 8/30 8:30am EDT - intermittent issues with https://api.weather.gov/ impacting 7day, hourly, alerts

(hurricane)Aug 26 12:00pm EDT https://tgftp.nws.noaa.gov/ intermittently responding impacting Nexrad radar and current conditions.

Aug 26 2:00pm EDT GOES imagery slow to respond if at all

Aug 26 8:00pm https://api.weather.gov not responding at all causing numerous products to not be available including 7day, hourly, alerts, some text products.

Aug 25 5:30pm EDT https://tgftp.nws.noaa.gov/ intermittently responding impacting Nexrad radar and current conditions.


Aug 16 7:00am - ~1:00pm EDT - NWS is not reliably providing radar data for Nexrad via TGFTP. (seems better @ 1:30pm)

Wed July 8, 4:15 am EDT - https://api.weather.gov is down for 7 day forecasts and hourly, TOC notified. Issue appears *somewhat* resolved by noon EDT but NWS has not officially confirmed and did mention they are making changes later this summer to prevent such issues from happening.
Thu 7:00am EDT It would appear the problem is more widespread again as forecasts are now showing as expired for many locations (For my reference the NWS ticket is INC0224255)
Thu 6:00pm EDT, still no confirmation of resolution but things seem a little better.


Monday June 29, 10:10am EDT - https://api.weather.gov is down for 7 day forecasts and hourly, TOC notified. (appears to have gotten better as the day progressed)

Thursday June 25, 12:50pm EDT - it appears https://tgftp.nws.noaa.gov is down impacting Nexrad radar, current conditions, and other more minor things. NWS TOC emailed. 
1:00pm EDT - appears to be working again

2020-06-17(wed) 9:00am - 9:45am am EDT - NWS API not available impacting 7 day / warnings. 
2020-05-14(thur) 3:00pm  EDT - NWS API not available impacting 7 day forecast / hourly / warnings / adding new US locations.  NWS TOC notified, open issue INC0219267. Last update 6pm EDT - ticket was priority “critical” and they are looking at an infrastructure issue. 
https://api.weather.gov/
Fri 2:10am EDT - services appear to be working now with sporadic issues. NWS has not updated status via the incident above.
Fri 3:45am EDT - service continues to be stable, moving app status to green. 
Fri 9:00am EDT - issue has returned
Fri 9:30am EDT - working again sporadically
Fri 11:30am EDT - NWS updated the critical ticket with actions they are taking to restore service but there is no estimate for restoration time. It does appear to be working sporadically.  
Fri 18:00 EDT - services appear to be restored, please email me if issues.


2020-05-12(tue) 2:15 pm (lasted less than 30min)  EDT - NWS API not available impacting 7 day / warnings. NWS TOC notified with estimation restoration within 1 hour.


NWS is planning IT work causing radar and forecast (and others) to not work on May 5 1200Z-14:30Z
https://www.weather.gov/media/notification/scn20-49awips_migration.pdf

4/29/20 Nexrad Radar animations have gaps. It looks like TGFTP data structure is not correct but is recovering. For example GRR is as follows. This should resolve over time.

sn.024229-Apr-2020 13:51 43K
sn.024329-Apr-2020 13:54 43K
sn.024429-Apr-2020 13:56 43K
sn.024529-Apr-2020 13:59 43K
sn.024629-Apr-2020 14:02 44K ←-
sn.024729-Apr-2020 00:09 33K ←-
sn.024829-Apr-2020 00:13 33K
sn.024929-Apr-2020 00:16 32K
sn.025029-Apr-2020 00:19 32K
sn.last29-Apr-2020 14:25 44K

4/25/20 NHC EPAC storm detail is now showing correctly in the Android/Kotlin version. FIX will enter Beta today with production release by 5/31 or sooner if NHC tracked storm is present.

Sunday April 19, 2020 12:30pm EDT api.weather.gov is not responding causing no 7 day forecasts
12:45pm resolved

Sat Apr 11, 10:00am EDT - 7 day forecast for zones controlled by RAH (Raleigh, NC) not working. NWS TOC notified.

Thur Apr 9, 2:40pm EDT - appears to be working again
Thur Apr 9, 2:15pm EDT
Any service relying on NWS API such as forecast, 7 day, warnings is down. https://api.weather.gov , NWS TOC notified


4/8/2020 8:00pm EDT - Level 2 data files do not appear to be complete from NWS site:
https://nomads.ncep.noaa.gov/pub/data/nccf/radar/nexrad_level2/
NWS TOC notified.
	8:40pm EDT update: some radar files are displaying but may be 
30-40 minutes old.
	10:00pm EDT update: looks like things are normal
As a reminder there is a FAQ item below titled “Why is Level 2 radar not the default?” I *suspect* this problem is caused by load on the NWS servers given the very active weather event underway. In situations like this, it is best to use Level 3 IMHO unless you are in a situation which calls for Level 2. It appears the servers for Level 3 files are doing fine.


App status:(9:15am appears resolved)
4/3/2020 8:30am EDT - Nexrad radar, current conditions, 7 day forecast, hourly (possibly other) not working. NWS notified.
https://tgftp.nws.noaa.gov
https://api.weather.gov

 Degraded 7 day forecasts for some locations
Mar 27, 2020 1:00pm EDT, NWS notified
May 28, 2020 9:00am EDT, appears resolved

Wed 3/25 6am EDT - 7 day forecast not working for most US locations. NWS TOC notified. 

Tue 2/25 4:00pm EST - NWS API impacting 7 day forecast, alerts, and services appears to be down.
Tue 2/25 5:15pm EST - NWS has resolved the issue

