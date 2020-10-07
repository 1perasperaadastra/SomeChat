//
//  ConversationsListModel.swift
//  SomeChat
//
//  Created by Алексей Махутин on 27.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

struct ConversationsListModel {
    let online: [ConversationViewModel]
    let offline: [ConversationViewModel]
    let fullName: String
    let image: UIImage?
}
