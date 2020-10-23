//
//  ProfileViewController.swift
//  SomeChat
//
//  Created by Алексей Махутин on 20.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import UIKit

internal final class ProfileViewController: BaseViewController {
    private enum Constants {
        static let saveEditStateButtonCornerRadius: CGFloat = 14
        static let editButtonRightInset: CGFloat = 2
        static let topAvatarViewConstrait: CGFloat = 45
        static let placeHolderTextBio = "Entry your bio info"
    }

    private enum State {
        case editable
        case preview
    }

    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var editStateButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var saveStackView: UIStackView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var topAvatarViewConstrait: NSLayoutConstraint!
    private var dimmingView: UIView?

    private let textVerification = ProfileTextVerification()
    private var props: ProfileModel?
    private var state = State.preview {
        didSet { self.updateState() }
    }
    private var gcdButtonTaped = false

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.props?.updateModel()
        self.setupApperance()
        self.setupContoller()
        self.updateColor()
        self.updateState()
        self.activityView.isHidden = true
        self.setupActivity(isHidden: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.updateEditButtonFrame()
        self.avatarView.layer.cornerRadius = self.avatarView.bounds.height / 2
        self.editStateButton.layer.cornerRadius = Constants.saveEditStateButtonCornerRadius
        self.saveStackView.arrangedSubviews.forEach { view in
            guard let button = view as? UIButton else { return }

            button.layer.cornerRadius = Constants.saveEditStateButtonCornerRadius
        }
        self.dimmingView?.frame = self.view.bounds
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.editButton.constraints.forEach { $0.isActive = false }
    }

    override func didChangeColorTheme() {
        super.didChangeColorTheme()

        self.updateColor()
    }

    private func updateProps() {
        guard self.fullNameTextField != nil,
            self.bioTextView != nil,
            self.avatarView != nil else { return }

        if self.props?.fullName?.count ?? 0 > 3 {
            self.fullNameTextField.text = self.props?.fullName
        }
        self.textFieldDidChangeText(self.fullNameTextField)
        self.bioTextView.text = self.props?.bioInfo
        let avatarModel = AvatarViewModel(fullName: self.props?.fullName ?? "", image: self.props?.avatar)
        self.avatarView.configure(model: avatarModel)

        if bioTextView.text.isEmpty || bioTextView.text == nil {
            bioTextView.text = Constants.placeHolderTextBio
            bioTextView.textColor = UIColor.lightGray
        } else {
            bioTextView.textColor = Colors.mainTitle()
        }
        self.setupActivity(isHidden: true)
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
        self.editStateButton.addTarget(self, action: #selector(editStateDidTap(_:)), for: .touchUpInside)
        self.fullNameTextField.delegate = self
        self.bioTextView.delegate = self

        self.navigationItem.title = "My Profile"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close",
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(didTapCloseButton(_:)))

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
        self.fullNameTextField.font = Fonts.profileScreenName(24)
        self.bioTextView.font = Fonts.profileScreenBIO(16)
        self.editButton.titleLabel?.font = Fonts.profileScreenButton(16)

        self.editStateButton.titleLabel?.font = Fonts.profileScreenButton(19)
        self.editStateButton.clipsToBounds = true
        self.saveStackView.arrangedSubviews.forEach { view in
            guard let button = view as? UIButton else { return }

            button.clipsToBounds = true
            button.titleLabel?.font = Fonts.profileScreenButton(19)
        }
    }

    private func updateColor() {
        self.editStateButton.backgroundColor = Colors.buttonBackground()
        self.saveStackView.arrangedSubviews.forEach { view in
            guard let button = view as? UIButton else { return }

            button.backgroundColor = Colors.buttonBackground()
        }
        self.bioTextView.tintColor = Colors.mainTitle()
        self.bioTextView.tintColorDidChange()
    }

    private func updateState() {
        self.editStateButton.isHidden = self.state == .editable
        self.saveStackView.isHidden = self.state == .preview
        self.editButton.isHidden = self.state == .preview
        self.fullNameTextField.isUserInteractionEnabled = self.state == .editable
        self.bioTextView.isUserInteractionEnabled = self.state == .editable
    }

    private func setupActivity(isHidden: Bool) {
        self.activityView.isHidden = isHidden
        if isHidden {
            self.activityView.stopAnimating()
            self.dimmingView?.removeFromSuperview()
            self.dimmingView = nil
        } else {
            self.activityView.startAnimating()
            if self.dimmingView == nil {
                let view = UIView()
                view.backgroundColor = self.view.backgroundColor?.withAlphaComponent(0.5)
                self.dimmingView = view
                self.view.addSubview(view)
            }
            self.view.bringSubviewToFront(self.activityView)
        }
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
            self.topAvatarViewConstrait.constant = Constants.topAvatarViewConstrait
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    @objc func editStateDidTap(_ sender: UIButton) {
        self.state = .editable
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
        self.props?.didNameChanged(with: textField.text ?? "")
    }

    @IBAction func didTapGCDButton() {
        self.setupActivity(isHidden: false)
        self.props?.didTapSaveWithGCD()
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.gcdButtonTaped = true
    }

    @IBAction func didTapOperationButton() {
        self.setupActivity(isHidden: false)
        self.props?.didTapSaveWithOperation()
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.gcdButtonTaped = false
    }
}

extension ProfileViewController: ProfileRender {

    func render(props: ProfileSaveButtonModel) {
        guard self.saveStackView != nil else { return }

        self.saveStackView.arrangedSubviews.forEach { view in
            guard let button = view as? UIButton else { return }

            button.isEnabled = props.isEnabled
        }
    }

    func render(props: ProfileSaveResultModel) {
        switch props.result {
        case .error:
            self.coordinator?.showProfileErrorAlert(controller: self, actiobButton: {
                self.setupActivity(isHidden: true)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }, repearBlock: {
                if self.gcdButtonTaped {
                    self.didTapGCDButton()
                } else {
                    self.didTapOperationButton()
                }
            })
        case .succesful:
            self.coordinator?.showProfileSuccessfulAlert(controller: self) {
                self.props?.updateModel()
                self.state = .preview
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }

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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.fullNameTextField {
            textField.resignFirstResponder()
            return true
        }
        return false
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
            textView.textColor = Colors.mainTitle()
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constants.placeHolderTextBio
            textView.textColor = UIColor.lightGray
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        self.props?.didBioChanged(with: textView.text)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        let avatarModel = AvatarViewModel(fullName: self.fullNameTextField.text ?? "", image: image)
        self.avatarView.configure(model: avatarModel)
        if let newImage = image {
            self.props?.didImageChanged(with: newImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UINavigationControllerDelegate { }
