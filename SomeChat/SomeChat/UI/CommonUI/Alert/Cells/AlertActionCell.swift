//
//  AlertActionCell.swift
//  SomeChat
//
//  Created by Алексей Махутин on 06.10.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

class AlertActionCell: BaseViewCell, AlertCellProtocol {

    @IBOutlet weak var title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupAppearance()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func didChangeColorTheme() {
        super.didChangeColorTheme()
        setupColor()
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.setupColor()
    }

    func configurate(model: AlertCellModelProtocol) {
        guard let model = model as? AlertActionModel else { return }

        self.title.text = model.mainTitle
    }

    private func setupAppearance() {
        self.selectionStyle = .none
        self.title.font = Fonts.alertTitleSecond(17)
    }

    private func setupColor() {
        self.contentView.backgroundColor = Colors.navigationBar()
        self.backgroundColor = Colors.navigationBar()
        self.title.textColor = .systemBlue
    }
}
