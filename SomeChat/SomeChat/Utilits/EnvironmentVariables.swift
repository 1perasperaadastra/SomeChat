//
//  EnvironmentVariables.swift
//  SomeChat
//
//  Created by Алексей Махутин on 12.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import Foundation

enum EnvironmentVariables: String {
    case LOGGER

    var value: String {
        return ProcessInfo.processInfo.environment[rawValue] ?? ""
    }
}
