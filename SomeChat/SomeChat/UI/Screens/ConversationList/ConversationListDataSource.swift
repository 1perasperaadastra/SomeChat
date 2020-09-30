//
//  ConversationListDataSource.swift
//  SomeChat
//
//  Created by Алексей Махутин on 27.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

internal final class ConversationListDataSource {
    func buildModels() -> [ConversationViewModel] {
        let models = self.builFirstPart() + self.builSecondPart() + self.builFirstPart() + self.builSecondPart()
        return models.shuffled()
    }

    private func builFirstPart() -> [ConversationViewModel] {
        let bigText = "Reprehenderit mollit excepteur labore deserunt officia laboris eiusmod cillum eu duis"
        return [
            ConversationViewModel(personID: "1",
                                  name: "Ronald Robertson",
                                  message: "An suas viderer pro. Vis cu magna altera, ex his vivendo atomorum.",
                                  date: Date(),
                                  isOnline: true,
                                  hasUnreadMessages: false,
                                  image: UIImage(named: "img1")),
            ConversationViewModel(personID: "2",
                                  name: "Johnny Watson",
                                  message: bigText,
                                  date: Date().addingTimeInterval(-100),
                                  isOnline: true,
                                  hasUnreadMessages: false,
                                  image: UIImage(named: "img2")),
            ConversationViewModel(personID: "3",
                                  name: "Martha Craig",
                                  message: "",
                                  date: Date().addingTimeInterval(-1000),
                                  isOnline: true,
                                  hasUnreadMessages: false,
                                  image: nil),
            ConversationViewModel(personID: "4",
                                  name: "Arthur Bell",
                                  message: "Aliqua mollit nisi incididunt id eu consequat eu cupidatat.",
                                  date: Date().addingTimeInterval(-10000),
                                  isOnline: true,
                                  hasUnreadMessages: true,
                                  image: UIImage(named: "img3")),
            ConversationViewModel(personID: "5",
                                  name: "Jane Warren",
                                  message: "Voluptate irure aliquip consectetur commodo ex ex.",
                                  date: Date().addingTimeInterval(-100000),
                                  isOnline: true,
                                  hasUnreadMessages: false,
                                  image: nil)
        ]
    }

    func builSecondPart() -> [ConversationViewModel] {
        return [
            ConversationViewModel(personID: "6",
                                  name: "Morris Henry",
                                  message: "Ex Lorem veniam veniam irure sunt adipisicing culpa.",
                                  date: Date().addingTimeInterval(-1000000),
                                  isOnline: false,
                                  hasUnreadMessages: false,
                                  image: UIImage(named: "img4")),
            ConversationViewModel(personID: "7",
                                  name: "Irma Flores",
                                  message: "Dolore veniam Lorem occaecat veniam irure laborum est amet.",
                                  date: Date().addingTimeInterval(-100000000),
                                  isOnline: false,
                                  hasUnreadMessages: false,
                                  image: UIImage(named: "img5")),
            ConversationViewModel(personID: "8",
                                  name: "Colin Williams",
                                  message: "Amet enim do laborum tempor nisi aliqua ad adipisicing.",
                                  date: Date().addingTimeInterval(-1000000000),
                                  isOnline: false,
                                  hasUnreadMessages: true,
                                  image: UIImage(named: "img6")),
            ConversationViewModel(personID: "9",
                                  name: "Colin Henry",
                                  message: "Dolore veniam Lorem occaecat veniam irure laborum est amet.",
                                  date: Date().addingTimeInterval(-10000000000),
                                  isOnline: false,
                                  hasUnreadMessages: false,
                                  image: UIImage(named: "img7")),
            ConversationViewModel(personID: "10",
                                  name: "Irma Williams",
                                  message: "",
                                  date: Date().addingTimeInterval(-100000000033),
                                  isOnline: false,
                                  hasUnreadMessages: false,
                                  image: nil)
        ]
    }
}
