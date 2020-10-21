//
//  MessagesDataService.swift
//  SomeChat
//
//  Created by Алексей Махутин on 18.10.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import Firebase

internal final class MessagesDataService {

    typealias ChannelsBlock = ([Channel]) -> Void
    typealias MessagesBlock = ([Message]) -> Void

    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")

    init() {
//        self.loadMessage(channelId: "KcjiQbfU0kRg1OJW2YJO") { messages in
//            print(messages)
//        }
//        self.sendMsg(channelId: "CD8ADF09-27D0-4110-BE27-F4462FBA79C7", msg: Message(content: "Туда ли попал?", created: Date(), senderId: "666", senderName: "Тест"))
////
//        self.loadMessage(channelId: "ksrMJvro282QzdMTI8d8") { messages in
//            print(messages)
//        }
//////
//        self.laodChannels { channels in
//            channels.forEach { print($0)}
//        }
    }

    func laodChannels(completion: @escaping ChannelsBlock) {
        self.reference.getDocuments { snapshot, error in
            guard error == nil, let snapshot = snapshot else {
                completion([])
                return
            }

            let channels = snapshot.documents.compactMap { channel -> Channel? in
                return Channel(identifier: channel.documentID, dict: channel.data())
            }
            completion(channels)
        }
    }

    func loadMessage(channelId: String, completion: @escaping MessagesBlock) {
        db.collection("channels/\(channelId)/messages").getDocuments { snapshot, error in
            guard error == nil, let snapshot = snapshot else {
                completion([])
                return
            }

            let messages = snapshot.documents.compactMap { msg -> Message? in
                return Message(dict: msg.data())
            }
            completion(messages)
        }
    }

    func sendMsg(channelId: String, msg: Message) {
        let encoder = JSONEncoder()

        if let jsonData = try? encoder.encode(msg),
           let dict = self.jsonDictFromData(data: jsonData, dateKey: "created") {
            db.collection("channels/\(channelId)/messages").addDocument(data: dict)
        }
    }

    private func jsonDictFromData(data: Data, dateKey: String) -> [String: Any]? {
        if var dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            for (key, value) in dict {
                if key == dateKey,
                   let value = value as? Double {
                    dict[key] = Timestamp(date: Date(timeIntervalSince1970: value))
                }
            }
            return dict
        }
        return nil
    }

    private func jsonDataFromDict(dict: [String: Any]) -> Data? {
        var dict = dict
        for (key, value) in dict {
            if let value = value as? Timestamp {
                dict[key] = value.dateValue().timeIntervalSince1970
            }
        }
        return try? JSONSerialization.data(withJSONObject: dict, options: [])
    }
}

struct Channel {
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?

    init?(identifier: String, dict: [String: Any]) {
        guard let name = dict["name"] as? String else { return nil }

        self.identifier = identifier
        self.name = name
        self.lastMessage = dict["lastMessage"] as? String
        self.lastActivity = (dict["lastMessage"] as? Timestamp)?.dateValue()
    }

    var dict: [String: Any] {
        var dictionary: [String: Any] = ["name": self.name]
        if let lastMessage = self.lastMessage {
            dictionary.updateValue(lastMessage, forKey: "lastMessage")
        }
        if let lastActivity = self.lastActivity {
            dictionary.updateValue(Timestamp(date: lastActivity), forKey: "lastActivity")
        }
        return dictionary
    }
}

struct Message {
    let content: String
    let created: Date
    let senderId: String
    let senderName: String

    init?(dict: [String: Any]) {
        guard let content = dict["content"] as? String,
              let created = (dict["created"] as? Timestamp)?.dateValue(),
              let senderId = dict["senderId"] as? String,
              let senderName = dict["senderName"] as? String else { return nil }

        self.content = content
        self.created = created
        self.senderId = senderId
        self.senderName = senderName
    }

    var dict: [String: Any] {
        return [
            "content": self.content,
            "created": Timestamp(date: self.created),
            "senderId": self.senderId,
            "senderName": self.senderName
        ]
    }
}
