//
//  BaseNavigationController.swift
//  SomeChat
//
//  Created by Алексей Махутин on 04.10.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

internal class BaseNavigationController: UINavigationController {

}

extension BaseNavigationController: ColorThemesNotification {

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
        self.navigationBar.barStyle = .default
        if var textAttributes = self.navigationBar.titleTextAttributes {
            textAttributes[.foregroundColor] = Colors.mainTitle()
            self.navigationBar.titleTextAttributes = textAttributes
            self.navigationBar.largeTitleTextAttributes = textAttributes
        }

        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.titleTextAttributes = [.foregroundColor: Colors.mainTitle()]
            appearance.largeTitleTextAttributes = [.foregroundColor: Colors.mainTitle()]
            appearance.backgroundColor = Colors.navigationBar()

            self.navigationItem.standardAppearance = appearance
            self.navigationItem.scrollEdgeAppearance = appearance
            self.navigationItem.compactAppearance = appearance
        }
        self.navigationBar.titleTextAttributes = [.foregroundColor: Colors.mainTitle()]
        self.navigationBar.largeTitleTextAttributes = [.foregroundColor: Colors.mainTitle()]
        self.navigationBar.backgroundColor = Colors.navigationBar()
        self.navigationBar.barTintColor = Colors.navigationBar()
        self.view.backgroundColor = Colors.navigationBar()
        self.navigationBar.isTranslucent = false
        self.setNeedsStatusBarAppearanceUpdate()
    }
}
