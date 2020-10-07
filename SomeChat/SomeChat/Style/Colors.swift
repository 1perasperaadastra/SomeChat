//
//  Colors.swift
//  SomeChat
//
//  Created by Алексей Махутин on 04.10.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

enum ColorThemes: Int {
    case classic = 1
    case day = 2
    case night = 3
}

extension UITraitCollection {
    var colorTheme: ColorThemes {
        return Colors.currentTheme
    }
}

protocol ColorThemesNotification {
    func didChangeColorTheme()
}

extension Notification.Name {
    static let didChangeColorTheme = Notification.Name("didChangeColorTheme")
}

enum Colors {
    static var currentTheme = ColorThemes.classic

    case standartBackground
    case navigationBar
    case mainTitle
    case secondTitle
    case messageIn
    case messageOut
    case mainTint
    case messageInputField
    case searchBackground
    case buttonBackground
    case navBarButtonColor

    func callAsFunction(theme: ColorThemes = Colors.currentTheme) -> UIColor {
        switch self {
        case .standartBackground:
            switch theme {
            case .night: return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            default: return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        case .navigationBar:
            switch theme {
            case .night: return #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1176470588, alpha: 1)
            default: return #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
            }
        case .mainTitle:
            switch theme {
            case .night: return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            default: return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        case .secondTitle:
            switch theme {
            case .night: return #colorLiteral(red: 0.5529411765, green: 0.5529411765, blue: 0.5764705882, alpha: 1)
            default: return #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.262745098, alpha: 0.6)
            }
        case .messageIn:
            switch theme {
            case .day: return #colorLiteral(red: 0.9176470588, green: 0.9215686275, blue: 0.9294117647, alpha: 1)
            case .night: return #colorLiteral(red: 0.1803921569, green: 0.1803921569, blue: 0.1803921569, alpha: 1)
            default: return #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
            }
        case .messageOut:
            switch theme {
            case .day: return #colorLiteral(red: 0.262745098, green: 0.537254902, blue: 0.9764705882, alpha: 1)
            case .night: return #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)
            default: return #colorLiteral(red: 0.862745098, green: 0.968627451, blue: 0.7725490196, alpha: 1)
            }
        case .mainTint:
            return .systemBlue
        case .messageInputField:
            switch theme {
            case .night: return #colorLiteral(red: 0.231372549, green: 0.231372549, blue: 0.231372549, alpha: 1)
            default: return #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            }
        case .searchBackground:
            switch theme {
            case .night: return #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
            default: return #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
            }
        case .buttonBackground:
            switch theme {
            case .night: return #colorLiteral(red: 0.1058823529, green: 0.1058823529, blue: 0.1058823529, alpha: 1)
            default: return #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
            }
        case .navBarButtonColor:
            switch theme {
            case .night: return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            default: return #colorLiteral(red: 0.3294117647, green: 0.3294117647, blue: 0.3450980392, alpha: 0.65)
            }
        }
    }
}
