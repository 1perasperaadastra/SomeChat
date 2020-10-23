//
//  ProfileDataSourceProtocol.swift
//  SomeChat
//
//  Created by Алексей Махутин on 11.10.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

struct ProfileDataModel {
    var name: String?
    let bio: String?
    var image: UIImage?
}

internal protocol ProfileDataSourceProtocol {
    typealias ProfileDataCompletionBlock = (ProfileDataModel) -> Void
    typealias SaveDataCompletionBlock = (Result) -> Void

    func save(model: ProfileDataModel, completion: @escaping SaveDataCompletionBlock)
    func load(completion: @escaping ProfileDataCompletionBlock)
}
