//
//  ProfileModel.swift
//  SomeChat
//
//  Created by Алексей Махутин on 20.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

internal struct ProfileModel {
    let firstName: String?
    let secondName: String?
    let bioInfo: String?
    let avatar: UIImage?

    let didTapSaveWithGCD: Command
    let didTapSaveWithOperation: Command

    let didNameChanged: CommandWith<String>
    let didBioChanged: CommandWith<String>
    let didImageChanged: CommandWith<UIImage>

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

internal struct ProfileSaveButtonModel {
    let isEnabled: Bool
}

internal struct ProfileSaveResultModel {
    let result: Result
}
