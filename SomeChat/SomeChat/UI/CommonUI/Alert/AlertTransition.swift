//
//  AlertTransition.swift
//  SomeChat
//
//  Created by Алексей Махутин on 06.10.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

internal final class AlertTransition: NSObject, UIViewControllerTransitioningDelegate {

    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
            let presentationController = AlertPresentationController(presentedViewController: presented,
                                                                     presenting: presenting ?? source)
            return presentationController
    }
}
