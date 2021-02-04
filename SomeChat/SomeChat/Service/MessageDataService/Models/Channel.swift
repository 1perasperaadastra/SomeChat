//
//  Channel.swift
//  SomeChat
//
//  Created by Алексей Махутин on 21.10.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import Firebase

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
        self.lastActivity = (dict["lastActivity"] as? Timestamp)?.dateValue()
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
