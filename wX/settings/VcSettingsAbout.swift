// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit
import SwiftUI

final class VcSettingsAbout: UIwXViewController {

    private let faqUrl = "https://gitlab.com/joshua.tee/wxl23/-/tree/master/doc/FAQ.md"
    private let releaseNotesUrl = "https://gitlab.com/joshua.tee/wxl23/-/tree/master/doc/ChangeLog_User.md"
    private let dataProviderUrl = "https://gitlab.com/joshua.tee/wxl23/-/blob/master/doc/data_sources.md"
    private static let copyright = "©"
    private let aboutText = GlobalVariables.appName + " is an efficient and configurable method to access weather content from the "
        + "National Weather Service and NSSL WRF."
        + " Software is provided \"as is\". Use at your own risk. Use for educational purposes "
        + "and non-commercial purposes only. Do not use for operational purposes.  "
        + copyright
        + "2016-2024 " + GlobalVariables.appCreatorEmail + " . Please report bugs or suggestions "
        + "via email to me as opposed to app store reviews. "
        + GlobalVariables.appName + " is bi-licensed under the Mozilla Public License Version 2 as well "
        + "as the GNU General Public License Version 3 or later. "
        + "For more information on the licenses please go here: https://www.mozilla.org/en-US/MPL/2.0/"
        + " and http://www.gnu.org/licenses/gpl-3.0.en.html" + GlobalVariables.newline
    private var statusButton = ToolbarIcon()

    override func viewDidLoad() {
        super.viewDidLoad()
        statusButton = ToolbarIcon("", self, nil, isLabel: true)
        toolbar.items = ToolbarItems(doneButton, GlobalVariables.flexBarButton, statusButton).items
        objScrollStackView = ScrollStackView(self)
        boxMain.constrain(self)
        display()
    }

    @objc func actionClick(sender: GestureData) {
        switch sender.strData {
        case "faq":
            Route.web(self, faqUrl)
        case "notes":
            Route.web(self, releaseNotesUrl)
        case "dataProvider":
            Route.web(self, dataProviderUrl)
        default:
            break
        }
    }

    private func display() {
        statusButton.setText("version: " + UtilityUI.getVersion())
        let text1 = Text(
            boxMain,
            "View FAQ",
            FontSize.extraLarge.size,
            GestureData("faq", self, #selector(actionClick))
        )
        text1.color = ColorCompatibility.highlightText
        text1.isSelectable = false

        let text2 = Text(
            boxMain,
            "View Release Notes",
            FontSize.extraLarge.size,
            GestureData("notes", self, #selector(actionClick))
        )
        text2.color = ColorCompatibility.highlightText
        text2.isSelectable = false

        let text3 = Text(
            boxMain,
            "View Data Provider: NWS",
            FontSize.extraLarge.size,
            GestureData("dataProvider", self, #selector(actionClick))
        )
        text3.color = ColorCompatibility.highlightText
        text3.isSelectable = false

        _ = Text(
            boxMain,
            aboutText + Utility.showDiagnostics(),
            FontSize.medium.size,
            GestureData("", self, #selector(actionClick))
        )
    }
}

// struct VcSettingsAbout: View {
//    var body: some View {
//        
//        VStack {
//            SwiftUI.Text("Test1")
//            SwiftUI.Text("Test2")
//            Button {
//                
//            } label: {
//                Spacer()
//                SwiftUI.Text("Hello World")
//                    .fontWeight(.bold)
//                    .font(.system(.title, design: .rounded))
//            }
//        }
//    }
// }
