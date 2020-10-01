//
//  ProfileViewController.swift
//  SomeChat
//
//  Created by Алексей Махутин on 20.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

internal final class ProfileViewController: UIViewController, AppCoordinatorProtocol {
    private enum Constants {
        static let saveButtonCornerRadius: CGFloat = 14
        static let editButtonRightInset: CGFloat = 2
        static let topAvatarViewConstrait: CGFloat = 45
        static let placeHolderTextBio = "Entry your bio info"
    }

    var coordinator: AppCoordinator?
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var topAvatarViewConstrait: NSLayoutConstraint!

    private let initialsView = InitialsView()
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

        let avatarViewIsClear = self.avatarView.image == nil
        if avatarViewIsClear {
            let width = self.avatarView.frame.width / 1.578
            let height = self.avatarView.frame.height / 1.7
            let xOrig = self.avatarView.frame.origin.x + (self.avatarView.frame.width - width) / 2
            let yOrig = self.avatarView.frame.origin.y + (self.avatarView.frame.height - height) / 2
            self.initialsView.frame = CGRect(x: xOrig, y: yOrig, width: width, height: height)
        }
        self.initialsView.isHidden = !avatarViewIsClear
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
        self.avatarView.image = self.props?.avatar

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
        self.view.addSubview(self.initialsView)
        self.fullNameTextField.addTarget(self, action: #selector(textFieldDidChangeText(_:)), for: .editingChanged)
        self.editButton.addTarget(self, action: #selector(editButtonDidTap(_:)), for: .touchUpInside)
        self.saveButton.addTarget(self, action: #selector(saveButtonDidTap(_:)), for: .touchUpInside)
        self.initialsView.backgroundColor = .clear
        self.fullNameTextField.delegate = self
        self.bioTextView.delegate = self

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

        let inset = self.bioTextView.frame.maxY - frame.minY
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

    @objc func backgroundDidTap(_ sender: UIGestureRecognizer) {
        self.view.endEditing(true)
    }

    @objc func textFieldDidChangeText(_ textField: UITextField) {
        let whitespace = CharacterSet.whitespaces
        let fullName = textField.text?.split(whereSeparator: { character -> Bool in
            var result = false
            character.unicodeScalars.forEach { unicodeScalar in
                if whitespace.contains(unicodeScalar) {
                    result = true
                }
            }
            return result
        })
        if let firstChar = fullName?.first?.first {
            self.initialsView.firstInitial = String(firstChar) as NSString
        } else {
            self.initialsView.firstInitial = "?"
        }
        if (fullName?.count ?? 0) == 2,
            let secondChar = fullName?.last?.first {
            self.initialsView.secondInitial = String(secondChar) as NSString
        } else {
            self.initialsView.secondInitial = ""
        }
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
        self.avatarView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UINavigationControllerDelegate { }
