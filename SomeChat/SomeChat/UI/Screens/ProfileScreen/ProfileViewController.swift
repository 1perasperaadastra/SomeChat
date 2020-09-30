//
//  ProfileViewController.swift
//  SomeChat
//
//  Created by Алексей Махутин on 20.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

internal final class ProfileViewController: ACViewController {
    private enum Constants {
        static let saveButtonCornerRadius: CGFloat = 14
        static let editButtonRightInset: CGFloat = 2
        static let topAvatarViewConstrait: CGFloat = 45
        static let placeHolderTextBio = "Entry your bio info"
    }

    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var topAvatarViewConstrait: NSLayoutConstraint!

    private let textVerification = ProfileTextVerification()
    private var props: ProfileModel?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        Logger.info(self.saveButton.frame.debugDescription) -- Будет крэш так как свойство еще не иницилизированно
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.info(self.saveButton.frame.debugDescription)

        self.setupApperance()
        self.setupContoller()
        self.props?.updateModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Logger.info(self.saveButton.frame.debugDescription)
        //Фрэйм отличается потому как во viewdidload еще не иницилизированны констрейты
        //А в viewDidAppear уже иницилизированны
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.updateEditButtonFrame()
        self.avatarView.layer.cornerRadius = self.avatarView.bounds.height / 2
        self.saveButton.layer.cornerRadius = Constants.saveButtonCornerRadius
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.editButton.constraints.forEach { $0.isActive = false }
    }

    private func updateProps() {
        guard self.fullNameTextField != nil,
            self.bioTextView != nil,
            self.avatarView != nil else { return }

        self.fullNameTextField.text = self.props?.fullName
        self.textFieldDidChangeText(self.fullNameTextField)
        self.bioTextView.text = self.props?.bioInfo
        let avatarModel = AvatarViewModel(fullName: self.props?.fullName ?? "", image: self.props?.avatar)
        self.avatarView.configure(model: avatarModel)

        if bioTextView.text.isEmpty || bioTextView.text == nil {
            bioTextView.text = Constants.placeHolderTextBio
            bioTextView.textColor = UIColor.lightGray
        }
    }

    private func updateEditButtonFrame() {
        if let frame = self.editButton.titleLabel?.frame {
            let xOrig = self.avatarView.frame.maxX - frame.maxX - Constants.editButtonRightInset
            let yOrig = self.avatarView.frame.maxY - frame.maxY
            self.editButton.frame.origin = CGPoint(x: xOrig, y: yOrig)
        }
    }

    private func setupContoller() {
        self.fullNameTextField.addTarget(self, action: #selector(textFieldDidChangeText(_:)), for: .editingChanged)
        self.editButton.addTarget(self, action: #selector(editButtonDidTap(_:)), for: .touchUpInside)
        self.saveButton.addTarget(self, action: #selector(saveButtonDidTap(_:)), for: .touchUpInside)
        self.fullNameTextField.delegate = self
        self.bioTextView.delegate = self

        self.navigationItem.title = "My Profile"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close",
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(didTapCloseButton(_:)))
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)

        let gesture = UITapGestureRecognizer(target: self, action: #selector(backgroundDidTap(_:)))
        self.view.addGestureRecognizer(gesture)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIWindow.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIWindow.keyboardWillHideNotification,
                                               object: nil)
    }

    private func setupApperance() {
        self.avatarView.clipsToBounds = true
        self.saveButton.clipsToBounds = true
        self.fullNameTextField.font = Fonts.profileScreenName(24)
        self.bioTextView.font = Fonts.profileScreenBIO(16)
        self.editButton.titleLabel?.font = Fonts.profileScreenButton(16)
        self.saveButton.titleLabel?.font = Fonts.profileScreenButton(19)
    }

    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let frame = notification.keyboardEndFrame else { return }

        let bioTextFrame = self.view.window?.convert(self.bioTextView.frame, from: self.view) ?? .zero
        let inset = bioTextFrame.maxY - frame.minY
        var topAvatarViewConstrait = Constants.topAvatarViewConstrait
        let bioTrippleLineHeight = (self.bioTextView.font?.lineHeight ?? 0) * 3
        if bioTrippleLineHeight > self.bioTextView.frame.height - inset,
            self.bioTextView.isFirstResponder {
            topAvatarViewConstrait -= bioTrippleLineHeight - (self.bioTextView.frame.height - inset)
        }
        notification.keyboardAnimate(animations: {
            self.bioTextView.contentInset.bottom = inset
            self.topAvatarViewConstrait.constant = topAvatarViewConstrait
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        notification.keyboardAnimate(animations: {
            self.bioTextView.contentInset.bottom = 0
            self.view.frame.origin = .zero
            self.topAvatarViewConstrait.constant = Constants.topAvatarViewConstrait
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    @objc func saveButtonDidTap(_ sender: UIButton) {
        let model = PofileSaveModel(fullName: self.fullNameTextField.text ?? "",
                                    bioInfo: self.bioTextView.text,
                                    avatar: self.avatarView.image)
        self.props?.didTapSaveButton(with: model)
    }

    @objc func editButtonDidTap(_ sender: UIButton) {
        self.coordinator?.showImagePicker(controller: self, delegate: self)
    }

    @objc func didTapCloseButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func backgroundDidTap(_ sender: UIGestureRecognizer) {
        self.view.endEditing(true)
    }

    @objc func textFieldDidChangeText(_ textField: UITextField) {
        let avatarModel = AvatarViewModel(fullName: textField.text ?? "",
                                          image: self.avatarView.image)
        self.avatarView.configure(model: avatarModel)
    }
}

extension ProfileViewController: ProfileRender {
    func render(props: ProfileModel) {
        self.props = props
        self.updateProps()
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        return self.textVerification.isCorrectFullNameTextСhange(text: textField.text ?? "",
                                                             range: range,
                                                             replacementText: string)
    }
}

extension ProfileViewController: UITextViewDelegate {
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        return self.textVerification.isCorrectBioTextСhange(text: textView.text,
                                                             range: range,
                                                             replacementText: text)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constants.placeHolderTextBio
            textView.textColor = UIColor.lightGray
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        let avatarModel = AvatarViewModel(fullName: self.fullNameTextField.text ?? "", image: image)
        self.avatarView.configure(model: avatarModel)
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UINavigationControllerDelegate { }
