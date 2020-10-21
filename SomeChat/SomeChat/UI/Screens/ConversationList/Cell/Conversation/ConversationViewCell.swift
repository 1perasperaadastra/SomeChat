//
//  ConversationViewCell.swift
//  SomeChat
//
//  Created by Алексей Махутин on 27.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

internal struct ConversationViewModel: ConfigurationModel {
    var identifier: String {
        return String(describing: ConversationViewCell.self)
    }

    let channelID: String
    let name: String
    let message: String
    let date: Date?
    let image: UIImage?
}

class ConversationViewCell: BaseViewCell, ConfigurableView {
    private enum Constants {
        static let emptyMessage = "No messages yet"
    }

    @IBOutlet weak var onlineView: UIView!
    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!

    private var fontMetric: UIFontMetrics {
        return UIFontMetrics(forTextStyle: .body)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupApppearance()
    }

    func configurate(with model: ConfigurationModel) {
        guard let model = model as? ConversationViewModel else { return }

        self.messageLabel.text = model.message.isEmpty ? Constants.emptyMessage : model.message
        let font = model.message.isEmpty ? Fonts.conversationCellMSGEmpty(13) : Fonts.conversationCellMSG(13)
        self.messageLabel.font = self.fontMetric.scaledFont(for: font)

        self.nameLabel.text = model.name
        let avatarModel = AvatarViewModel(fullName: model.name, image: model.image)
        self.avatarView.configure(model: avatarModel)
        let converter = DateConverter()
        if let date = model.date {
            self.dateLabel.text = converter.conversationTextDate(from: date)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.onlineView.layer.cornerRadius = self.onlineView.bounds.height / 2
        self.onlineView.layer.borderWidth = 3
        self.onlineView.layer.borderColor = self.contentView.backgroundColor?.cgColor
        self.avatarView.layer.cornerRadius = self.avatarView.bounds.height / 2
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        let avatarModel = AvatarViewModel(fullName: "", image: nil)
        self.avatarView.configure(model: avatarModel)
        self.dateLabel.text = ""
    }

    private func setupApppearance() {
        let fontMetric = self.fontMetric

        self.selectionStyle = .none
        self.nameLabel.font = fontMetric.scaledFont(for: Fonts.conversationCellName(15))
        self.dateLabel.font = fontMetric.scaledFont(for: Fonts.conversationCellDate(15))
        self.messageLabel.font = fontMetric.scaledFont(for: Fonts.conversationCellMSG(13))
    }
}
