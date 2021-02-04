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
    typealias DismissCompletionBlock = () -> Void

    var dismissCompletionBlock: DismissCompletionBlock? { get set }
    var coordinator: AppCoordinator? { get set }
}

internal final class AppCoordinator {

    private let container: AppContainer
    private var transtion: ModalPresentationTransition?
    private var conversationListPresenter: ConversationListPresenter?
    private var conversationPresenter: ConversationPresenter?
    private var themesPresenter: ThemesPresenter?
    private var profilePresenter: ProfilePresenter?

    init(container: AppContainer) {
        self.container = container
    }

    func start(window: UIWindow) {
        let presenter = ConversationListPresenter(containerService: self.container,
                                                  container: self.container)
        let controller = self.createController(type: ConversationListViewController.self)
        self.conversationListPresenter = presenter
        self.setupDismissBlock(controller: controller) {
            self.conversationListPresenter = nil
        }
        presenter.render = controller as? ConversationListRender
        presenter.start()
        let nav = BaseNavigationController(rootViewController: controller)

        window.rootViewController = nav
        window.makeKeyAndVisible()
    }

    func showMainProfile(mainVC: UIViewController) {
        let presenter = ProfilePresenter(container: self.container)
        self.profilePresenter = presenter
        let controller = self.createController(type: ProfileViewController.self)
        self.setupDismissBlock(controller: controller) {
            self.profilePresenter = nil
        }
        presenter.render = controller as? ProfileRender
        presenter.start()
        let nav = BaseNavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .custom
        self.transtion = ModalPresentationTransition()
        let transitionDelegate = self.transtion
        nav.transitioningDelegate = transitionDelegate

        mainVC.present(nav, animated: true, completion: nil)
    }

    func showConversation(mainVC: UIViewController, conversation: ConversationViewModel) {
        guard mainVC.navigationController != nil else { return }

        let presenter = ConversationPresenter(container: self.container, member: conversation)
        self.conversationPresenter = presenter
        let controller = self.createController(type: ConversationViewController.self)
        self.setupDismissBlock(controller: controller) {
            self.conversationPresenter = nil
        }
        presenter.render = controller as? ConversationRender
        presenter.start()
        mainVC.navigationController?.pushViewController(controller, animated: true)
    }

    func showThemeMenu(mainVC: UIViewController) {
        guard mainVC.navigationController != nil else { return }

        let presenter = ThemesPresenter(container: self.container)
        let controller = self.createController(type: ThemesViewController.self)
        presenter.render = controller as? ThemesRender
        presenter.start()
        self.themesPresenter = presenter
        self.setupDismissBlock(controller: controller) {
            self.themesPresenter = nil
        }
        mainVC.navigationController?.pushViewController(controller, animated: true)
    }

    func showImagePicker(controller: UIViewController,
                         delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        var models = [AlertCellModelProtocol]()
        models.append(AlertTitleModel(mainTitle: "Edit photo",
                                      secondTitle: "Please, choose one of the ways"))
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            models.append(AlertActionModel(mainTitle: "Camera", action: Command(action: {
                self.showImagePickerCamera(controller: controller, delegate: delegate)
            })))
        }
        models.append(AlertActionModel(mainTitle: "Photo Gallery", action: Command(action: {
            self.showImagePickerPhoto(controller: controller, delegate: delegate)
        })))
        models.append(AlertActionModel(mainTitle: "Cancel", action: Command(action: {})))
        let alert = AlertController(models: models)
        controller.present(alert, animated: true, completion: nil)
    }

    private func setupDismissBlock(controller: UIViewController, block: @escaping () -> Void) {
        if let controller = controller as? BaseViewController {
            controller.dismissCompletionBlock = block
        }
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
