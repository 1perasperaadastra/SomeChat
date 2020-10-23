//
//  ProfileCoordinator.swift
//  SomeChat
//
//  Created by Алексей Махутин on 11.10.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

extension AppCoordinator {
    typealias Action = () -> Void

    func showProfileSuccessfulAlert(controller: UIViewController, actiobButton: @escaping Action) {
        var models = [AlertCellModelProtocol]()
        models.append(AlertTitleModel(mainTitle: "Data saved successfully",
                                      secondTitle: ""))
        models.append(AlertActionModel(mainTitle: "Ok", action: Command(action: actiobButton)))
        let alert = AlertController(models: models)
        controller.present(alert, animated: true, completion: nil)
    }

    func showProfileErrorAlert(controller: UIViewController,
                               actiobButton: @escaping Action,
                               repearBlock: @escaping Action) {
        var models = [AlertCellModelProtocol]()
        models.append(AlertTitleModel(mainTitle: "Error",
                                      secondTitle: "Аailed to save data"))
        models.append(AlertActionModel(mainTitle: "Ok", action: Command(action: actiobButton)))
        models.append(AlertActionModel(mainTitle: "Retry", action: Command(action: repearBlock)))
        let alert = AlertController(models: models)
        controller.present(alert, animated: true, completion: nil)
    }
}
