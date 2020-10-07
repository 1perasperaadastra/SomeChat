//
//  MessageViewCell.swift
//  SomeChat
//
//  Created by Алексей Махутин on 28.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

struct MessageCellModel {
    let text: String
}

class MessageViewCell: UITableViewCell, ConfigurableView {
    private enum Constants {
        static let messageInset: CGFloat = 30
    }

    typealias ConfigurationModel = MessageCellModel

    @IBOutlet weak var messageLabel: UILabel! {
        didSet {
            setupAppearance()
        }
    }
    @IBOutlet weak var messageImageWidthConstraint: NSLayoutConstraint!

    private var fontMetric: UIFontMetrics {
        return UIFontMetrics(forTextStyle: .body)
    }

    func configurate(with model: MessageCellModel) {
        self.messageLabel.text = model.text
        self.layoutIfNeeded()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard self.messageImageWidthConstraint != nil else { return }

        self.messageImageWidthConstraint.constant = self.messageLabel.frame.size.width + Constants.messageInset
    }

    private func setupAppearance() {
        self.selectionStyle = .none
        self.messageLabel.font = self.fontMetric.scaledFont(for: Fonts.conversationMessageCellText(16))
    }
}
