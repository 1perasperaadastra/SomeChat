//
//  ConfigurableView.swift
//  SomeChat
//
//  Created by Алексей Махутин on 27.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

internal protocol ConfigurableView: UITableViewCell {
    func configurate(with: ConfigurationModel)
}

internal protocol ConfigurationModel {
    var identifier: String { get }
}
