//
//  MessagesDataService.swift
//  SomeChat
//
//  Created by Алексей Махутин on 18.10.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import Firebase

protocol MessagesDataServiceContainer {
    var messagesDataService: MessagesDataService { get }
}

internal struct MessagesDataRegistration {
    let registration: ListenerRegistration
}

internal final class MessagesDataService {

    typealias ChannelsBlock = ([Channel]) -> Void
    typealias MessagesBlock = ([Message]) -> Void
    typealias CompletionBlock = () -> Void

    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection("channels")
    private let userConfiguration: UserConfiguration

    init(userConfiguration: UserConfiguration) {
        self.userConfiguration = userConfiguration
    }

    func listenChannels(updateBlock: @escaping ChannelsBlock) -> MessagesDataRegistration {
        let registration = self.reference.addSnapshotListener { snapshot, error in
            guard error == nil, let snapshot = snapshot else {
                updateBlock([])
                return
            }

            let channels = snapshot.documents.compactMap { channel -> Channel? in
                return Channel(identifier: channel.documentID, dict: channel.data())
            }
            updateBlock(channels)
        }
        return MessagesDataRegistration(registration: registration)
    }

    func listenMessage(channelId: String, updateBlock: @escaping MessagesBlock) -> MessagesDataRegistration {
        let registration = db.collection("channels/\(channelId)/messages").addSnapshotListener { snapshot, error in
            guard error == nil, let snapshot = snapshot else {
                updateBlock([])
                return
            }

            let messages = snapshot.documents.compactMap { msg -> Message? in
                return Message(dict: msg.data())
            }
            updateBlock(messages)
        }
        return MessagesDataRegistration(registration: registration)
    }

    func sendMsg(channelId: String, msg: String, completion: @escaping CompletionBlock) {
        let senderName = self.userConfiguration.userName ?? "Unknown"
        let uuid = self.userConfiguration.uuid
        let msg = Message(content: msg, created: Date(), senderId: uuid, senderName: senderName)
        db.collection("channels/\(channelId)/messages").addDocument(data: msg.dict) { _ in
            completion()
        }
    }

    func createChannel(channelName: String, completion: @escaping CompletionBlock) {
        self.reference.addDocument(data: ["name": channelName]) { _ in
            completion()
        }
    }
}
