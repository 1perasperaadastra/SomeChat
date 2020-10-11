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
    private let notificationCenter: NotificationCenter
    private var searchModel: SearchCellModel?
    private var predicate = ""

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
         container: ImageSourceContainer & UserConfigurationContainer & NotificationCenterContainer) {
        self.dataSource = dataSource
        self.configuration = container.userConfiguration
        self.imageSource = container.imageSource
        self.notificationCenter = container.notificationCenter
    }

    func start() {
        self.searchModel = SearchCellModel(searchTextDidChange: self.didChangeText())
        self.render?.render(props: self.buildModel())
        self.notificationCenter.addObserver(self,
                                            selector: #selector(updateProfile),
                                            name: .profileDidUpdate,
                                            object: nil)
    }

    private func buildModel() -> ConversationsListModel {
        var models = self.dataSource.buildModels().filter {
            return self.predicate.isEmpty || $0.name.contains(self.predicate)
        }
        var cells: [[ConfigurationModel]] = []
        if let searchModel = self.searchModel {
            cells.append([searchModel])
        }
        models = models.sorted(by: { first, _ -> Bool in
            return first.isOnline
        })
        cells.append(contentsOf: [models])
        var image: UIImage?
        image = self.imageSource.loadImage(withName: Constants.userAvatarName)

        return ConversationsListModel(cells: cells,
                                      fullName: self.fullName,
                                      image: image)
    }

    private func didChangeText() -> CommandWith<String> {
        return CommandWith { [weak self] text in
            self?.predicate = text
            if let props = self?.buildModel() {
                self?.render?.render(props: props)
            }
        }
    }

    @objc private func updateProfile() {
        DispatchQueue.main.async {
            self.render?.render(props: self.buildModel())
        }
    }
}
