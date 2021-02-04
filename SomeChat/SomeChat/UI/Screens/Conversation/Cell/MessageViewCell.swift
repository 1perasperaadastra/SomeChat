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
    let userName: String?
    let incoming: Bool
}

class MessageViewCell: BaseViewCell {
    private enum Constants {
        static let messageInset: CGFloat = 20
    }

    typealias ConfigurationModel = MessageCellModel

    @IBOutlet weak var userName: UILabel?
    @IBOutlet weak var messageCloud: UIView!
    @IBOutlet weak var messageLabel: UILabel! {
        didSet {
            setupAppearance()
        }
    }
    @IBOutlet weak var messageCloudWidthConstraint: NSLayoutConstraint!
    private var incoming = false

    private var fontMetric: UIFontMetrics {
        return UIFontMetrics(forTextStyle: .body)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.messageLabel.text = ""
    }

    func configurate(with model: ConfigurationModel) {
        self.messageLabel.text = model.text
        self.messageLabel.sizeToFit()
        self.incoming = model.incoming
        if incoming {
            self.userName?.text = model.userName
        }
        self.updateMessageColor()
        self.layoutIfNeeded()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard self.messageCloudWidthConstraint != nil else { return }

        let nameWidth = self.userName?.frame.size.width ?? 0
        var width = max(nameWidth, self.messageLabel.frame.size.width) + Constants.messageInset
        width = min(self.contentView.bounds.width * 0.75, width)
        self.messageCloudWidthConstraint.constant = width
        self.messageCloud.layer.cornerRadius = 10
        self.messageCloud.clipsToBounds = true
    }

    override func didChangeColorTheme() {
        super.didChangeColorTheme()

        self.updateMessageColor()
    }

    private func setupAppearance() {
        self.selectionStyle = .none
        self.messageLabel.font = self.fontMetric.scaledFont(for: Fonts.conversationMessageCellText(16))
    }

    private func updateMessageColor() {
        switch Colors.currentTheme {
        case .day:
            self.messageCloud.backgroundColor = self.incoming ? #colorLiteral(red: 0.9176470588, green: 0.9215686275, blue: 0.9294117647, alpha: 1) : #colorLiteral(red: 0.262745098, green: 0.537254902, blue: 0.9764705882, alpha: 1)
            self.messageLabel.textColor = self.incoming ? Colors.mainTitle() : .white
        case .night:
            self.messageCloud.backgroundColor = self.incoming ? #colorLiteral(red: 0.1803921569, green: 0.1803921569, blue: 0.1803921569, alpha: 1) : #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1)

            self.messageLabel.textColor = Colors.mainTitle()
        default:
            self.messageCloud.backgroundColor = self.incoming ? #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1) : #colorLiteral(red: 0.862745098, green: 0.968627451, blue: 0.7725490196, alpha: 1)
            self.messageLabel.textColor = Colors.mainTitle()
        }
    }
}
