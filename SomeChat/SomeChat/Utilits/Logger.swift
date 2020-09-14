//
//  Logger.swift
//  SomeChat
//
//  Created by Алексей Махутин on 12.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import Foundation
import os.log

internal final class Logger {

    static var isOn: Bool = EnvironmentVariables.LOGGER.value == "1"

    static func debug(_ str: String) {
        self.log(str, type: .debug)
    }

    static func error(_ str: String) {
        self.log(str, type: .error)
    }

    static func info(_ str: String) {
        self.log(str, type: .info)
    }

    fileprivate static func log(_ message: String, type: OSLogType) {
        guard self.isOn else { return }

        os_log("%@", type: type, message)
    }
}
