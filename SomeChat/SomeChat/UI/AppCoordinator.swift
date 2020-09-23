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

    func start(window: UIWindow) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let configuration = UserConfiguration(with: UserDefaults.standard)
        let imageSource = ImageSource()
        let controller = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
        let presenter = ProfilePresenter(configuration: configuration, imageSource: imageSource)
        if let controller = controller as? ProfileRender {
            presenter.render = controller
        }
        (controller as? AppCoordinatorProtocol)?.coordinator = self
        presenter.start()
        window.rootViewController = controller
        window.makeKeyAndVisible()
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
