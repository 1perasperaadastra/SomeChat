//
//  AlertTitleCell.swift
//  SomeChat
//
//  Created by Алексей Махутин on 06.10.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

class AlertTitleCell: BaseViewCell, AlertCellProtocol {

    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var secondTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupAppearance()
    }

    func configurate(model: AlertCellModelProtocol) {
        guard let model = model as? AlertTitleModel else { return }

        self.mainTitle.text = model.mainTitle
        self.secondTitle.text = model.secondTitle
    }

    override func didChangeColorTheme() {
        super.didChangeColorTheme()
        self.setupColor()
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.setupColor()
    }

    private func setupAppearance() {
        self.selectionStyle = .none
        self.mainTitle.font = Fonts.alertTitleMain(17)
        self.secondTitle.font = Fonts.alertTitleSecond(13)
    }

    private func setupColor() {
        self.backgroundColor = Colors.navigationBar()
        self.contentView.backgroundColor = Colors.navigationBar()
    }
}
