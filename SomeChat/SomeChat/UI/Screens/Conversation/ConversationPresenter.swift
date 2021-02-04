//
//  ConversationPresenter.swift
//  SomeChat
//
//  Created by Алексей Махутин on 29.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import Foundation

protocol ConversationRender: class {
    func render(props: ConversationModel)
}

internal final class ConversationPresenter {
    typealias ConversationContainer = MessagesDataServiceContainer

    weak var render: ConversationRender?
    private let messagesService: MessagesDataService
    private let member: ConversationViewModel
    private var registration: MessagesDataRegistration?
    private var messages: [Message] = []

    init(container: ConversationContainer, member: ConversationViewModel) {
        self.messagesService = container.messagesDataService
        self.member = member
    }

    deinit {
        self.registration?.registration.remove()
    }

    func start() {
        self.registration = self.messagesService.listenMessage(channelId: self.member.channelID) { [weak self] messages in
            guard let self = self else { return }

            self.messages = messages.sorted(by: { $0.created < $1.created })
            self.render?.render(props: self.buildModel())
        }
        self.render?.render(props: self.buildModel())
    }

    private func buildModel() -> ConversationModel {
        let models = self.messages.map { messageModel -> ConversationMessageModel in
            let isMyMessage = messageModel.isMyMessage
            let messageCellModel = MessageCellModel(text: messageModel.content, userName: messageModel.senderName, incoming: !isMyMessage)
            return ConversationMessageModel(type: isMyMessage ? .outgoing : .incoming, cellModel: messageCellModel)
        }
        return ConversationModel(messages: models,
                                 memberName: self.member.name,
                                 memberImage: self.member.image,
                                 userDidEndMessage: self.userDidSendMessage())
    }

    private func userDidSendMessage() -> CommandWith<String> {
        return CommandWith { [weak self] text in
            guard let self = self else { return }

            self.messagesService.sendMsg(channelId: self.member.channelID, msg: text, completion: {
                self.render?.render(props: self.buildModel())
            })
        }
    }
}
