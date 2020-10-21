//
//  ThemesModel.swift
//  SomeChat
//
//  Created by Алексей Махутин on 04.10.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import Foundation

struct ThemesModel {
    let selectedColorTheme: Int

    let didTapCancel: Command
    let didChangeColorTheme: CommandWith<Int>
}
