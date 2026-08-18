// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import SwiftUI

struct UISpotters: View {

    @State private var spotterData: [Spotter] = []

    init() {
        if #unavailable(iOS 26) {
            UIToolbar.appearance().barTintColor = getColorToThemeAsUIColor()
        }
    }

    var body: some View {

//        @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

        VStack {
            SwiftUI.Text("Test1")
            SwiftUI.Text("Test2")
            Button {

            } label: {
                Spacer()
                SwiftUI.Text("Hello World")
                    .fontWeight(.bold)
                    .font(.system(.title, design: .rounded))
            }
        }

//        NavigationStack {
//            List(spotterData, id: \.lastName) { spotter in
//                VStack(alignment: .leading) {
//                    SwiftUI.Text(spotter.lastName + " " + spotter.firstName)
//                    SwiftUI.Text(spotter.location.prettyPrint())
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
//                }
//            }
//            .onAppear {
//                _ = FutureVoid({ self.spotterData = UtilitySpotter.get() }, {})
//            }
//            .navigationTitle("Spotters")
//            .navigationBarTitleDisplayMode(.inline)
//            .navigationBarBackButtonHidden(false)
//            .toolbar {
//                ToolbarItem(placement: .principal) {
//                    VStack {
//                        SwiftUI.Text("Spotters")
//                            .bold()
//                            .foregroundColor(.white)
//                    }
//                }
//            }
//            .toolbar {
//                ToolbarItem(placement: .bottomBar) {
//                    Button(String(spotterData.count)) {
//                        print("Pressed")
////                        self.presentationMode.wrappedValue.dismiss()
//                    }
//                }
//                ToolbarItem(placement: .bottomBar) {
//                    Button(action: {  }, label: { SwiftUI.Text("Test 2").foregroundColor(.white) })
//                }
//            }
//            .toolbarBackground(getColorToTheme())
//            .toolbarBackground(.visible, for: .navigationBar, .bottomBar)
//        }

    }

    func getColorToTheme() -> SwiftUI.Color {
        return SwiftUI.Color(getColorToThemeAsUIColor())
    }

    func getColorToThemeAsUIColor() -> UIColor {
        return UIColor(
            red: AppColors.primaryColorRed,
            green: AppColors.primaryColorGreen,
            blue: AppColors.primaryColorBlue,
            alpha: CGFloat(1.0)
        )
    }
}

// final class VcSpotters: UIwXViewController {
//
//    private var spotterData = [Spotter]()
//    private var spotterDataSorted = [Spotter]()
//    private var spotterReportsButton = ToolbarIcon()
//    private var spotterCountButton = ToolbarIcon()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        spotterReportsButton = ToolbarIcon(self, #selector(showSpotterReports))
//        spotterReportsButton.title = "Spotter Reports"
//        spotterCountButton = ToolbarIcon(self, #selector(showSpotterReports))
//        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, spotterCountButton, spotterReportsButton]).items
//        objScrollStackView = ScrollStackView(self)
//        boxMain.constrain(self)
//        getContent()
//    }
//
//    override func getContent() {
//        spotterData.removeAll()
//        _ = FutureVoid({ self.spotterData = UtilitySpotter.get() }, display)
//    }
//
//    private func display() {
//        boxMain.removeChildren()
//        spotterCountButton.title = "Count: " + String(spotterData.count)
//        spotterDataSorted = spotterData.sorted { $1.lastName > $0.lastName }
//        spotterDataSorted.enumerated().forEach { index, item in
//            _ = CardSpotter(boxMain, item, GestureData(index, self, #selector(buttonPressed)))
//        }
//    }
//
//    @objc func showSpotterReports() {
//        Route.spotterReports(self)
//    }
//
//    @objc func buttonPressed(sender: GestureData) {
//        let index = sender.data
//        let objectPopUp = PopUp(self, "", spotterReportsButton)
//        objectPopUp.addAction(Action("Show on map") { self.showMap(index) })
//        objectPopUp.finish()
//    }
//
//    func showMap(_ selection: Int) {
//        Route.map(self, spotterDataSorted[selection].location.latString, spotterDataSorted[selection].location.lonString)
//    }
// }
