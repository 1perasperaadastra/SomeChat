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
    private enum Constants {
        static let themeName = "theme.txt"
    }

    private let fileManager: AppFileManager
    private let notificationCenter: NotificationCenter
    private let queue = DispatchQueue(label: "com.ColorThemesManager", qos: .userInteractive)

    var currentTheme: ColorThemes {
        get { Colors.currentTheme }
        set { self.updateColorTheme(theme: newValue) }
    }

    init(container: AppFileManagerContainer & NotificationCenterContainer) {
        self.fileManager = container.appFileManager
        self.notificationCenter = container.notificationCenter

        self.queue.async {
            if let data = self.fileManager.load(fileName: Constants.themeName),
               let themeRaw = Int(String(data: data, encoding: .utf8) ?? "") {
                Colors.currentTheme = ColorThemes(rawValue: themeRaw) ?? Colors.currentTheme
                self.updateAppearance()
            }
        }
    }

    private func updateColorTheme(theme: ColorThemes) {
        Colors.currentTheme = theme
        self.queue.async {
            if let data = String(Colors.currentTheme.rawValue).data(using: .utf8) {
                let result = self.fileManager.save(fileName: Constants.themeName, data: data)
                if result == .error {
                    Logger.error("error when save theme")
                }
            }
        }
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
