//
//  AppCoordinator.swift
//  SomeChat
//
//  Created by Алексей Махутин on 20.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation

internal protocol AppCoordinatorProtocol: class {
    var coordinator: AppCoordinator? { get set }
}

internal final class AppCoordinator {

    private let imageSource = ImageSource()
    private let configuration = UserConfiguration(with: UserDefaults.standard)
    private var transtion: ModalPresentationTransition?
    private var conversationListPresenter: ConversationListPresenter?

    func start(window: UIWindow) {
        let dataSource = ConversationListDataSource()
        let presenter = ConversationListPresenter(dataSource: dataSource,
                                                  configuration: self.configuration,
                                                  imageSource: self.imageSource)
        let controller = self.createController(type: ConversationListViewController.self)
        self.conversationListPresenter = presenter
        presenter.render = controller as? ConversationListRender
        presenter.start()
        let nav = UINavigationController(rootViewController: controller)

        window.rootViewController = nav
        window.makeKeyAndVisible()
    }

    func showMainProfile(mainVC: UIViewController) {
        let presenter = ProfilePresenter(configuration: self.configuration,
                                         imageSource: self.imageSource)
        let controller = self.createController(type: ProfileViewController.self)
        presenter.render = controller as? ProfileRender
        presenter.start()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .custom
        self.transtion = ModalPresentationTransition()
        let transitionDelegate = self.transtion
        nav.transitioningDelegate = transitionDelegate

        mainVC.present(nav, animated: true, completion: nil)
    }

    func showConversation(mainVC: UIViewController, conversation: ConversationViewModel) {
        guard mainVC.navigationController != nil else { return }

        let dataSource = ConversationDataSource()
        let presenter = ConversationPresenter(dataSource: dataSource, member: conversation)
        let controller = self.createController(type: ConversationViewController.self)
        presenter.render = controller as? ConversationRender
        presenter.start()
        mainVC.navigationController?.pushViewController(controller, animated: true)
    }

    func showImagePicker(controller: UIViewController,
                         delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.showImagePickerCamera(controller: controller, delegate: delegate)
            }))
        }
        alert.addAction(UIAlertAction(title: "Photos", style: .default, handler: { _ in
            self.showImagePickerPhoto(controller: controller, delegate: delegate)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }

    private func createController<T>(type: T) -> UIViewController {
        let storyboardName = String(describing: type).replacingOccurrences(of: "ViewController", with: "")
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: type))
        (controller as? AppCoordinatorProtocol)?.coordinator = self
        return controller
    }

    private func showImagePickerPhoto(controller: UIViewController,
                                      delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        let picker = UIImagePickerController()
        picker.mediaTypes = [kUTTypeImage as String]
        picker.sourceType = .photoLibrary
        picker.delegate = delegate
        controller.present(picker, animated: true, completion: nil)
    }

    private func showImagePickerCamera(controller: UIViewController,
                                       delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        let picker = UIImagePickerController()
        picker.mediaTypes = [kUTTypeImage as String]
        picker.sourceType = .camera
        picker.delegate = delegate
        controller.present(picker, animated: true, completion: nil)
    }
}
