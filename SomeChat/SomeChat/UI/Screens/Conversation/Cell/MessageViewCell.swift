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
    let incoming: Bool
}

class MessageViewCell: BaseViewCell {
    private enum Constants {
        static let messageInset: CGFloat = 30
    }

    typealias ConfigurationModel = MessageCellModel

    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var messageLabel: UILabel! {
        didSet {
            setupAppearance()
        }
    }
    @IBOutlet weak var messageImageWidthConstraint: NSLayoutConstraint!
    private var incoming = false

    private var fontMetric: UIFontMetrics {
        return UIFontMetrics(forTextStyle: .body)
    }

    func configurate(with model: ConfigurationModel) {
        self.messageLabel.text = model.text
        self.messageLabel.sizeToFit()
        self.incoming = model.incoming
        self.updateMessageImage()
        self.layoutIfNeeded()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard self.messageImageWidthConstraint != nil else { return }

        self.messageImageWidthConstraint.constant = self.messageLabel.frame.size.width + Constants.messageInset
    }

    override func didChangeColorTheme() {
        super.didChangeColorTheme()

        self.updateMessageImage()
    }

    private func setupAppearance() {
        self.selectionStyle = .none
        self.messageLabel.font = self.fontMetric.scaledFont(for: Fonts.conversationMessageCellText(16))
    }

    private func updateMessageImage() {
        var imageString = ""
        switch Colors.currentTheme {
        case .day:
            imageString = self.incoming ? "message_left-1" : "message_right-1"
            self.messageLabel.textColor = self.incoming ? Colors.mainTitle() : .white
        case .night:
            imageString = self.incoming ? "message_left-2" : "message_right-2"
            self.messageLabel.textColor = Colors.mainTitle()
        default:
            imageString = self.incoming ? "message_left" : "message_right"
            self.messageLabel.textColor = Colors.mainTitle()
        }
        self.messageImage.image = UIImage(named: imageString)
    }
}
