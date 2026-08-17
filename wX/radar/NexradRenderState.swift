// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

class NexradRenderState {

    var xPos: Float = 0.0
    var yPos: Float = 0.0
    let zPos: Float = -7.0
    var zoom: Float = 1.0
    var projectionNumbers = ProjectionNumbers()
    var paneNumber = 0
    var numberOfPanes = 1
    var displayHold = false
    var gpsLocation = LatLon()
    var gpsLatLonTransformed: (Float, Float) = (0.0, 0.0)
    // String version of paneNumber, needed for Level2 filename
    var indexString = "0"
    var isAnimating = false
    var animationIndex = 0

    private let radarType = "WXMETAL"
    private let initialRadarProducts = ["N0Q", "N0U", "EET", "DVL"]
    var radarProductList = [
        "N0Q: Base Reflectivity",
        "N0U: Base Velocity",
//        "N0B: Base Reflectivity super-res",
//        "N0G: Base Velocity super-res",
        "L2REF: Level 2 Reflectivity",
        "L2VEL: Level 2 Velocity",
        "EET: Enhanced Echo Tops",
        "DVL: Vertically Integrated Liquid",
        "N0X: Differential Reflectivity",
        "N0C: Correlation Coefficient",
        "N0K: Specific Differential Phase",
        "H0C: Hydrometer Classification",
        "DSP: Digital Storm Total Precipitation",
        "DAA: Digital Accumulation Array",
        "N0S: Storm Relative Mean Velocity",
        "NSW: Base Spectrum Width",
        "NCR: Composite Reflectivity 124nm",
        "NCZ: Composite Reflectivity 248nm"
    ]

    var isTdwr = false
    private var ridStr = "DTX"
    private var radarProduct = "N0Q"
    private var tiltInt = 0

    var radarSite: String {
        get { ridStr }
        set {
            ridStr = newValue
            checkIfTdwr()
        }
    }

    var product: String {
        get { radarProduct }
        set {
            radarProduct = newValue
            checkIfTdwr()
        }
    }

    var tilt: Int {
        get { tiltInt }
        set {
            tiltInt = newValue
            if product.count != 5 { // not Level 2
                let middleValue = product[product.index(after: product.startIndex)]
                if middleValue == "0" || middleValue == "1" || middleValue == "2" || middleValue == "3" {
                    let firstValue = product[product.startIndex]
                    let lastValue = product[product.index(before: product.endIndex)]
                    var newProduct = ""
                    newProduct.append(firstValue)
                    newProduct.append(String(tiltInt))
                    newProduct.append(lastValue)
                    product = newProduct
                    regenerateProductList()
                }
                if product.hasPrefix("TV") || product.hasPrefix("TZ") {
                    let firstValue = product[product.startIndex]
                    let middleValue = product[product.index(product.startIndex, offsetBy: 1)]
                    var newProduct = ""
                    newProduct.append(firstValue)
                    newProduct.append(middleValue)
                    newProduct.append(String(tiltInt))
                    product = newProduct
                    regenerateProductList()
                }
            }
        }
    }

    func regenerateProductList() {
        radarProductList.enumerated().forEach { index, productString in
            let firstValue = productString[productString.startIndex]
            let middleValue = productString[productString.index(after: productString.startIndex)]
            if firstValue != "L"
                && (middleValue == "0" || middleValue == "1" || middleValue == "2" || middleValue == "3") {
                let firstValue = productString[product.startIndex]
                let afterTiltIndex = productString.index(productString.startIndex, offsetBy: 2)
                let endIndex = productString.index(before: productString.endIndex)
                let stringEnd = productString[afterTiltIndex...endIndex]
                var newProduct = ""
                newProduct.append(firstValue)
                newProduct += String(tiltInt) + stringEnd
                radarProductList[index] = newProduct
            }
        }
    }

    private func checkIfTdwr() {
        let ridIsTdwr = NexradUtil.isRidTdwr(radarSite)
        if product.hasPrefix("TV") || product == "TZL" || product.hasPrefix("TZ") {
            isTdwr = true
        } else {
            isTdwr = false
        }
        if (product.matches(regexp: "N[0-3]Q") || product == "L2REF") && ridIsTdwr {
            radarProduct = "TZL"
            isTdwr = true
        }
        if (product == "TZL" || product.hasPrefix("TR") || product.hasPrefix("TZ")) && !ridIsTdwr {
            radarProduct = "N0Q"
            isTdwr = false
        }
        if (product.matches(regexp: "N[0-3]U") || product.matches(regexp: "N[0-3]S") || product == "L2VEL") && ridIsTdwr {
            radarProduct = "TV0"
            isTdwr = true
        }
        if product.hasPrefix("TV") && !ridIsTdwr {
            radarProduct = "N0U"
            isTdwr = false
        }
    }

    func writePreferences() {
        let numberOfPanesString = To.string(numberOfPanes)
        let index = To.string(paneNumber)
        Utility.writePrefFloat(radarType + numberOfPanesString + "_ZOOM" + index, zoom)
        Utility.writePrefFloat(radarType + numberOfPanesString + "_X" + index, xPos)
        Utility.writePrefFloat(radarType + numberOfPanesString + "_Y" + index, yPos)
        Utility.writePref(radarType + numberOfPanesString + "_RID" + index, radarSite)
        Utility.writePref(radarType + numberOfPanesString + "_PROD" + index, product)
        Utility.writePrefInt(radarType + numberOfPanesString + "_TILT" + index, tilt)
    }

    // The following two methods are called between the transition from single to dual pane (or dual to quad)
    // It saves the current specifics about the single pane radar save the product itself
    func writePreferencesForSingleToDualPaneTransition() {
        let numberOfPanes = "2"
        ["0", "1"].forEach {
            Utility.writePrefFloat(radarType + numberOfPanes + "_ZOOM" + $0, zoom)
            Utility.writePrefFloat(radarType + numberOfPanes + "_X" + $0, xPos)
            Utility.writePrefFloat(radarType + numberOfPanes + "_Y" + $0, yPos)
            Utility.writePref(radarType + numberOfPanes + "_RID" + $0, radarSite)
            Utility.writePrefInt(radarType + numberOfPanes + "_TILT" + $0, tilt)
        }
    }

    func writePreferencesForDualToQuadPaneTransition() {
        let numberOfPanes = "4"
        ["0", "1", "2", "3"].forEach {
            Utility.writePrefFloat(radarType + numberOfPanes + "_ZOOM" + $0, zoom)
            Utility.writePrefFloat(radarType + numberOfPanes + "_X" + $0, xPos)
            Utility.writePrefFloat(radarType + numberOfPanes + "_Y" + $0, yPos)
            Utility.writePref(radarType + numberOfPanes + "_RID" + $0, radarSite)
            Utility.writePrefInt(radarType + numberOfPanes + "_TILT" + $0, tilt)
        }
    }

    func readPreferences() {
        let numberOfPanesString = To.string(numberOfPanes)
        let index = To.string(paneNumber)
        if RadarPreferences.wxoglRememberLocation {
            zoom = Utility.readPrefFloat(radarType + numberOfPanesString + "_ZOOM" + index, 1.0)
            xPos = Utility.readPrefFloat(radarType + numberOfPanesString + "_X" + index, 0.0)
            yPos = Utility.readPrefFloat(radarType + numberOfPanesString + "_Y" + index, 0.0)
            product = Utility.readPref(radarType + numberOfPanesString + "_PROD" + index, initialRadarProducts[paneNumber])
            radarSite = Utility.readPref(radarType + numberOfPanesString + "_RID" + index, Location.radarSite)
            tilt = Utility.readPrefInt(radarType + numberOfPanesString + "_TILT" + index, 0)
        } else {
            radarSite = Location.radarSite
            product = Utility.readPref(radarType + numberOfPanesString + "_PROD" + index, initialRadarProducts[paneNumber])
        }
    }
}
