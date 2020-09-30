//
//  ProfilePresenter.swift
//  SomeChat
//
//  Created by Алексей Махутин on 22.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

protocol ProfileRender: class {
    func render(props: ProfileModel)
}

internal final class ProfilePresenter {
    private enum Constants {
        static let userAvatarName = "user.jpeg"
    }

    weak var render: ProfileRender?
    private let configuration: UserConfiguration
    private let imageSource: ImageSource

    init(configuration: UserConfiguration,
         imageSource: ImageSource) {
        self.configuration = configuration
        self.imageSource = imageSource
    }

    func start() {
        self.render?.render(props: self.buildModel())
    }

    private func buildModel() -> ProfileModel {
        var image: UIImage?
        if self.configuration.userAvatarExist {
            image = self.imageSource.loadImage(withName: Constants.userAvatarName)
        }

        var fistName: String?
        if self.configuration.userFistName?.count ?? 0 > 2 {
            fistName = self.configuration.userFistName
        }
        var secondName: String?
        if self.configuration.userLastName?.count ?? 0 > 2 {
            secondName = self.configuration.userLastName
        }
        return ProfileModel(firstName: fistName,
                            secondName: secondName,
                            bioInfo: self.configuration.userBio,
                            avatar: image,
                            didTapSaveButton: self.didTapSaveButton(),
                            updateModel: self.updateModel())
    }

    private func didTapSaveButton() -> CommandWith<PofileSaveModel> {
        return CommandWith { model in
            let whitespace = CharacterSet.whitespaces
            let fullName = model.fullName?.split(whereSeparator: { character -> Bool in
                var result = false
                character.unicodeScalars.forEach { unicodeScalar in
                    if whitespace.contains(unicodeScalar) {
                        result = true
                    }
                }
                return result
            })
            self.configuration.userFistName = String(fullName?.first ?? "")
            self.configuration.userLastName = String(fullName?.last ?? "")
            self.configuration.userBio = model.bioInfo
            if let image = model.avatar {
                self.imageSource.saveImage(image, name: Constants.userAvatarName)
                self.configuration.userAvatarExist = true
            } else {
                self.configuration.userAvatarExist = false
            }
            NotificationCenter.default.post(name: .profileDidUpdate, object: nil)
        }
    }

    private func updateModel() -> Command {
        return Command {
            self.start()
        }
    }
}

extension Notification.Name {
    static let profileDidUpdate = Notification.Name("profileDidUpdate")
}
