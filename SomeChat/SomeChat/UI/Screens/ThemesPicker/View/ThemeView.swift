//
//  ThemeView.swift
//  SomeChat
//
//  Created by Алексей Махутин on 04.10.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

internal final class ThemeView: UIView {
    private enum Constants {
        static let cornerRadius: CGFloat = 14
        static let borderWidth: CGFloat = 1
        static let selectedBorderWidth: CGFloat = 3
    }

    var selected = false {
        didSet {
            self.setNeedsLayout()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = Constants.cornerRadius

        if self.selected {
            self.layer.borderWidth = Constants.selectedBorderWidth
            self.layer.borderColor = Colors.mainTint().cgColor
        } else {
            self.layer.borderColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1).cgColor
            self.layer.borderWidth = Constants.borderWidth
        }
    }
}
