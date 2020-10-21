//
//  ConversationViewController.swift
//  SomeChat
//
//  Created by Алексей Махутин on 28.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

struct ConversationMessageModel {
    enum Direction {
        case incoming
        case outgoing
    }
    let type: Direction
    let cellModel: MessageCellModel
}

struct ConversationModel {
    let messages: [ConversationMessageModel]
    let memberName: String
    let memberImage: UIImage?

    let userDidEndMessage: CommandWith<String>
}

internal final class ConversationViewController: BaseViewController {
    private enum Constants {
        static let messageIn = "message_in"
        static let messageOut = "message_out"
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputMessageView: MessageInputView!
    @IBOutlet weak var bottomConstrait: NSLayoutConstraint!
    @IBOutlet weak var avatarView: AvatarView! {
        didSet { self.avatarView.layer.cornerRadius = self.avatarView.bounds.height / 2 }
    }
    @IBOutlet weak var nameLabel: UILabel!

    private var props: ConversationModel?
    private var isKeyboardShow = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.largeTitleDisplayMode = .never
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIWindow.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIWindow.keyboardWillHideNotification,
                                               object: nil)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.contentInset.top = self.view.safeAreaInsets.top
        self.inputMessageView.inputTextField.delegate = self
        self.inputMessageView.sendButton.addTarget(self, action: #selector(didTapSendButton(_:)), for: .touchUpInside)
        self.updateProps()
        self.tableView.alpha = 0
        self.updateColor()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.tableView.alpha = 1
        }
        self.scrollToBottom(animated: false)
    }

    override func didChangeColorTheme() {
        super.didChangeColorTheme()

        self.updateColor()
    }

    private func scrollToBottom(animated: Bool) {
        guard self.props?.messages.count ?? 0 > 0 else { return }

        let index = (self.props?.messages.count ?? 0) - 1
        let indexPath = IndexPath(row: index < 0 ? 0 : index, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }

    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let frame = notification.keyboardEndFrame, !self.isKeyboardShow else { return }

        let yOrig = self.tableView.contentOffset.y + frame.height - self.view.safeAreaInsets.bottom
        self.isKeyboardShow = true

        notification.keyboardAnimate(animations: {
            self.bottomConstrait.constant = frame.height - self.view.safeAreaInsets.bottom
            self.tableView.contentOffset = CGPoint(x: 0, y: max(yOrig, 0))
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    @objc private func keyboardWillHide(_ notification: NSNotification) {
        self.isKeyboardShow = false

        notification.keyboardAnimate(animations: {
            self.bottomConstrait.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    @objc private func didTapSendButton(_ sender: UIButton) {
        self.userDidEndMessage(textField: self.inputMessageView.inputTextField)
    }

    private func userDidEndMessage(textField: UITextField) {
        guard let text = textField.text,
              !text.isEmpty else { return }

        self.props?.userDidEndMessage(with: text)
        textField.text = ""
    }

    private func updateColor() {
        self.tableView.backgroundColor = self.view.backgroundColor
    }

    private func createIdentifier(with model: ConversationMessageModel) -> String {
        return model.type == .incoming ? Constants.messageIn : Constants.messageOut
    }

    private func updateProps() {
        guard self.tableView != nil,
              let model = self.props else { return }

        let aModel = AvatarViewModel(fullName: model.memberName, image: model.memberImage)
        self.avatarView.configure(model: aModel)
        self.nameLabel.text = model.memberName
        self.tableView.reloadData()
    }
}

extension ConversationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
}

extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.props?.messages.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = self.props?.messages[indexPath.row],
              let cell = tableView.dequeueReusableCell(
                withIdentifier: self.createIdentifier(with: model),
                for: indexPath) as? MessageViewCell else { return UITableViewCell() }

        cell.configurate(with: model.cellModel)
        return cell
    }
}

extension ConversationViewController: ConversationRender {
    func render(props: ConversationModel) {
        self.props = props
        self.updateProps()
    }
}

extension ConversationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.userDidEndMessage(textField: textField)
        return true
    }
}
