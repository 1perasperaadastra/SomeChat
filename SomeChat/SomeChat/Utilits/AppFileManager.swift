//
//  AppFileManager.swift
//  SomeChat
//
//  Created by Алексей Махутин on 11.10.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import Foundation

protocol AppFileManagerContainer {
    var appFileManager: AppFileManager { get }
}

internal final class AppFileManager {

    private let documentURL = FileManager.default.urls(for: .documentDirectory,
                                                       in: .userDomainMask).first

    func save(fileName: String, data: Data) -> Result {
        guard let url = self.documentURL?.appendingPathComponent(fileName) else {
            Logger.error("Error available to documentDirectory")
            return .error
        }

        do {
            try data.write(to: url)
            return .succesful
        } catch {
            Logger.error(error.localizedDescription)
            return .error
        }
    }

    func load(fileName: String) -> Data? {
        guard let url = self.documentURL?.appendingPathComponent(fileName) else {
            Logger.error("Error available to documentDirectory")
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            Logger.error(error.localizedDescription)
            return nil
        }
    }
}
