//
//  AlertPresentationController.swift
//  SomeChat
//
//  Created by Алексей Махутин on 06.10.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

internal final class AlertPresentationController: UIPresentationController {
    private enum Constants {
        static let widthCoffiecent: CGFloat = 4
        static let bottomOffset: CGFloat = 20
    }

    private let dimmerview: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.mainTitle().withAlphaComponent(0.4)
        return view
    }()

    override var frameOfPresentedViewInContainerView: CGRect {
        let bounds = self.presentingViewController.view.bounds
        let bottomInset = self.presentingViewController.view.safeAreaInsets.bottom
        let size = self.presentedViewController.preferredContentSize
        let height = min(size.height, bounds.height)
        let widthCoffiecent = bounds.width / Constants.widthCoffiecent
        let xOrig = widthCoffiecent / 2
        let width = bounds.width - widthCoffiecent
        let yOrig = bounds.height - height - Constants.bottomOffset - bottomInset

        return CGRect(x: xOrig,
                      y: yOrig,
                      width: width,
                      height: height)
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let presentedView = self.presentedView else { return }

        let bounds = self.presentingViewController.view.bounds
        self.dimmerview.alpha = 0
        self.containerView?.frame = self.presentingViewController.view.bounds
        self.presentedView?.frame = self.frameOfPresentedViewInContainerView
        self.presentedView?.frame.origin = CGPoint(x: 0, y: bounds.height)
        self.containerView?.addSubview(self.dimmerview)
        self.containerView?.addSubview(presentedView)

        let gesture = UITapGestureRecognizer(target: self, action: #selector(dimmerviewTap))
        self.dimmerview.addGestureRecognizer(gesture)

        self.performAlongsideTransitionIfPossible {
            self.dimmerview.alpha = 1
            self.presentedView?.frame = self.frameOfPresentedViewInContainerView
        }
    }

    override func dismissalTransitionWillBegin() {
        let xOrig = self.presentedView?.frame.origin.x ?? 0

        self.performAlongsideTransitionIfPossible {
            self.dimmerview.alpha = 0
            self.presentedView?.frame.origin = CGPoint(x: xOrig, y: UIScreen.main.bounds.height)
        }
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()

        self.containerView?.frame = UIScreen.main.bounds
        self.dimmerview.frame = self.containerView?.bounds ?? .zero
        let cornerRadius: CGFloat = 20
        self.presentedView?.layer.cornerRadius = cornerRadius
        self.presentedView?.clipsToBounds = true
    }

    private func performAlongsideTransitionIfPossible(_ block: @escaping () -> Void) {
        guard let coordinator = self.presentedViewController.transitionCoordinator else {
            block()
            return
        }

        coordinator.animate(alongsideTransition: { (_) in
            block()
        }, completion: nil)
    }

    @objc private func dimmerviewTap() {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
}
