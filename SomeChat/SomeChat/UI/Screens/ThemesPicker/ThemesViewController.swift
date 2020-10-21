//
//  ThemesViewController.swift
//  SomeChat
//
//  Created by Алексей Махутин on 04.10.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

private enum ThemesType: Int, CaseIterable {
    case classic = 1
    case day = 2
    case night = 3

    var color: ColorThemes {
        return ColorThemes(rawValue: self.rawValue) ?? Colors.currentTheme
    }
}

protocol ThemesViewControllerDelegate: class {
    func didChangeTheme(_ themesViewController: ThemesViewController, theme: Int)
}

internal final class ThemesViewController: BaseViewController {

    private var props: ThemesModel?
    weak var delegate: ThemesViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Settings"
        let backButton = UIBarButtonItem()
        backButton.title = "Chat"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.rightBarButtonItem?.action = #selector(didTapCancel)
        self.navigationItem.rightBarButtonItem?.target = self

        let allThemes = Set(ThemesType.allCases.map({ $0.rawValue }))
        self.view.subviews
            .filter { allThemes.contains($0.tag) }
            .forEach { view in
                let gesture = UITapGestureRecognizer(target: self, action: #selector(userDidTapView(_:)))
                view.isUserInteractionEnabled = true
                view.addGestureRecognizer(gesture)
            }
        self.updateThemeView()
        self.updateColor()
    }

    override func didChangeColorTheme() {
        self.updateColor()
    }

    private func updateThemeView() {
        guard let props = self.props else { return }

        self.view.subviews
            .compactMap { $0 as? ThemeView }
            .forEach { $0.selected = $0.tag == props.selectedColorTheme }

    }

    @objc private func didTapCancel() {
        self.props?.didTapCancel()
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func userDidTapView(_ recognizer: UIGestureRecognizer) {
        guard let tag = recognizer.view?.tag,
              let theme = ThemesType(rawValue: tag) else { return }

        self.props?.didChangeColorTheme(with: theme.rawValue)
        self.delegate?.didChangeTheme(self, theme: theme.rawValue)
    }

    private func updateColor() {
        self.view.backgroundColor = Colors.changeColorBackground()
    }
}

extension ThemesViewController: ThemesRender {
    func render(props: ThemesModel) {
        self.props = props
        self.updateThemeView()
    }
}
