//
//  BaseViewController.swift
//  SomeChat
//
//  Created by Алексей Махутин on 27.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

internal class BaseViewController: UIViewController, AppCoordinatorProtocol {
    var coordinator: AppCoordinator?
}

extension BaseViewController: ColorThemesNotification {

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didChangeColorTheme),
                                               name: .didChangeColorTheme,
                                               object: nil)
    }

    @objc func didChangeColorTheme() {}
}
