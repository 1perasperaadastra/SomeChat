//
//  ProfileModel.swift
//  SomeChat
//
//  Created by Алексей Махутин on 20.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

internal struct PofileSaveModel {
    let fullName: String?
    let bioInfo: String?
    let avatar: UIImage?
}

internal struct ProfileModel {
    let firstName: String?
    let secondName: String?
    let bioInfo: String?
    let avatar: UIImage?

    let didTapSaveButton: CommandWith<PofileSaveModel>
    let updateModel: Command

    var fullName: String? {
        var array: [String] = []
        if let firstName = self.firstName {
            array.append(firstName)
        }
        if let secondName = self.secondName {
            array.append(secondName)
        }
        return array.isEmpty ? nil : array.joined(separator: " ")
    }
}
