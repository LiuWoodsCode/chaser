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
    private var locationHeaderView = UIView()
    private var locationText = Text()
    private var locationLabel = UILabelInset()
    private var locationIcon = UIImageView()
    private var boxCc = VBox()
    private var boxSevenDay = VBox()
    private var boxHazards = VBox()
    private var homePanelRow = HBox(.fillEqually)
    private var homeLeftPanel = VBox()
    private var homeRightPanel = VBox()
    var cardRadar = CardHomeScreen()
    private var cardCurrentConditions: CardCurrentConditions?
    private var sevenDayCollection: SevenDayCollection?
    private var extraDataCards = [CardHomeScreen]()
    private var toolbar = Toolbar()
    private var globalHomeScreenFav = ""
    private var globalTextViewFontSize: CGFloat = 0.0
    private var globalHomeScreenRedesign = false
    private var globalHomeScreenUsesTwoPanels = false
    private var homeScreenFavHasRightPanelWidgets = false
    private var homeScreenWidgetIndex = 0
    private let homeScreenRedesignInset: CGFloat = 10.0
    private let homeScreenRedesignSpacing: CGFloat = 8.0
    private let downloadTimer = DownloadTimer("MAIN_LOCATION_TAB")
    private var nexradTab = NexradTab()
    #if targetEnvironment(macCatalyst)
    private var oneMinRadarFetch = Timer()
    #endif

    private var homeScreenUsesTwoPanels: Bool {
        guard UIPreferences.homeScreenRedesign else { return false }
        #if targetEnvironment(macCatalyst)
        return true
        #else
        return UIDevice.current.userInterfaceIdiom == .pad
        #endif
    }

    private var homeScreenHorizontalPadding: CGFloat {
        UIPreferences.homeScreenRedesign ? homeScreenRedesignInset : 0.0
    }

    private var homeScreenWidgetSpacing: CGFloat {
        UIPreferences.homeScreenRedesign ? homeScreenRedesignSpacing : UIPreferences.stackviewCardSpacing
    }

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
        boxMain.getView().backgroundColor = UIPreferences.homeScreenRedesign ? AppColors.primaryBackgroundBlueUIColor : ColorCompatibility.systemGray5
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
        resetHomeScreenLayout()
        getForecastData()
        mainDisplay()
    }

    private func resetHomeScreenLayout() {
        boxMain.removeArrangedViews()
        boxMain.get().spacing = homeScreenWidgetSpacing
        boxMain.getView().backgroundColor = UIPreferences.homeScreenRedesign ? AppColors.primaryBackgroundBlueUIColor : ColorCompatibility.systemGray5
        boxCc = VBox()
        boxSevenDay = VBox()
        boxHazards = VBox()
        boxHazards.isHidden = true
        homePanelRow = HBox(.fillEqually, homeScreenWidgetSpacing)
        homeLeftPanel = VBox()
        homeRightPanel = VBox()
        homeLeftPanel.spacing = homeScreenWidgetSpacing
        homeRightPanel.spacing = homeScreenWidgetSpacing
        cardRadar = CardHomeScreen()
        cardCurrentConditions = nil
        sevenDayCollection = nil
        extraDataCards.removeAll()
        addLocationCard()
        if homeScreenUsesTwoPanels {
            setupHomeScreenPanels()
        }
        globalHomeScreenRedesign = UIPreferences.homeScreenRedesign
        globalHomeScreenUsesTwoPanels = homeScreenUsesTwoPanels
        globalTextViewFontSize = UIPreferences.textviewFontSize
    }

    private func setupHomeScreenPanels() {
        homePanelRow.get().translatesAutoresizingMaskIntoConstraints = false
        homePanelRow.alignment = .top
        homeLeftPanel.get().translatesAutoresizingMaskIntoConstraints = false
        homeRightPanel.get().translatesAutoresizingMaskIntoConstraints = false
        homePanelRow.addLayout(homeLeftPanel)
        homePanelRow.addLayout(homeRightPanel)
        boxMain.addLayout(homePanelRow)
        homePanelRow.get().widthAnchor.constraint(equalTo: boxMain.widthAnchor, constant: -2.0 * homeScreenRedesignInset).isActive = true
    }

    private func addHomeBox(_ layout: VBox, for favorite: String) {
        if homeScreenUsesTwoPanels {
            let panel = homeScreenPanel(for: favorite)
            panel.addLayout(layout)
            layout.widthAnchor.constraint(equalTo: panel.widthAnchor).isActive = true
        } else {
            boxMain.addLayout(layout)
            layout.widthAnchor.constraint(equalTo: boxMain.widthAnchor, constant: -2.0 * homeScreenHorizontalPadding).isActive = true
        }
        homeScreenWidgetIndex += 1
    }

    private func addHomeCard(_ card: CardHomeScreen, for favorite: String) {
        if homeScreenUsesTwoPanels {
            let panel = homeScreenPanel(for: favorite)
            panel.addLayout(card)
            card.setupWithPadding(panel, redesign: UIPreferences.homeScreenRedesign)
        } else {
            boxMain.addLayout(card)
            card.setupWithPadding(
                boxMain,
                horizontalPadding: homeScreenHorizontalPadding,
                redesign: UIPreferences.homeScreenRedesign
            )
        }
        homeScreenWidgetIndex += 1
    }

    private func homeScreenPanel(for favorite: String) -> VBox {
        if shouldPlaceInRightPanel(favorite) {
            return homeRightPanel
        }
        return homeLeftPanel
    }

    private func shouldPlaceInRightPanel(_ favorite: String) -> Bool {
        if isRightPanelPreferredWidget(favorite) {
            return true
        }
        if homeScreenFavHasRightPanelWidgets {
            return false
        }
        return homeScreenWidgetIndex % 2 == 1
    }

    private func isRightPanelPreferredWidget(_ favorite: String) -> Bool {
        favorite == "METAL-RADAR" || favorite.hasPrefix("IMG-")
    }

    private func homeScreenRadarWidth() -> CGFloat {
        let (defaultWidth, _) = UtilityUI.getScreenBoundsCGFloat()
        let baseWidth = view.bounds.width > 0.0 ? view.bounds.width : defaultWidth
        if homeScreenUsesTwoPanels {
            return max((baseWidth - (homeScreenRedesignInset * 2.0) - homeScreenRedesignSpacing) / 2.0, 1.0)
        }
        if UIPreferences.homeScreenRedesign {
            return max(baseWidth - (homeScreenRedesignInset * 2.0), 1.0)
        }
        return max(baseWidth, 1.0)
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
                sevenDay,
                useHomeScreenRedesign: UIPreferences.homeScreenRedesign)
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
        CardHazards.get(self, boxHazards, hazards, useHomeScreenRedesign: UIPreferences.homeScreenRedesign)
    }

    private func mainDisplay() {
        globalHomeScreenFav = Utility.readPref("HOMESCREEN_FAV", GlobalVariables.homescreenFavDefault)
        let homescreenFav = WString.split(globalHomeScreenFav, ":")
        homeScreenFavHasRightPanelWidgets = homescreenFav.contains { isRightPanelPreferredWidget($0) }
        homeScreenWidgetIndex = 0
        textProductLong = [:]
        homescreenFav.forEach { favorite in
            switch favorite {
            case "TXT-CC2":
                addHomeBox(boxCc, for: favorite)
            case "TXT-HAZ":
                addHomeBox(boxHazards, for: favorite)
            case "TXT-7DAY2":
                addHomeBox(boxSevenDay, for: favorite)
            case "METAL-RADAR":
                cardRadar = CardHomeScreen()
                addHomeCard(cardRadar, for: favorite)
                nexradTab.uiv = self
                nexradTab.getNexradRadar(cardRadar.get(), width: homeScreenRadarWidth())
            default:
                let cardHomeScreen = CardHomeScreen()
                addHomeCard(cardHomeScreen, for: favorite)
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
        updateLocationHeaderText()
        let newhomeScreenFav = Utility.readPref("HOMESCREEN_FAV", GlobalVariables.homescreenFavDefault)
        let textSizeHasChange = abs(UIPreferences.textviewFontSize - globalTextViewFontSize) > 0.5
        let homeScreenRedesignHasChanged = UIPreferences.homeScreenRedesign != globalHomeScreenRedesign
        let homeScreenPanelLayoutHasChanged = homeScreenUsesTwoPanels != globalHomeScreenUsesTwoPanels
        Location.checkCurrentLocationValidity()
        if (Location.latLon != oldLocation)
            || (newhomeScreenFav != globalHomeScreenFav)
            || textSizeHasChange
            || homeScreenRedesignHasChanged
            || homeScreenPanelLayoutHasChanged
            || UIPreferences.settingsUIVisitedNeedRefresh {
            UIPreferences.settingsUIVisitedNeedRefresh = false
            scrollView.scrollToTop()
            cardCurrentConditions?.resetTextSize()
            sevenDayCollection?.resetTextSize()
            locationText.font = FontSize.extraLarge.size
            locationLabel.font = FontSize.extraLarge.size
            getContentSuper()
        }
    }

    func locationChanged(_ locationNumber: Int) {
        if locationNumber < Location.numLocations {
            Location.setCurrentLocationStr(String(locationNumber + 1))
            updateLocationHeaderText()
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
            cardCurrentConditions = CardCurrentConditions(
                boxCc,
                currentConditions,
                useHomeScreenRedesign: UIPreferences.homeScreenRedesign
            )
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
        let cardLocation = CardHomeScreen()
        boxMain.addLayout(cardLocation)
        cardLocation.setup(boxMain, horizontalPadding: homeScreenHorizontalPadding, redesign: false)
        configureLocationLabel(redesign: UIPreferences.homeScreenRedesign)
        if UIPreferences.homeScreenRedesign {
            addCenteredLocationHeader(to: cardLocation)
        } else {
            locationText = Text(cardLocation, Location.name, FontSize.extraLarge.size, ColorCompatibility.highlightText)
            locationText.connect(GestureData(self, #selector(locationAction)))
            locationText.isSelectable = false
        }
    }

    private func configureLocationLabel(redesign: Bool) {
        locationLabel = UILabelInset()
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.text = Location.name
        locationLabel.font = FontSize.extraLarge.size
        locationLabel.textColor = redesign ? ColorCompatibility.label : ColorCompatibility.highlightText
        locationLabel.textAlignment = redesign ? .center : .left
        locationLabel.adjustsFontSizeToFitWidth = true
        locationLabel.minimumScaleFactor = 0.75
        locationLabel.numberOfLines = 2
        locationLabel.isUserInteractionEnabled = !redesign
        locationLabel.accessibilityTraits = .button
    }

    private func addCenteredLocationHeader(to cardLocation: CardHomeScreen) {
        locationHeaderView = UIView()
        locationHeaderView.translatesAutoresizingMaskIntoConstraints = false
        locationHeaderView.isUserInteractionEnabled = true
        locationHeaderView.isAccessibilityElement = true
        locationHeaderView.accessibilityLabel = Location.name
        locationHeaderView.accessibilityTraits = .button
        locationHeaderView.addGestureRecognizer(GestureData(self, #selector(locationAction)))

        locationIcon = UIImageView(image: UIImage(systemName: "location.fill")?.withRenderingMode(.alwaysTemplate))
        locationIcon.translatesAutoresizingMaskIntoConstraints = false
        locationIcon.tintColor = ColorCompatibility.label
        locationIcon.contentMode = .scaleAspectFit
        locationIcon.widthAnchor.constraint(equalToConstant: 24.0).isActive = true
        locationIcon.heightAnchor.constraint(equalToConstant: 24.0).isActive = true

        let headerStack = UIStackView(arrangedSubviews: [locationIcon, locationLabel])
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        headerStack.axis = .horizontal
        headerStack.alignment = .center
        headerStack.spacing = 8.0
        headerStack.isUserInteractionEnabled = false
        locationHeaderView.addSubview(headerStack)
        cardLocation.addWidget(locationHeaderView)
        NSLayoutConstraint.activate([
            locationHeaderView.widthAnchor.constraint(equalTo: cardLocation.widthAnchor),
            headerStack.topAnchor.constraint(equalTo: locationHeaderView.topAnchor, constant: 8.0),
            headerStack.bottomAnchor.constraint(equalTo: locationHeaderView.bottomAnchor, constant: -8.0),
            headerStack.centerXAnchor.constraint(equalTo: locationHeaderView.centerXAnchor),
            headerStack.leadingAnchor.constraint(greaterThanOrEqualTo: locationHeaderView.leadingAnchor, constant: 12.0),
            headerStack.trailingAnchor.constraint(lessThanOrEqualTo: locationHeaderView.trailingAnchor, constant: -12.0)
        ])
    }

    private func updateLocationHeaderText() {
        locationText.text = Location.name
        locationLabel.text = Location.name
        locationHeaderView.accessibilityLabel = Location.name
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            if UIPreferences.homeScreenRedesign {
                self.scrollView.scrollToTop()
                self.getContentSuper()
            }
        }
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
        locationText.color = ColorCompatibility.highlightText
        locationLabel.textColor = UIPreferences.homeScreenRedesign ? ColorCompatibility.label : ColorCompatibility.highlightText
        locationIcon.tintColor = locationLabel.textColor
        view.backgroundColor = AppColors.primaryBackgroundBlueUIColor
        boxMain.getView().backgroundColor = UIPreferences.homeScreenRedesign ? AppColors.primaryBackgroundBlueUIColor : ColorCompatibility.systemGray5
        setTabBarColor()
    }
}
