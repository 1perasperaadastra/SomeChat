//
//  ConversationListViewController.swift
//  SomeChat
//
//  Created by Алексей Махутин on 27.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

internal final class ConversationListViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainAvatarView: AvatarView! {
        didSet { self.mainAvatarView.layer.cornerRadius = self.mainAvatarView.bounds.height / 2 }
    }
    private var props: ConversationsListModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Tinkoff Chat"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.leftBarButtonItem?.target = self
        self.navigationItem.leftBarButtonItem?.action = #selector(settingsDidTap)

        self.tableView.delegate = self
        self.tableView.dataSource = self
        let nib = UINib(nibName: String(describing: ConversationViewCell.self), bundle: nil)
        let nibSearch = UINib(nibName: String(describing: SearchViewCell.self), bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: String(describing: ConversationViewCell.self))
        self.tableView.register(nibSearch, forCellReuseIdentifier: String(describing: SearchViewCell.self))

        let gesture = UITapGestureRecognizer(target: self, action: #selector(avatarDidTap))
        self.mainAvatarView.addGestureRecognizer(gesture)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIWindow.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIWindow.keyboardWillHideNotification,
                                               object: nil)

        self.updateProps()
        self.updateColor()
    }

    @objc private func avatarDidTap() {
        self.coordinator?.showMainProfile(mainVC: self)
    }

    @objc private func settingsDidTap() {
        self.coordinator?.showThemeMenu(mainVC: self)
    }

    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let frame = notification.keyboardEndFrame else { return }

        notification.keyboardAnimate(animations: {
            self.tableView.contentInset.bottom = frame.height
        }, completion: nil)
    }

    @objc private func keyboardWillHide(_ notification: NSNotification) {
        notification.keyboardAnimate(animations: {
            self.tableView.contentInset.bottom = 0
        }, completion: nil)
    }

    private func updateProps() {
        guard let model = self.props,
              self.tableView != nil,
              self.mainAvatarView != nil else { return }

        if tableView.visibleCells.count == 0 {
            self.tableView.reloadData()
        } else {
            self.tableView.reloadSections(IndexSet(integer: 1), with: .none)
        }
        let avatarModel = AvatarViewModel(fullName: model.fullName, image: model.image)
        self.mainAvatarView.configure(model: avatarModel)
    }

    override func didChangeColorTheme() {
        super.didChangeColorTheme()

        self.updateColor()
    }

    private func updateColor() {
        self.tableView.backgroundColor = self.view.backgroundColor
        let color = Colors.navBarButtonColor()
        self.navigationItem.leftBarButtonItem?.tintColor = color
    }
}

extension ConversationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = self.props?.cells[indexPath.section][indexPath.row] as? ConversationViewModel {
            self.coordinator?.showConversation(mainVC: self, conversation: model)
        }
    }
}

extension ConversationListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : self.props?.cells[section].count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = self.props?.cells[indexPath.section][indexPath.row],
            let cell = tableView.dequeueReusableCell(withIdentifier: model.identifier,
                                                       for: indexPath) as? ConfigurableView
        else { return UITableViewCell() }

        cell.configurate(with: model)
        return cell
    }
}

extension ConversationListViewController: ConversationListRender {
    func render(props: ConversationsListModel) {
        self.props = props
        self.updateProps()
    }
}

extension ConversationListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.state == .changed {
            self.view.endEditing(true)
        }
    }
}
