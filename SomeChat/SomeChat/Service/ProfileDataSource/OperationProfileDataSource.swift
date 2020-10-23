//
//  OperationProfileDataSource.swift
//  SomeChat
//
//  Created by Алексей Махутин on 11.10.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

protocol OperationProfileDataSourceContainer {
    var operationProfileDataSource: OperationProfileDataSource? { get }
}

internal final class OperationProfileDataSource: ProfileDataSourceProtocol {
    private enum Constants {
        static let name = "userName.txt"
        static let bio = "userBio.txt"
        static let image = "user.jpeg"
    }

    private let fileManager: AppFileManager
    private let operationQueue = OperationQueue()

    init(container: AppFileManagerContainer) {
        self.fileManager = container.appFileManager
        self.operationQueue.maxConcurrentOperationCount = 1
    }

    func save(model: ProfileDataModel, completion: @escaping SaveDataCompletionBlock) {
        var result = Result.succesful
        if let nameData = model.name?.data(using: .utf8) {
            let saveOperation = SaveDataOperation(data: nameData,
                                                  fileName: Constants.name,
                                                  fileManager: self.fileManager)
            self.operationQueue.addOperation(saveOperation)
            saveOperation.completionBlock = {
                result = saveOperation.result ?? .error
            }
        }
        if let bioData = model.bio?.data(using: .utf8) {
            let saveOperation = SaveDataOperation(data: bioData,
                                                  fileName: Constants.bio,
                                                  fileManager: self.fileManager)
            self.operationQueue.addOperation(saveOperation)
            saveOperation.completionBlock = {
                result = saveOperation.result ?? .error
            }
        }
        if let imageData = model.image?.jpegData(compressionQuality: 1) {
            let saveOperation = SaveDataOperation(data: imageData,
                                                  fileName: Constants.image,
                                                  fileManager: self.fileManager)
            self.operationQueue.addOperation(saveOperation)
            saveOperation.completionBlock = {
                result = saveOperation.result ?? .error
            }
        }
        self.operationQueue.addOperation {
            completion(result)
        }
    }

    func load(completion: @escaping ProfileDataCompletionBlock) {
        var image: UIImage?
        var name: String?
        var bio: String?

        let nameOperation = LoadDataOperation(fileName: Constants.name, fileManager: self.fileManager)
        nameOperation.completionBlock = {
            if let data = nameOperation.data {
                name = String(data: data, encoding: .utf8)
            }
        }
        let bioOperation = LoadDataOperation(fileName: Constants.bio, fileManager: self.fileManager)
        bioOperation.completionBlock = {
            if let data = bioOperation.data {
                bio = String(data: data, encoding: .utf8)
            }
        }
        let imageOperation = LoadDataOperation(fileName: Constants.image, fileManager: self.fileManager)
        imageOperation.completionBlock = {
            if let data = imageOperation.data {
                image = UIImage(data: data)
            }
        }
        self.operationQueue.addOperation(nameOperation)
        self.operationQueue.addOperation(bioOperation)
        self.operationQueue.addOperation(imageOperation)
        self.operationQueue.addOperation {
            let model = ProfileDataModel(name: name, bio: bio, image: image)
            completion(model)
        }
    }
}
