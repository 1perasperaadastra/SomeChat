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
                                   ColorThemesManagerContainer,
                                   AppFileManagerContainer,
                                   GCDProfileDataSourceContainer,
                                   OperationProfileDataSourceContainer {

    private(set) var imageSource: ImageSource
    private(set) var userConfiguration: UserConfiguration
    private(set) var notificationCenter: NotificationCenter
    private(set) var colorThemesManager: ColorThemesManager?
    private(set) var appFileManager: AppFileManager
    private(set) var gcdProfileDataSource: GCDProfileDataSource?
    private(set) var operationProfileDataSource: OperationProfileDataSource?

    init() {
        self.imageSource = ImageSource()
        self.notificationCenter = NotificationCenter.default
        self.userConfiguration = UserConfiguration(with: UserDefaults.standard)
        self.appFileManager = AppFileManager()
        self.colorThemesManager = ColorThemesManager(container: self)
        self.gcdProfileDataSource = GCDProfileDataSource(container: self)
        self.operationProfileDataSource = OperationProfileDataSource(container: self)
    }
}

protocol NotificationCenterContainer {
    var notificationCenter: NotificationCenter { get }
}
