//
//  NSNotification+extension.swift
//  SomeChat
//
//  Created by Алексей Махутин on 22.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

extension NSNotification {

    var keyboardBeginFrame: CGRect? {
        guard let userinfo = self.userInfo,
            let frameValue = userinfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return nil }
        return frameValue.cgRectValue
    }

    var keyboardEndFrame: CGRect? {
        guard let userinfo = self.userInfo,
            let frameValue = userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return nil }
        return frameValue.cgRectValue
    }

    func keyboardAnimate(animations: @escaping () -> Void, completion: ((Bool) -> Void)?) {
        guard let userInfo = self.userInfo,
            let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber,
            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {
                animations()
                return
        }

        UIView.animate(withDuration: TimeInterval(truncating: animationDuration),
                       delay: 0,
                       options: UIView.AnimationOptions(rawValue: UInt(animationCurve.uintValue << 16)),
                       animations: animations,
                       completion: completion)
    }
}
