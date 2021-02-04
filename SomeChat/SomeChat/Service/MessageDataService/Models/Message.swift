//
//  Message.swift
//  SomeChat
//
//  Created by Алексей Махутин on 21.10.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import Firebase

struct Message {
    let content: String
    let created: Date
    let senderId: String
    let senderName: String

    init(content: String,
         created: Date,
         senderId: String,
         senderName: String) {
        self.content = content
        self.created = created
        self.senderId = senderId
        self.senderName = senderName
    }

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

    var isMyMessage: Bool {
        guard let udid = UIDevice.current.identifierForVendor?.uuidString else { return false }
        return self.senderId == udid
    }
}
