//
//  LoadDataOperation.swift
//  SomeChat
//
//  Created by Алексей Махутин on 11.10.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import Foundation

internal final class LoadDataOperation: Operation {

    var data: Data?

    private let fileName: String
    private let fileManager: AppFileManager

    init(fileName: String, fileManager: AppFileManager) {
        self.fileName = fileName
        self.fileManager = fileManager
        super.init()
    }

    override func main() {
        guard !self.isCancelled else { return }

        self.data = self.fileManager.load(fileName: self.fileName)
    }
}
