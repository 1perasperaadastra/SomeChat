//
//  GCDProfileDataSource.swift
//  SomeChat
//
//  Created by Алексей Махутин on 11.10.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

protocol GCDProfileDataSourceContainer {
    var gcdProfileDataSource: GCDProfileDataSource? { get }
}

internal final class GCDProfileDataSource: ProfileDataSourceProtocol {
    private enum Constants {
        static let name = "userName.txt"
        static let bio = "userBio.txt"
        static let image = "user.jpeg"
    }

    private let fileManager: AppFileManager
    private let queue = DispatchQueue(label: "com.GCDProfileDataSource", qos: .userInitiated)

    init(container: AppFileManagerContainer) {
        self.fileManager = container.appFileManager
    }

    func save(model: ProfileDataModel, completion: @escaping SaveDataCompletionBlock) {
        var result = Result.succesful
        let group = DispatchGroup()
        if let nameData = model.name?.data(using: .utf8) {
            group.enter()
            self.queue.async {
                result = self.fileManager.save(fileName: Constants.name, data: nameData)
                group.leave()
            }
        }
        if let bioData = model.bio?.data(using: .utf8) {
            group.enter()
            self.queue.async {
                result = self.fileManager.save(fileName: Constants.bio, data: bioData)
                group.leave()
            }
        }
        if let imageData = model.image?.jpegData(compressionQuality: 1) {
            group.enter()
            self.queue.async {
                result = self.fileManager.save(fileName: Constants.image, data: imageData)
                group.leave()
            }
        }
        group.notify(queue: .global()) {
            completion(result)
        }
    }

    func load(completion: @escaping ProfileDataCompletionBlock) {
        let group = DispatchGroup()
        var image: UIImage?
        var name: String?
        var bio: String?
        group.enter()
        self.queue.async {
            if let data = self.fileManager.load(fileName: Constants.name) {
                name = String(data: data, encoding: .utf8)
            }
            group.leave()
        }
        group.enter()
        self.queue.async {
            if let data = self.fileManager.load(fileName: Constants.bio) {
                bio = String(data: data, encoding: .utf8)
            }
            group.leave()
        }
        group.enter()
        self.queue.async {
            if let data = self.fileManager.load(fileName: Constants.image) {
                image = UIImage(data: data)
            }
            group.leave()
        }
        group.notify(queue: .global()) {
            let model = ProfileDataModel(name: name, bio: bio, image: image)
            completion(model)
        }
    }
}
