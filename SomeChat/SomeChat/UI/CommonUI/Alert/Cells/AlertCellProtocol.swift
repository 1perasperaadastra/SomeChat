//
//  AlertCellProtocol.swift
//  SomeChat
//
//  Created by Алексей Махутин on 06.10.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

internal protocol AlertCellProtocol: UITableViewCell {
    func configurate(model: AlertCellModelProtocol)
}
