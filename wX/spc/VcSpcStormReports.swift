// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcSpcStormReports: UIwXViewController {

    private var image = Image()
    private let datePicker =  DatePicker()
    private var stormReports = [StormReport]()
    private var html = ""
    private var date = ""
    private var imageUrl = ""
    private var textUrl = ""
    private var bitmap = Bitmap()
    private var stateCount = [String: Int]()
    private var filterList = [String]()
    private var filter = "All"
    private var filterButton = ToolbarIcon()
    private var lsrButton = ToolbarIcon()
    var spcStormReportsDay = ""
    private var boxImage = VBox()
    private var boxText = VBox()

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        lsrButton = ToolbarIcon("LSR by WFO", self, #selector(lsrClicked))
        filterButton = ToolbarIcon("Filter: " + filter, self, #selector(filterClicked))
        toolbar.items = ToolbarItems(
            doneButton,
            GlobalVariables.flexBarButton,
            filterButton,
            lsrButton,
            shareButton).items
        boxText.spacing = 1.0
        objScrollStackView = ScrollStackView(self)
        boxMain.addLayout(boxImage)
        boxMain.addLayout(boxText)
        boxImage.constrain(self)
        boxText.constrain(self)
        boxImage.addWidget(datePicker)
        datePicker.connect(self, #selector(onDateChanged))
        image = Image(boxImage)
        imageUrl = GlobalVariables.nwsSPCwebsitePrefix + "/climo/reports/" + spcStormReportsDay + ".gif"
        textUrl = GlobalVariables.nwsSPCwebsitePrefix + "/climo/reports/" + spcStormReportsDay + ".csv"

        lsrButton.setText("LSR by WFO")
        filterButton.setText("Filter: ")
        getContent()
    }

    override func getContent() {
        _ = FutureVoid(downloadImage, displayImage)
        _ = FutureVoid(downloadText, displayText)
    }

    private func downloadImage() {
        bitmap = Bitmap(imageUrl)
        bitmap.url = imageUrl
    }

    private func downloadText() {
        html = textUrl.getHtml()
        stormReports = UtilitySpcStormReports.process(html.split(GlobalVariables.newline))
    }

    @objc func imgClicked() {
        Route.imageViewer(self, imageUrl)
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.image(self, sender, [image.getBitmap()], html)
    }

    @objc func gotoMap(sender: GestureData) {
        Route.map(self, stormReports[sender.data].lat, stormReports[sender.data].lon)
    }

    @objc func onDateChanged(_: UIDatePicker) {
        let myDateFormatter: DateFormatter = DateFormatter()
        myDateFormatter.dateFormat = "MM/dd/yyyy"
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let components = datePicker.calendar.dateComponents(
            [.day, .month, .year],
            from: datePicker.date as Date
        )
        let day = To.stringPadLeftZeros(components.day!, 2)
        let month = To.stringPadLeftZeros(components.month!, 2)
        let year = String(components.year!).substring(2)
        date = year + month + day
        imageUrl = GlobalVariables.nwsSPCwebsitePrefix + "/climo/reports/" + date + "_rpts.gif"
        textUrl = GlobalVariables.nwsSPCwebsitePrefix + "/climo/reports/" + date + "_rpts.csv"
        boxImage.removeChildren()
        boxImage.addWidget(datePicker)
        boxImage.addWidget(image)
        getContent()
    }

    @objc func lsrClicked() {
        Route.lsrByWfo(self)
    }

    @objc func filterClicked() {
        _ = PopUp(self, title: "Filter Selection", filterButton, filterList, changeFilter)
    }

    private func changeFilter(_ index: Int) {
        filter = filterList[index].split(":")[0]
        filterButton.setText("Filter: " + filter)
        displayImage()
        displayText()
    }

    private func displayImage() {
        image.set(bitmap)
        image.connect(GestureData(self, #selector(imgClicked)))
    }

    private func displayText() {
        boxText.removeChildren()
        var stateList = [String]()
        filterList = ["All"]
        stormReports.enumerated().forEach { index, stormReport in
            if stormReport.damageHeader != "" {
                switch stormReport.damageHeader {
                case "Tornado Reports":
                    _ = CardBlackHeaderText(boxText, stormReport.damageHeader)
                case "Wind Reports":
                    _ = CardBlackHeaderText(boxText, stormReport.damageHeader)
                case "Hail Reports":
                    _ = CardBlackHeaderText(boxText, stormReport.damageHeader)
                default:
                    break
                }
            }
            if stormReport.damageHeader == "" && (filter == "All" || filter == stormReport.state) {
                _ = CardStormReportItem(boxText, stormReport, GestureData(index, self, #selector(gotoMap)))
            }
            if stormReport.state != "" {
                stateList += [stormReport.state]
            }
        }
        let mappedItems = stateList.map { ($0, 1) }
        stateCount = Dictionary(mappedItems, uniquingKeysWith: +)
        let sortedKeys = stateCount.keys.sorted()
        for key in sortedKeys {
            let val = stateCount[key] ?? 0
            filterList += [key + ": " + String(val)]
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in
            self.displayImage()
            self.displayText()
        }
    }
}
