//
//  ModalPresentationDismissAnimation.swift
//  SomeChat
//
//  Created by Алексей Махутин on 29.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

internal final class ModalPresentationDismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    private enum Constants {
        static let duration: TimeInterval = 0.5
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Constants.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = self.interruptibleAnimator(using: transitionContext)
        animator.startAnimation()
    }

    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning)
    -> UIViewImplicitlyAnimating {
        let containerView = transitionContext.view(forKey: .from) ?? transitionContext.containerView
        let startingOrigin = containerView.frame.origin
        let endOrigin = CGPoint(x: startingOrigin.x, y: UIScreen.main.bounds.height)

        containerView.frame.origin = startingOrigin

        let animator = UIViewPropertyAnimator(duration: Constants.duration, curve: .easeOut) {
            containerView.frame.origin = endOrigin
        }

        animator.addCompletion { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        return animator
    }
}
