//
//  SearchViewCell.swift
//  SomeChat
//
//  Created by Алексей Махутин on 07.10.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

struct SearchCellModel: ConfigurationModel {
    var identifier: String {
        return String(describing: SearchViewCell.self)
    }

    let searchTextDidChange: CommandWith<String>
}

class SearchViewCell: BaseViewCell, ConfigurableView {

    @IBOutlet weak var searchView: UISearchBar?

    private var model: SearchCellModel?

    func configurate(with model: ConfigurationModel) {
        guard let model = model as? SearchCellModel else { return }

        self.model = model
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.searchView?.delegate = self
    }

    override func didChangeColorTheme() {
        super.didChangeColorTheme()
        self.updateColor()
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.updateColor()
    }

    func updateColor() {
        if #available(iOS 13.0, *) {
            self.searchView?.searchTextField.backgroundColor = Colors.searchBackground()
            self.searchView?.searchTextField.textColor = .black
        }
    }
}

extension SearchViewCell: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.model?.searchTextDidChange(with: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
