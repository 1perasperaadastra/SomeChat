//
//  Fonts.swift
//  SomeChat
//
//  Created by Алексей Махутин on 20.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

enum Fonts {
    case profileScreenBIO
    case profileScreenName
    case profileScreenButton

    func callAsFunction(_ size: CGFloat = UIFont.systemFontSize) -> UIFont {
        var font: UIFont?
        switch self {
        case .profileScreenBIO:
            font = UIFont(name: "SFProText-Regular", size: size)
        case .profileScreenName:
            font = UIFont(name: "SFProDisplay-Bold", size: size)
        case .profileScreenButton:
            font = UIFont(name: "SFProText-Semibold", size: size)
        }
        if font == nil {
            assertionFailure("The font must not be null")
        }
        return font ?? UIFont.systemFont(ofSize: size)
    }
}
