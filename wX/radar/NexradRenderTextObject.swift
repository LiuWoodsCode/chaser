// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class NexradRenderTextObject {

    private var glView = NexradRenderSurfaceView()
    var wxMetalRender: NexradRender!
    #if targetEnvironment(macCatalyst)
    private let cityMinZoom: Float = 0.20
    private let obsMinZoom: Float = 0.20
    private let countyMinZoom: Float = 0.20
    #endif
    #if !targetEnvironment(macCatalyst)
    private let cityMinZoom: Float = 0.50
    private let obsMinZoom: Float = 0.50
    private let countyMinZoom: Float = 1.50
    #endif
    private let maxCitiesPerGlview: Int
    private let glViewWidth: Double
    private let glViewHeight: Double
    private let scale: Double
    private let textSize = Double(RadarPreferences.textSize)
    private let context: UIViewController
    private let xFudge: Double
    private let yFudge: Double
    private var fileStorage = FileStorage()

    init() {
        glViewWidth = 0.0
        glViewHeight = 0.0
        scale = 0.0
        xFudge = 15.0
        yFudge = 25.0
        maxCitiesPerGlview = 16
        context = UIViewController()
    }

    init(
        _ context: UIViewController,
        _ glViewWidth: Double,
        _ glViewHeight: Double,
        _ wxMetalRender: NexradRender,
        _ screenScale: Double
    ) {
        self.context = context
        self.glViewWidth = glViewWidth
        self.glViewHeight = glViewHeight
        self.wxMetalRender = wxMetalRender
        fileStorage = wxMetalRender.fileStorage
        maxCitiesPerGlview = 16 / wxMetalRender.state.numberOfPanes
        var fudgeFactor: Double = 375.0 * Double(UtilityUI.getScreenScale()) / 2.0
        if UtilityUI.getScreenScale() < 1.6 {
            fudgeFactor = 375.0
        }
        scale = 0.76 * screenScale * 0.5 * (glViewWidth / fudgeFactor)
        xFudge = 15.0 * (fudgeFactor / glViewWidth)
        yFudge = 25.0 * (fudgeFactor / glViewWidth)
    }

    private func addCities() {
        if GeographyType.cities.display {
            glView.cities.removeAll()
            if wxMetalRender.state.zoom > cityMinZoom {
                let cityExtLength = CitiesExtended.cities.count
                (0..<cityExtLength).forEach { index in
                    if glView.cities.count <= maxCitiesPerGlview {
                        checkAndDrawText(
                            &glView.cities,
                            CitiesExtended.cities[index].latitude,
                            CitiesExtended.cities[index].longitude,
                            CitiesExtended.cities[index].name,
                            GeographyType.cities.color
                        )
                    }
                }
            }
        }
    }

    func checkAndDrawText(_ tvList: inout [TextViewMetal], _ lat: Double, _ lon: Double, _ text: String, _ color: Int) {
        let latLon = Projection.computeMercatorNumbers(lat, lon, wxMetalRender.state.projectionNumbers)
        // changing RID resets glviewWidth
        let xPos = latLon[0] * Double(wxMetalRender.state.zoom) - xFudge + Double(wxMetalRender.state.xPos)
        let yPos = latLon[1] * Double(wxMetalRender.state.zoom) - yFudge - Double(wxMetalRender.state.yPos)
        if abs(xPos) * scale * 2 < glViewWidth && abs(yPos * scale * 2) < glViewHeight {
            let tv = TextViewMetal(context)
            tv.textColor = color
            tv.textSize = Double(textSize)
            tv.setPadding(CGFloat(glViewWidth / 2) + CGFloat(xPos * scale), CGFloat(glViewHeight / 2) + CGFloat(yPos * scale))
            tv.setText(text)
            tvList.append(tv)
        }
    }

    private func initializeCities() {
        if wxMetalRender.state.numberOfPanes == 1 && GeographyType.cities.display {
            CitiesExtended.create()
        }
    }

    private func initializeCountyLabels() {
        if GeographyType.countyLabels.display {
            CountyLabels.create()
        }
    }

    private func addCountyLabels() {
        if GeographyType.countyLabels.display {
            glView.countyLabels.removeAll()
            if wxMetalRender.state.zoom > countyMinZoom {
                CountyLabels.labels.indices.forEach {
                    checkAndDrawText(
                        &glView.countyLabels,
                        CountyLabels.location[$0].lat,
                        CountyLabels.location[$0].lon,
                        CountyLabels.labels[$0],
                        GeographyType.countyLabels.color
                    )
                }
            }
        }
    }

    private func addSpottersLabels() {
        if PolygonType.SPOTTER_LABELS.display {
            glView.spottersLabels.removeAll()
            if wxMetalRender.state.zoom > 0.5 {
                UtilitySpotter.spotterList.indices.forEach {
                    checkAndDrawText(
                        &glView.spottersLabels,
                        UtilitySpotter.spotterList[$0].location.lat,
                        UtilitySpotter.spotterList[$0].location.lon * -1.0,
                        " " + UtilitySpotter.spotterList[$0].lastName.replace("0FAV ", ""),
                        PolygonType.SPOTTER_LABELS.color
                    )
                }
            }
        }
    }

    func initializeTextLabels() {
        if wxMetalRender.state.numberOfPanes == 1 {
            initializeCities()
        }
        initializeCountyLabels()
    }

    func removeTextLabels() {
        context.view.subviews.forEach { view in
            if view is UITextView {
                view.removeFromSuperview()
            }
        }
    }

    func refreshTextLabels() {
        removeTextLabels()
        addTextLabels()
    }

    func addTextLabels() {
        if wxMetalRender != nil && wxMetalRender.state.numberOfPanes == 1 {
            addCities()
            addCountyLabels()
            addObservations()
            addSpottersLabels()
            addWpcPressureCenters()
        }
    }

    func addWpcPressureCenters() {
        if RadarPreferences.wpcFronts {
            glView.pressureCenterLabels.removeAll()
            if wxMetalRender.state.zoom < NexradRender.zoomToHideMiscFeatures {
                WpcFronts.pressureCenters.forEach { value in
                    var color = Color.rgb(0, 127, 255)
                    if value.type == PressureCenterTypeEnum.LOW {
                        color = Color.rgb(255, 0, 0)
                    }
                    checkAndDrawText(&glView.pressureCenterLabels, value.lat, value.lon, value.pressureInMb, color)
                }
            }
        }
    }

    private func addObservations() {
        if PolygonType.OBS.display||PolygonType.WIND_BARB.display {
            let obsExtZoom = Double(RadarPreferences.obsExtZoom)
            glView.observations.removeAll()
            if wxMetalRender.state.zoom > obsMinZoom {
                fileStorage.obsArr.indices.forEach { index in
                    if index < fileStorage.obsArr.count && index < fileStorage.obsArrExt.count {
                        let tmpArrObs = fileStorage.obsArr[index].split(":")
                        let tmpArrObsExt = fileStorage.obsArrExt[index].split(":")
                        let lat = To.double(tmpArrObs[0])
                        let lon = To.double(tmpArrObs[1])
                        let latLon = Projection.computeMercatorNumbers(lat, lon * -1.0, wxMetalRender.state.projectionNumbers)
                        let xPos = latLon[0] * Double(wxMetalRender.state.zoom) - xFudge + Double(wxMetalRender.state.xPos)
                        let yPos = latLon[1] * Double(wxMetalRender.state.zoom) - yFudge - Double(wxMetalRender.state.yPos)
                        if abs(Double(xPos) * scale * 2 ) < glViewWidth && abs(yPos * scale * 2) < glViewHeight {
                            if Double(wxMetalRender.state.zoom) > obsExtZoom {
                                glView.observations.append(TextViewMetal(context, 150, 150))
                            } else {
                                glView.observations.append(TextViewMetal(context))
                            }
                            glView.observations.last?.textColor = RadarPreferences.colorObs
                            glView.observations.last?.textSize = textSize
                            glView.observations.last?.setPadding(CGFloat(glViewWidth / 2) + CGFloat(xPos * scale), CGFloat(glViewHeight / 2) + CGFloat(yPos * scale))
                            if Double(wxMetalRender.state.zoom) > obsExtZoom {
                                glView.observations.last?.setText(tmpArrObsExt[2])
                            } else if PolygonType.OBS.display {
                                glView.observations.last?.setText(tmpArrObs[2])
                            }
                        }
                    }
                }
            }
        }
    }
}
