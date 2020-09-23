//
//  Command.swift
//  SomeChat
//
//  Created by Алексей Махутин on 22.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import Foundation

internal final class Command {
    let action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
    }

    func callAsFunction() {
        self.action()
    }
}

internal final class CommandWith<T> {
    let action: (T) -> Void

    init(action: @escaping (T) -> Void) {
        self.action = action
    }

    func callAsFunction(with value: T) {
        self.action(value)
    }
}
