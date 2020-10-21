//
//  AlertCellModel.swift
//  SomeChat
//
//  Created by Алексей Махутин on 06.10.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import Foundation

internal protocol AlertCellModelProtocol {
    var identifier: String { get }
}

internal struct AlertTitleModel: AlertCellModelProtocol {
    var identifier: String {
        return String(describing: AlertTitleCell.self)
    }

    let mainTitle: String
    let secondTitle: String
}

internal struct AlertActionModel: AlertCellModelProtocol {
    var identifier: String {
        return String(describing: AlertActionCell.self)
    }

    let mainTitle: String
    let action: Command
}
