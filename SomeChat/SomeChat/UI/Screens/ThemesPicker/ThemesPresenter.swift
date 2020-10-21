//
//  ThemesPresenter.swift
//  SomeChat
//
//  Created by Алексей Махутин on 04.10.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import Foundation

protocol ThemesRender: class {
    func render(props: ThemesModel)
}

internal final class ThemesPresenter {

    //если тут не будет слабой ссылки то презентер будет удерживать ThemesRender(ThemesViewController)
    weak var render: ThemesRender?
    private let colorThemesManager: ColorThemesManager?
    private let initialColor: Int

    init(container: ColorThemesManagerContainer) {
        self.colorThemesManager = container.colorThemesManager
        self.initialColor = Colors.currentTheme.rawValue
    }

    func start() {
        self.render?.render(props: self.buildModel())
    }

    private func buildModel() -> ThemesModel {
        let currentColor = Colors.currentTheme.rawValue
        return ThemesModel(selectedColorTheme: currentColor,
                           didTapCancel: self.didTapCancel(),
                           didChangeColorTheme: self.didChangeColorTheme())
    }

    private func didTapCancel() -> Command {
        //Если тут не будет слабой ссылки на селф то, тот кто хранит этот клоужер, будет удерживать этот презентер
        //Если еще render будет к тому же слабой получится retain cycle
        return Command { [weak self] in
            guard let self = self else { return }

            self.colorThemesManager?.currentTheme = ColorThemes(rawValue: self.initialColor) ?? Colors.currentTheme
        }
    }

    private func didChangeColorTheme() -> CommandWith<Int> {
        return CommandWith { [weak self] num in
            self?.colorThemesManager?.currentTheme = ColorThemes(rawValue: num) ?? Colors.currentTheme
            self?.start()
        }
    }
}
