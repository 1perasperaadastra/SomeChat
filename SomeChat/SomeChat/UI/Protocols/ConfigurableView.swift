//
//  ConfigurableView.swift
//  SomeChat
//
//  Created by Алексей Махутин on 27.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import Foundation

internal protocol ConfigurableView {

    associatedtype ConfigurationModel

    func configurate(with: ConfigurationModel)
}
