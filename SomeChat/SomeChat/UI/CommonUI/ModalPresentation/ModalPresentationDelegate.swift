//
//  ModalPresentationDelegate.swift
//  SomeChat
//
//  Created by Алексей Махутин on 29.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

internal final class ModalPresentationController: UIPresentationController {
    private enum Constants {
        static let topOffset: CGFloat = 49
    }

    var driven: ModalPresentationDriven?

    private let dimmerview: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return view
    }()

    override var frameOfPresentedViewInContainerView: CGRect {
        let bounds = self.presentingViewController.view.bounds

        return CGRect(x: 0,
                      y: Constants.topOffset,
                      width: bounds.width,
                      height: bounds.height - Constants.topOffset)
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let presentedView = self.presentedView else { return }

        self.dimmerview.alpha = 0
        self.containerView?.frame = self.presentingViewController.view.bounds
        self.presentedView?.frame = self.frameOfPresentedViewInContainerView
        self.containerView?.addSubview(self.dimmerview)
        self.containerView?.addSubview(presentedView)

        let gesture = UITapGestureRecognizer(target: self, action: #selector(dimmerviewTap))
        self.dimmerview.addGestureRecognizer(gesture)

        self.performAlongsideTransitionIfPossible {
            self.dimmerview.alpha = 1
        }
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()

        self.performAlongsideTransitionIfPossible {
            self.dimmerview.alpha = 0
        }
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)

        if completed {
            self.driven?.work = true
        }
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()

        self.containerView?.frame = self.presentingViewController.view.bounds
        self.dimmerview.frame = self.containerView?.bounds ?? .zero
        let cornerRadius: CGFloat = 20
        self.presentedView?.layer.cornerRadius = cornerRadius
        self.presentedView?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }

    private func performAlongsideTransitionIfPossible(_ block: @escaping () -> Void) {
        guard let coordinator = self.presentedViewController.transitionCoordinator else {
            block()
            return
        }

        coordinator.animate(alongsideTransition: { _ in
            block()
        }, completion: nil)
    }

    @objc private func dimmerviewTap() {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
}
