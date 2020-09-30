//
//  ProfileTextVerification.swift
//  SomeChat
//
//  Created by Алексей Махутин on 22.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import Foundation

internal final class ProfileTextVerification {

    func isCorrectFullNameTextСhange(text: String,
                                     range: NSRange,
                                     replacementText: String) -> Bool {
        guard range.length == 0 else { return true }

        let whitespace = NSCharacterSet.whitespaces
        let textFieldRange = text.rangeOfCharacter(from: whitespace)
        let stringRange = replacementText.rangeOfCharacter(from: whitespace)
        let exceededLimit = text.count < 20
        return exceededLimit
            && !(textFieldRange != nil && stringRange != nil)
    }

    func isCorrectBioTextСhange(text: String,
                                range: NSRange,
                                replacementText: String) -> Bool {
        guard range.length == 0 else { return true }

        let exceededLimit = text.count < 70
        return exceededLimit
    }
}
