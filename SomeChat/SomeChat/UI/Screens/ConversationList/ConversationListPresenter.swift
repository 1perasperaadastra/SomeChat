//
//  ConversationListPresenter.swift
//  SomeChat
//
//  Created by Алексей Махутин on 29.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

protocol ConversationListRender: class {
    func render(props: ConversationsListModel)
}

internal final class ConversationListPresenter {
    private enum Constants {
        static let userAvatarName = "user.jpeg"
    }

    weak var render: ConversationListRender?
    private let dataSource: ConversationListDataSource
    private let configuration: UserConfiguration
    private let imageSource: ImageSource

    private var fullName: String {
        var firstName: String?
        if self.configuration.userFistName?.count ?? 0 > 2 {
            firstName = self.configuration.userFistName
        }
        var secondName: String?
        if self.configuration.userLastName?.count ?? 0 > 2 {
            secondName = self.configuration.userLastName
        }
        var array: [String] = []
        if let firstName = firstName {
            array.append(firstName)
        }
        if let secondName = secondName {
            array.append(secondName)
        }
        return array.isEmpty ? "" : array.joined(separator: " ")
    }

    init(dataSource: ConversationListDataSource,
         configuration: UserConfiguration,
         imageSource: ImageSource) {
        self.dataSource = dataSource
        self.configuration = configuration
        self.imageSource = imageSource
    }

    func start() {
        self.render?.render(props: self.buildModel())
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateProfile),
                                               name: .profileDidUpdate,
                                               object: nil)
    }

    private func buildModel() -> ConversationsListModel {
        let models = self.dataSource.buildModels()
        var onlineModels = [ConversationViewModel]()
        var offlineModels = [ConversationViewModel]()
        models.forEach { model in
            model.isOnline ? onlineModels.append(model) : offlineModels.append(model)
        }
        var image: UIImage?
        if self.configuration.userAvatarExist {
            image = self.imageSource.loadImage(withName: Constants.userAvatarName)
        }
        return ConversationsListModel(online: onlineModels,
                                      offline: offlineModels,
                                      fullName: self.fullName,
                                      image: image)
    }

    @objc private func updateProfile() {
        self.render?.render(props: self.buildModel())
    }
}
