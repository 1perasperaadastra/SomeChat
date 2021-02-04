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
    func render(props: ProfileSaveButtonModel)
    func render(props: ProfileSaveResultModel)
}

internal final class ProfilePresenter {
    weak var render: ProfileRender?

    private let notificationCenter: NotificationCenter
    private let userConfiguration: UserConfiguration
    private let imageSource: ImageSource
    private var model: ProfileModel?
    private var newImage: UIImage?
    private var newName: String?
    private var newBio: String?

    init(container: ImageSourceContainer & UserConfigurationContainer & NotificationCenterContainer) {
        self.notificationCenter = container.notificationCenter
        self.imageSource = container.imageSource
        self.userConfiguration = container.userConfiguration
    }

    func start() {
        self.render?.render(props: self.buildModel(model: nil))
        self.loadFromDataSource()
    }

    private func loadFromDataSource() {
        DispatchQueue.global().async { [weak self] in
            let image = self?.imageSource.loadImage(withName: ImageSource.userImageName)
            let name = self?.userConfiguration.userName
            let bio = self?.userConfiguration.userBio
            let model = ProfileDataModel(name: name, bio: bio, image: image)
            DispatchQueue.main.async {
                guard let self = self else { return }

                self.render?.render(props: self.buildModel(model: model))
                self.render?.render(props: ProfileSaveButtonModel(isEnabled: false))
            }
        }
    }

    private func buildModel(model: ProfileDataModel?) -> ProfileModel {
        let whitespace = CharacterSet.whitespaces
        let fullName = model?.name?.split(whereSeparator: { character -> Bool in
            var result = false
            character.unicodeScalars.forEach { unicodeScalar in
                if whitespace.contains(unicodeScalar) {
                    result = true
                }
            }
            return result
        })

        var secondName = ""
        let firstName = String(fullName?.first ?? "")
        if fullName?.count ?? 0 > 1 {
            secondName = String(fullName?.last ?? "")
        }

        let model = ProfileModel(firstName: firstName,
                                 secondName: secondName,
                                 bioInfo: model?.bio,
                                 avatar: model?.image,
                                 didTapSaveButton: self.didTapSaveButton(),
                                 didNameChanged: self.didNameChanged(),
                                 didBioChanged: self.didBioChanged(),
                                 didImageChanged: self.didImageChanged(),
                                 updateModel: self.updateModel())
        self.model = model
        return model
    }

    private func didTapSaveButton() -> Command {
        return Command { [weak self] in
            guard let self = self else { return }

            DispatchQueue.global().async { [weak self] in
                self?.imageSource.saveImage(self?.newImage, name: ImageSource.userImageName)
                DispatchQueue.main.async {
                    self?.userConfiguration.userBio = self?.newBio
                    self?.userConfiguration.userName = self?.newName
                    self?.newBio = nil
                    self?.newImage = nil
                    self?.newName = nil
                    self?.notificationCenter.post(name: .profileDidUpdate, object: nil)
                    self?.render?.render(props: ProfileSaveResultModel(result: Result.succesful))
                }
            }
        }
    }

    private func didNameChanged() -> CommandWith<String> {
        return CommandWith { [weak self] text in
            if self?.model?.fullName != text {
                self?.newName = text
                self?.render?.render(props: ProfileSaveButtonModel(isEnabled: true))
            }
        }
    }

    private func didBioChanged() -> CommandWith<String> {
        return CommandWith { [weak self] text in
            if self?.model?.bioInfo != text {
                self?.newBio = text
                self?.render?.render(props: ProfileSaveButtonModel(isEnabled: true))
            }
        }
    }

    private func didImageChanged() -> CommandWith<UIImage> {
        return CommandWith { [weak self] image in
            self?.newImage = image
            self?.render?.render(props: ProfileSaveButtonModel(isEnabled: true))
        }
    }

    private func updateModel() -> Command {
        return Command { [weak self] in
            self?.loadFromDataSource()
        }
    }
}

extension Notification.Name {
    static let profileDidUpdate = Notification.Name("profileDidUpdate")
}
