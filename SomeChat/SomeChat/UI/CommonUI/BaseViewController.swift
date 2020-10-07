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
        self.updateColor()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return Colors.currentTheme == .night ? .lightContent : .darkContent
        }
        return .default
    }

    @objc func didChangeColorTheme() {
        self.updateColor()
    }

    private func updateColor() {
        self.view.backgroundColor = Colors.standartBackground()
        self.setNeedsStatusBarAppearanceUpdate()
    }
}
