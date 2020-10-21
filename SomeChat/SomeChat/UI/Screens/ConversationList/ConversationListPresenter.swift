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
    typealias ConversationListServiceContainer = ImageSourceContainer & MessagesDataServiceContainer
    typealias ConversationListContainer = UserConfigurationContainer & NotificationCenterContainer

    weak var render: ConversationListRender?
    private let messagesService: MessagesDataService
    private let configuration: UserConfiguration
    private let imageSource: ImageSource
    private let notificationCenter: NotificationCenter
    private var searchModel: SearchCellModel?
    private var registration: MessagesDataRegistration?
    private var predicate = ""
    private var channels: [Channel] = []
    
    private var fullName: String {
        let whitespace = CharacterSet.whitespaces
        let fullName = self.configuration.userName?.split(whereSeparator: { character -> Bool in
            var result = false
            character.unicodeScalars.forEach { unicodeScalar in
                if whitespace.contains(unicodeScalar) {
                    result = true
                }
            }
            return result
        })

        let firstName = String(fullName?.first ?? "")
        var array = [firstName]
        if fullName?.count ?? 0 > 1 {
            array.append(String(fullName?.last ?? ""))
        }
        return array.isEmpty ? "" : array.joined(separator: " ")
    }

    init(containerService: ConversationListServiceContainer,
         container: ConversationListContainer) {
        self.messagesService = containerService.messagesDataService
        self.configuration = container.userConfiguration
        self.imageSource = containerService.imageSource
        self.notificationCenter = container.notificationCenter
    }

    deinit {
        self.registration?.registration.remove()
    }

    func start() {
        self.searchModel = SearchCellModel(searchTextDidChange: self.didChangeText())
        self.render?.render(props: self.buildModel())
        self.notificationCenter.addObserver(self,
                                            selector: #selector(updateProfile),
                                            name: .profileDidUpdate,
                                            object: nil)
        self.registration = self.messagesService.listenChannels { [weak self] channels in
            guard let self = self else { return }

            self.channels = channels.sorted(by: { $0.lastActivity?.timeIntervalSince1970 ?? 0 > $1.lastActivity?.timeIntervalSince1970 ?? 0 })
            self.render?.render(props: self.buildModel())
        }
    }

    private func buildModel() -> ConversationsListModel {
        let models = channels
            .map { ConversationViewModel(channelID: $0.identifier,
                                         name: $0.name,
                                         message: $0.lastMessage ?? "",
                                         date: $0.lastActivity,
                                         image: nil) }
            .filter { return self.predicate.isEmpty || $0.name.contains(self.predicate) }
        var cells: [[ConfigurationModel]] = []
        if let searchModel = self.searchModel {
            cells.append([searchModel])
        }
        cells.append(contentsOf: [models])
        var image: UIImage?
        image = self.imageSource.loadImage(withName: ImageSource.userImageName)

        return ConversationsListModel(cells: cells,
                                      fullName: self.fullName,
                                      image: image,
                                      didAddChannel: self.didAddChannel())
    }

    private func didChangeText() -> CommandWith<String> {
        return CommandWith { [weak self] text in
            self?.predicate = text
            if let props = self?.buildModel() {
                self?.render?.render(props: props)
            }
        }
    }

    private func didAddChannel() -> CommandWith<String> {
        return CommandWith { [weak self] text in
            guard let self = self, !text.isEmpty else { return }

            self.messagesService.createChannel(channelName: text, completion: {
                self.render?.render(props: self.buildModel())
            })
        }
    }

    @objc private func updateProfile() {
        DispatchQueue.main.async {
            self.render?.render(props: self.buildModel())
        }
    }
}
