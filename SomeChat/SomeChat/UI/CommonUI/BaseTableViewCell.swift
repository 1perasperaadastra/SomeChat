//
//  BaseTableViewCell.swift
//  SomeChat
//
//  Created by Алексей Махутин on 04.10.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

internal class BaseViewCell: UITableViewCell { }

extension BaseViewCell: ColorThemesNotification {

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didChangeColorTheme),
                                               name: .didChangeColorTheme,
                                               object: nil)
        self.updateColor()
    }

    override func removeFromSuperview() {
        super.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
    }

    @objc func didChangeColorTheme() {
        self.updateColor()
    }

    private func updateColor() {
        self.contentView.backgroundColor = Colors.standartBackground()
        self.backgroundColor = Colors.standartBackground()
    }
}
