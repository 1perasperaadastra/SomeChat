//
//  ColorThemesManager.swift
//  SomeChat
//
//  Created by Алексей Махутин on 05.10.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

protocol ColorThemesManagerContainer {
    var colorThemesManager: ColorThemesManager? { get }
}

internal final class ColorThemesManager {

    let userConfiguration: UserConfiguration
    let notificationCenter: NotificationCenter

    var currentTheme: ColorThemes {
        get { Colors.currentTheme }
        set { self.updateColorTheme(theme: newValue) }
    }

    init(container: UserConfigurationContainer & NotificationCenterContainer) {
        self.userConfiguration = container.userConfiguration
        self.notificationCenter = container.notificationCenter

        if let colorThemeNumber = self.userConfiguration.colorTheme {
            Colors.currentTheme = ColorThemes(rawValue: colorThemeNumber) ?? Colors.currentTheme
            self.updateAppearance()
        }
    }

    private func updateColorTheme(theme: ColorThemes) {
        Colors.currentTheme = theme
        self.userConfiguration.colorTheme = Colors.currentTheme.rawValue
        self.notificationCenter.post(name: .didChangeColorTheme, object: nil)
        self.updateAppearance()
    }

    private func updateAppearance() {
        UITableViewCell.appearance().contentView.backgroundColor = Colors.standartBackground()
        UITextView.appearance().textColor = Colors.mainTitle()
        UITextField.appearance().textColor = Colors.mainTitle()
        UILabel.appearance().textColor = Colors.mainTitle()
    }
}
