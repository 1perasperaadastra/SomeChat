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

    weak var render: ConversationRender?
    private let dataSource: ConversationDataSource
    private let member: ConversationViewModel

    init(dataSource: ConversationDataSource, member: ConversationViewModel) {
        self.dataSource = dataSource
        self.member = member
    }

    func start() {
        self.render?.render(props: self.buildModel())
    }

    private func buildModel() -> ConversationModel {
        let msg = self.dataSource.loadMessage()
        return ConversationModel(messages: msg,
                                 memberName: self.member.name,
                                 memberImage: self.member.image)
    }
}
