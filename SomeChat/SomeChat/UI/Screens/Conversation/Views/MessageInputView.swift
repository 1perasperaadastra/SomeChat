//
//  MessageInputView.swift
//  SomeChat
//
//  Created by Алексей Махутин on 28.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

internal final class MessageInputView: UIView {

    @IBOutlet weak var inputTextField: UITextField!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.loadNib()
        self.setupAppearance()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadNib()
        self.setupAppearance()
    }

    private func loadNib() {
        if let view = Bundle.main.loadNibNamed("MessageInputView", owner: self, options: nil)?.first as? UIView {
            self.addSubview(view)
        }
    }

    private func setupAppearance() {
        self.inputTextField.layer.cornerRadius = self.inputTextField.bounds.height / 2
        self.inputTextField.layer.borderWidth = 1
        self.inputTextField.layer.borderColor = UIColor.gray.cgColor
        self.inputTextField.clipsToBounds = true
        self.inputTextField.backgroundColor = .white
        let paddingFrame = CGRect(x: 0,
                                  y: 0,
                                  width: 22,
                                  height: self.inputTextField.bounds.height)
        let paddingView = UIView(frame: paddingFrame)
        self.inputTextField.leftView = paddingView
        self.inputTextField.leftViewMode = .always
    }
}
