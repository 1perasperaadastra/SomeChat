//
//  ModalPresentationTransition.swift
//  SomeChat
//
//  Created by Алексей Махутин on 29.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

internal final class ModalPresentationTransition: NSObject, UIViewControllerTransitioningDelegate {

    var driven: ModalPresentationDriven?

    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        self.driven = ModalPresentationDriven()
        self.driven?.configurate(controller: presented)
        let presentationController = ModalPresentationController(presentedViewController: presented,
                                                                 presenting: presenting ?? source)
        presentationController.driven = self.driven
        return presentationController
    }

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ModalPresentationPresentAnimation()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ModalPresentationDismissAnimation()
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning)
    -> UIViewControllerInteractiveTransitioning? {
        return self.driven
    }
}
