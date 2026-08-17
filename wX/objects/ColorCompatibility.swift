// https://noahgilmore.com/blog/dark-mode-uicolor-compatibility/
// Thanks to Noah Gilmore for the article and code found at the URL above
// Backwards compatibility for iOS 13 system colors
// In the distant future when iOS 12 support is dropped simply replace code ColorCompatibility with UIColor

import UIKit

enum ColorCompatibility {

    static var label: UIColor {
        if #available(iOS 13, *) {
            return .label
        }
        return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    }

    static var secondaryLabel: UIColor {
        if #available(iOS 13, *) {
            return .secondaryLabel
        }
        return UIColor(red: 0.6215686274509803, green: 0.6215686274509803, blue: 0.6607843137254902, alpha: 1.0)
    }

    static var systemBackground: UIColor {
        if #available(iOS 13, *) {
            return .systemBackground
        }
        return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }

    static var separator: UIColor {
        if #available(iOS 13, *) {
            return .separator
            // return .systemGray5
        }
        return UIColor(red: 0.32941176470588235, green: 0.32941176470588235, blue: 0.34509803921568627, alpha: 0.6)
    }

    static var link: UIColor {
        if #available(iOS 13, *) {
            return .link
        }
        return UIColor(red: 0.03529411764705882, green: 0.5176470588235295, blue: 1.0, alpha: 1.0)
    }

    static var systemGray2: UIColor {
        if #available(iOS 13, *) {
            return .systemGray2
        }
        return UIColor(red: 0.38823529411764707, green: 0.38823529411764707, blue: 0.4, alpha: 1.0)
    }

    static var systemGray5: UIColor {
        if #available(iOS 13, *) {
            return .systemGray5
        }
        return UIColor(red: 0.17254901960784313, green: 0.17254901960784313, blue: 0.1803921568627451, alpha: 1.0)
    }

    static var highlightText: UIColor {
        if #available(iOS 13, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                return ColorCompatibility.link
            } else {
                return UIColor(red: 0.054901960784313725, green: 0.2784313725490196, blue: 0.6313725490196078, alpha: 1.0)
            }
        }
        return UIColor.blue
    }
}
