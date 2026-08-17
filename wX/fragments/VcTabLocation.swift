// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit
import Metal
import simd

final class VcTabLocation: VcTabParent {

    private var testButton = UIBarButtonItem()
    var menuButton = ToolbarIcon()
    private var currentConditions = CurrentConditions()
    private var hazards = Hazards()
    private var sevenDay = SevenDay()
    private var textProductLong = [String: String]()
    private var oldLocation = LatLon()
    private var locationLabel = Text()
    private var boxCc = VBox()
    private var boxSevenDay = VBox()
    private var boxHazards = VBox()
    var cardRadar = CardHomeScreen()
    private var cardCurrentConditions: CardCurrentConditions?
    private var sevenDayCollection: SevenDayCollection?
    private var extraDataCards = [CardHomeScreen]()
    private var toolbar = Toolbar()
    private var globalHomeScreenFav = ""
    private var globalTextViewFontSize: CGFloat = 0.0
    private let downloadTimer = DownloadTimer("MAIN_LOCATION_TAB")
    private var nexradTab = NexradTab()
    #if targetEnvironment(macCatalyst)
    private var oneMinRadarFetch = Timer()
    #endif

    func setupMenu() {
        let action1 = UIAction(title: "Option 1", image: UIImage(systemName: "hand.point.right.fill")) { _ in
            print("Option 1 selected")
        }
        let action2 = UIAction(title: "Option 2", image: UIImage(systemName: "star.fill")) { _ in
            print("Option 2 selected")
        }
        let menu = UIMenu(title: "My Menu", children: [action1, action2])
        testButton = UIBarButtonItem(title: "Menu", image: nil, primaryAction: nil, menu: menu)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        scrollView.backgroundColor = ColorCompatibility.systemGray5
        scrollView.backgroundColor = AppColors.primaryBackgroundBlueUIColor
        boxMain.getView().backgroundColor = ColorCompatibility.systemGray5
        #if targetEnvironment(macCatalyst)
        #else
        toolbar.resize(uiv: self)
        #endif
        let topSpace: CGFloat
        #if targetEnvironment(macCatalyst)
        topSpace = UtilityUI.getTopPadding()
        #else
        topSpace = UtilityUI.getTopPadding() + UIPreferences.toolbarHeight
        #endif
        if objScrollStackView != nil && objScrollStackView!.fragmentHeightAnchor1 != nil {
            view.removeConstraints([
                objScrollStackView!.fragmentHeightAnchor1!,
                objScrollStackView!.fragmentHeightAnchor2!,
                objScrollStackView!.fragmentWidthAnchor1!,
                objScrollStackView!.fragmentWidthAnchor2!
            ])
        }
        if objScrollStackView != nil {
            let bottomSpace: CGFloat
            #if targetEnvironment(macCatalyst)
            bottomSpace = 0.0
            #else
            if #available(iOS 26, *) {
                bottomSpace = 0.0 // -1.0 * UtilityUI.getBottomPadding()
            } else {
                bottomSpace = -1.0 * (UIPreferences.tabBarHeight + UtilityUI.getBottomPadding())
            }
            #endif
            objScrollStackView!.fragmentHeightAnchor1 = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomSpace)
            objScrollStackView!.fragmentHeightAnchor2 = scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: topSpace)
            objScrollStackView!.fragmentWidthAnchor1 = scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            objScrollStackView!.fragmentWidthAnchor2 = scrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
            view.addConstraints([
                objScrollStackView!.fragmentHeightAnchor1!,
                objScrollStackView!.fragmentHeightAnchor2!,
                objScrollStackView!.fragmentWidthAnchor1!,
                objScrollStackView!.fragmentWidthAnchor2!
            ])
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        setupToolbar()
        globalHomeScreenFav = Utility.readPref("HOMESCREEN_FAV", GlobalVariables.homescreenFavDefault)
        globalTextViewFontSize = UIPreferences.textviewFontSize
        addLocationCard()
        getContentSuper()
        #if targetEnvironment(macCatalyst)
        oneMinRadarFetch = Timer.scheduledTimer(
            timeInterval: 60.0 * Double(UIPreferences.refreshLocMin),
            target: self,
            selector: #selector(getContentSuper),
            userInfo: nil,
            repeats: true
        )
        #endif
    }

    func setupToolbar() {
        #if targetEnvironment(macCatalyst)
        return
        #else
        toolbar = Toolbar()
        let radarButton = ToolbarIcon(self, .radar, #selector(radarClicked))
        let cloudButton = ToolbarIcon(self, .cloud, #selector(cloudClicked))
        let wfoTextButton = ToolbarIcon(self, .wfo, #selector(wfotextClicked))
        menuButton = ToolbarIcon(self, .submenu, #selector(menuClicked))
        menuButton.setMenu(Route.subMenu(self))
        let dashButton = ToolbarIcon(self, .severeDashboard, #selector(dashClicked))
        toolbar.items = ToolbarItems(
            GlobalVariables.flexBarButton,
            dashButton,
            wfoTextButton,
            cloudButton,
            radarButton,
            menuButton).items
        view.addSubview(toolbar)
        toolbar.setConfigWithUiv(self, toolbarType: .top)
        #endif
    }

    @objc func getContentSuper() {
        oldLocation = Location.latLon
        clearViews()
        getForecastData()
        mainDisplay()
    }

    func getForecastData() {
        _ = FutureVoid({
            self.currentConditions.process(Location.latLon)
            self.currentConditions.timeCheck()
        }, { self.getCurrentConditionCards() })
        _ = FutureVoid(downloadSevenDay, updateSevenDay)
        _ = FutureVoid(downloadHazards, updateHazards)
    }

    func downloadSevenDay() {
        sevenDay = SevenDay(Location.latLon)
        sevenDay.locationIndex = Location.getCurrentLocation()
    }

    func updateSevenDay() {
        if sevenDayCollection == nil
            || !Location.isUS
            || sevenDay.locationIndex != sevenDayCollection?.locationIndex
            || sevenDayCollection?.sevenDayCards.count == 0 {
            boxSevenDay.removeChildren()
            sevenDayCollection = SevenDayCollection(
                boxSevenDay,
                scrollView,
                sevenDay)
            sevenDayCollection?.locationIndex = Location.getCurrentLocation()
        } else {
            sevenDayCollection?.update(sevenDay)
        }
    }

    func downloadHazards() {
        hazards.process(Location.latLon)
    }

    func updateHazards() {
        boxHazards.removeChildren()
        CardHazards.get(self, boxHazards, hazards)
    }

    // Clear all views except 7day and current conditions
    func clearViews() {
        boxHazards.removeChildren()
        extraDataCards.forEach {
            $0.removeFromSuperview()
        }
        extraDataCards.removeAll()
        boxHazards.isHidden = true
        cardRadar.removeFromSuperview()
    }

    private func mainDisplay() {
        globalHomeScreenFav = Utility.readPref("HOMESCREEN_FAV", GlobalVariables.homescreenFavDefault)
        let homescreenFav = WString.split(globalHomeScreenFav, ":")
        textProductLong = [:]
        homescreenFav.forEach { favorite in
            switch favorite {
            case "TXT-CC2":
                boxMain.addLayout(boxCc)
                boxCc.constrain(boxMain)
            case "TXT-HAZ":
                boxMain.addLayout(boxHazards)
                boxHazards.constrain(boxMain)
            case "TXT-7DAY2":
                boxMain.addLayout(boxSevenDay)
                boxSevenDay.constrain(boxMain)
            case "METAL-RADAR":
                cardRadar = CardHomeScreen()
                boxMain.addLayout(cardRadar)
                nexradTab.uiv = self
                nexradTab.getNexradRadar(cardRadar.get())
            default:
                let cardHomeScreen = CardHomeScreen()
                boxMain.addLayout(cardHomeScreen)
                cardHomeScreen.setup(boxMain)
                extraDataCards.append(cardHomeScreen)
                if favorite.hasPrefix("TXT-") {
                    let product = favorite.replace("TXT-", "")
                    getContentText(product, cardHomeScreen)
                } else if favorite.hasPrefix("IMG-") {
                    let product = favorite.replace("IMG-", "")
                    getContentImage(product, cardHomeScreen)
                }
            }
        }
    }

    override func cloudClicked() {
        Route.goes(self)
    }

    override func radarClicked() {
        Route.radarFromMainScreen(self)
    }

    override func wfotextClicked() {
        Route.wfoText(self)
    }

    override func menuClicked() {
        Route.subMenuClicked(self, menuButton)
    }

    override func dashClicked() {
        Route.severeDashboard(self)
    }

    override func willEnterForeground() {
        super.willEnterForeground()
        updateColors()
        if sevenDayCollection != nil && sevenDayCollection!.cardSunRise != nil {
            sevenDayCollection!.cardSunRise!.update()
        }
        scrollView.scrollToTop()
        if downloadTimer.isRefreshNeeded() {
            getContentSuper()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(UIPreferences.backButtonAnimation)
        updateColors()
        locationLabel.text = Location.name
        let newhomeScreenFav = Utility.readPref("HOMESCREEN_FAV", GlobalVariables.homescreenFavDefault)
        let textSizeHasChange = abs(UIPreferences.textviewFontSize - globalTextViewFontSize) > 0.5
        Location.checkCurrentLocationValidity()
        if (Location.latLon != oldLocation) || (newhomeScreenFav != globalHomeScreenFav) || textSizeHasChange || UIPreferences.settingsUIVisitedNeedRefresh {
            UIPreferences.settingsUIVisitedNeedRefresh = false
            scrollView.scrollToTop()
            cardCurrentConditions?.resetTextSize()
            sevenDayCollection?.resetTextSize()
            locationLabel.font = FontSize.extraLarge.size
            getContentSuper()
        }
    }

    func locationChanged(_ locationNumber: Int) {
        if locationNumber < Location.numLocations {
            Location.setCurrentLocationStr(String(locationNumber + 1))
            locationLabel.text = Location.name
            getContentSuper()
        } else {
            Route.locationAdd(self)
        }
    }

    @objc func locationAction() {
        let popUp = PopUp(self, menuButton, "Select location:")
        Location.listOf.enumerated().forEach { index, name in
            popUp.add(Action(name) { self.locationChanged(index) })
        }
        popUp.add(Action("Add location..") { self.locationChanged(Location.numLocations) })
        popUp.finish()
    }

    @objc func ccAction() {
        let popUp = PopUp(self, menuButton, "")
        popUp.add(Action("Edit location..") { Route.locationEdit(self, Location.currentLocationStr) })
        popUp.add(Action("Refresh data") { self.getContentSuper() })
        if UtilitySettings.isRadarInHomeScreen() {
            popUp.add(Action(Location.radarSite + ": " + NexradUtil.getRadarTimeStamp(nexradTab.nexradStateHS.wxMetal[0]!.data.radarBuffers.levelData)) { Route.radarFromMainScreen(self) })
        }
        popUp.finish()
    }

    @objc func gotoHourly() {
        Route.hourly(self)
    }

    func getCurrentConditionCards() {
        if cardCurrentConditions == nil {
            let tapOnCC1 = GestureData(self, #selector(ccAction))
            let tapOnCC2 = GestureData(self, #selector(gotoHourly))
            let tapOnCC3 = GestureData(self, #selector(gotoHourly))
            cardCurrentConditions = CardCurrentConditions(boxCc, currentConditions)
            cardCurrentConditions?.connect(tapOnCC1, tapOnCC2, tapOnCC3)
        } else {
            cardCurrentConditions?.update(currentConditions)
        }
    }

    func getContentText(_ product: String, _ card: CardHomeScreen) {
        _ = FutureText(product.uppercased()) { s in self.displayText(product, card, s) }
    }

    private func displayText(_ product: String, _ card: CardHomeScreen, _ html: String) {
        textProductLong[product] = html
        let text = Text(card, html.truncate(UIPreferences.homescreenTextLength - 1) + GlobalVariables.newline)
        if product == "HOURLY" || UtilityWpcText.needsFixedWidthFont(product.uppercased()) {
            text.font = FontSize.hourly.size
        }
        text.isUserInteractionEnabled = true
        text.connect(GestureData(product, self, #selector(textTap)))
        text.accessibilityLabel = html
        text.isSelectable = false
    }

    @objc func textTap(sender: GestureData) {
        if let v = sender.view as? UITextView {
            let currentLength = v.text!.count
            if currentLength < (UIPreferences.homescreenTextLength + 1) {
                v.text = (textProductLong[sender.strData] ?? "") + GlobalVariables.newline
            } else {
                v.text = (textProductLong[sender.strData] ?? "").truncate(UIPreferences.homescreenTextLength - 1) + GlobalVariables.newline
            }
        }
    }

    func getContentImage(_ product: String, _ card: CardHomeScreen) {
        _ = FutureBytes2({ DownloadImage.byProduct(product) }, { bitmap in self.displayImage(product, card, bitmap) })
    }

    private func displayImage(_ product: String, _ card: CardHomeScreen, _ bitmap: Bitmap) {
        if bitmap.isValid {
            let image = Image(card, bitmap, hs: true)
            image.connect(GestureData(product, self, #selector(imageTap)))
        }
    }

    @objc func imageTap(sender: GestureData) {
        UtilityHomeScreen.jumpToActivity(self, sender.strData)
    }

    func addLocationCard() {
        //
        // location card loaded regardless of settings
        //
        let cardLocation = CardHomeScreen()
        boxMain.addLayout(cardLocation)
        cardLocation.setup(boxMain)
        locationLabel = Text(cardLocation, Location.name, FontSize.extraLarge.size, ColorCompatibility.highlightText)
        locationLabel.connect(GestureData(self, #selector(locationAction)))
        locationLabel.isSelectable = false
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle && UIApplication.shared.applicationState == .inactive {
            updateColors()
        }
    }

    override func updateColors() {
        #if targetEnvironment(macCatalyst)
        #else
        toolbar.setColorToTheme()
        #endif
        locationLabel.color = ColorCompatibility.highlightText
        view.backgroundColor = AppColors.primaryBackgroundBlueUIColor
        setTabBarColor()
    }
}
