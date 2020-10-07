//
//  AppContainer.swift
//  SomeChat
//
//  Created by Алексей Махутин on 04.10.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import Foundation

internal final class AppContainer: ImageSourceContainer,
                                   UserConfigurationContainer,
                                   NotificationCenterContainer,
                                   ColorThemesManagerContainer {

    private(set) var imageSource: ImageSource
    private(set) var userConfiguration: UserConfiguration
    private(set) var notificationCenter: NotificationCenter
    private(set) var colorThemesManager: ColorThemesManager?

    init() {
        self.imageSource = ImageSource()
        self.notificationCenter = NotificationCenter.default
        self.userConfiguration = UserConfiguration(with: UserDefaults.standard)
        self.colorThemesManager = ColorThemesManager(container: self)
    }
}

protocol NotificationCenterContainer {
    var notificationCenter: NotificationCenter { get }
}
