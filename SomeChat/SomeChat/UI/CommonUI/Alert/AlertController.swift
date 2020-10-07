//
//  AlertController.swift
//  SomeChat
//
//  Created by Алексей Махутин on 06.10.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

class AlertController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    private let models: [AlertCellModelProtocol]
    private let transition = AlertTransition()

    init(models: [AlertCellModelProtocol]) {
        self.models = models
        super.init(nibName: nil, bundle: nil)
        self.transitioningDelegate = self.transition
        self.modalPresentationStyle = .custom
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupColor()
        self.tableView.register(UINib(nibName: String(describing: AlertTitleCell.self),
                                      bundle: nil), forCellReuseIdentifier: String(describing: AlertTitleCell.self))
        self.tableView.register(UINib(nibName: String(describing: AlertActionCell.self),
                                      bundle: nil), forCellReuseIdentifier: String(describing: AlertActionCell.self))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.reloadData()
        self.preferredContentSize = self.tableView.contentSize
    }

    override func didChangeColorTheme() {
        super.didChangeColorTheme()
        self.setupColor()
    }

    private func setupColor() {
        self.tableView.backgroundColor = Colors.navigationBar()
        self.view.backgroundColor = Colors.navigationBar()
    }
}

extension AlertController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = self.models[indexPath.row] as? AlertActionModel {
            self.dismiss(animated: true) {
                model.action()
            }
        }
    }
}

extension AlertController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.models[indexPath.row]
        guard let cell = tableView
                .dequeueReusableCell(withIdentifier: model.identifier,
                                     for: indexPath) as? AlertCellProtocol else { return UITableViewCell() }

        cell.configurate(model: model)
        return cell
    }
}
