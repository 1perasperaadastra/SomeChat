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
    private let gcdDataSource: ProfileDataSourceProtocol?
    private let operationDataSource: ProfileDataSourceProtocol?
    private var model: ProfileModel?
    private var newImage: UIImage?
    private var newName: String?
    private var newBio: String?

    init(container: GCDProfileDataSourceContainer & OperationProfileDataSourceContainer & NotificationCenterContainer) {
        self.notificationCenter = container.notificationCenter
        self.gcdDataSource = container.gcdProfileDataSource
        self.operationDataSource = container.operationProfileDataSource
    }

    func start() {
        self.render?.render(props: self.buildModel(model: nil))
        self.loadFromDataSource()
    }

    private func loadFromDataSource() {
        self.gcdDataSource?.load(completion: { model in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }

                self.render?.render(props: self.buildModel(model: model))
                self.render?.render(props: ProfileSaveButtonModel(isEnabled: false))
            }
        })
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
                                 didTapSaveWithGCD: self.didTapSaveWithGCD(),
                                 didTapSaveWithOperation: self.didTapSaveWithOperation(),
                                 didNameChanged: self.didNameChanged(),
                                 didBioChanged: self.didBioChanged(),
                                 didImageChanged: self.didImageChanged(),
                                 updateModel: self.updateModel())
        self.model = model
        return model
    }

    private func didTapSaveWithGCD() -> Command {
        return Command { [weak self] in
            guard let gcd = self?.gcdDataSource else { return }

            self?.saveData(dataSource: gcd)
        }
    }

    private func didTapSaveWithOperation() -> Command {
        return Command { [weak self] in
            guard let operation = self?.operationDataSource else { return }

            self?.saveData(dataSource: operation)
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

    private func saveData(dataSource: ProfileDataSourceProtocol) {
        let model = ProfileDataModel(name: self.newName, bio: self.newBio, image: self.newImage)
        dataSource.save(model: model) { [weak self] result in
            if result == .succesful {
                self?.newBio = nil
                self?.newImage = nil
                self?.newName = nil
                self?.notificationCenter.post(name: .profileDidUpdate, object: nil)
            }
            DispatchQueue.main.async {
                self?.render?.render(props: ProfileSaveResultModel(result: result))
            }
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
