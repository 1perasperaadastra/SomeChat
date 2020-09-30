//
//  ConversationListViewController.swift
//  SomeChat
//
//  Created by Алексей Махутин on 27.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

internal final class ConversationListViewController: ACViewController {
    private enum Constants {
        static let reuseIdentifier = "conversationViewCell"
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainAvatarView: AvatarView! {
        didSet { self.mainAvatarView.layer.cornerRadius = self.mainAvatarView.bounds.height / 2 }
    }
    private var props: ConversationsListModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Tinkoff Chat"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let searchController = UISearchController()
        self.navigationItem.searchController = searchController

        self.tableView.delegate = self
        self.tableView.dataSource = self
        let nib = UINib(nibName: String(describing: ConversationViewCell.self), bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: Constants.reuseIdentifier)

        let gesture = UITapGestureRecognizer(target: self, action: #selector(avatarDidTap))
        self.mainAvatarView.addGestureRecognizer(gesture)

        self.updateProps()
    }

    @objc private func avatarDidTap() {
        self.coordinator?.showMainProfile(mainVC: self)
    }

    private func updateProps() {
        guard let model = self.props,
              self.tableView != nil,
              self.mainAvatarView != nil else { return }

        self.tableView.reloadData()
        let avatarModel = AvatarViewModel(fullName: model.fullName, image: model.image)
        self.mainAvatarView.configure(model: avatarModel)
    }
}

extension ConversationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = indexPath.section == 0 ? self.props?.online[indexPath.row] : self.props?.offline[indexPath.row]
        if let model = model {
            self.coordinator?.showConversation(mainVC: self, conversation: model)
        }
    }
}

extension ConversationListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return self.props?.online.isEmpty ?? false ? nil : "Online"
        }
        return self.props?.offline.isEmpty ?? false ? nil : "History"
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? self.props?.online.count ?? 0 : self.props?.offline.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier,
                                                       for: indexPath) as? ConversationViewCell,
            let model = indexPath.section == 0 ? self.props?.online[indexPath.row] : self.props?.offline[indexPath.row]
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
