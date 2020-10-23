//
//  SaveDataOperation.swift
//  SomeChat
//
//  Created by Алексей Махутин on 11.10.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import Foundation

internal final class SaveDataOperation: Operation {

    var result: Result?

    private let data: Data
    private let fileName: String
    private let fileManager: AppFileManager

    init(data: Data, fileName: String, fileManager: AppFileManager) {
        self.data = data
        self.fileName = fileName
        self.fileManager = fileManager
        super.init()
    }

    override func main() {
        guard !self.isCancelled else { return }

        self.result = self.fileManager.save(fileName: self.fileName, data: self.data)
    }
}
