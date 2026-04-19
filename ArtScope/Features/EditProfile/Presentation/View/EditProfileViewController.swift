//
//  EditProfileViewController.swift
//  ArtScope
//
//  Created by loxxy on 28.01.2026.
//

import UIKit

final class EditProfileViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        // Layout
        static let sideInset: CGFloat = 28
        static let headerTopInset: CGFloat = 12
        static let backButtonLeftInset: CGFloat = 20
        static let backButtonSize: CGFloat = 28
        static let pictureTopInset: CGFloat = 68
        static let pictureSize: CGFloat = 160
        static let nameFieldTopInset: CGFloat = 32
        static let saveButtonBottomInset: CGFloat = 40
        static let saveButtonWidth: CGFloat = 162
        static let saveButtonHeight: CGFloat = 48
        static let saveButtonCornerRadius: CGFloat = 24

        // Text
        static let titleText: String = "Edit profile"
        static let saveButtonText: String = "Save"
        static let nameFieldTitle: String = "Name"

        // Fonts
        static let titleFont: UIFont = UIFont(name: "ByteBounce", size: 49) ?? .systemFont(ofSize: 49)
        static let saveButtonFont: UIFont = UIFont(name: "InstrumentSans-SemiBold", size: 20) ?? .systemFont(ofSize: 20, weight: .semibold)

        // Colors
        static let backgroundColor: UIColor = UIColor(named: "ArtScopeGreen") ?? .green
        static let saveButtonColor: UIColor = UIColor(named: "ArtScopeBlue") ?? .systemBlue
        static let saveButtonTextColor: UIColor = .white
        static let accentColor: UIColor = .black

        // Images
        static let backImage: UIImage? = UIImage(systemName: "chevron.left")
    }

    // MARK: - Fields
    private let viewModel: EditProfileViewModel = EditProfileViewModel()

    private let backButton: UIButton = .init(type: .system)
    private let titleLabel: UILabel = .init()
    private let profilePictureView = ProfilePictureView()
    private let nameInputField = CustomInputField(title: Constants.nameFieldTitle)
    private let saveButton: UIButton = .init(type: .system)

    // MARK: - Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        menuController?.setMenuBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        menuController?.setMenuBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        configureUI()

        viewModel.loadUserProfile()
    }

    // MARK: - ViewModel configuration
    private func configureViewModel() {
        viewModel.onProfileUpdated = { [weak self] profile in
            guard let self, let profile = profile else { return }

            profilePictureView.updatePicture(with: profile.profilePicture)
            nameInputField.setTextInput(profile.name)
        }
    }

    // MARK: - UI Configuration
    private func configureUI() {
        view.backgroundColor = Constants.backgroundColor

        configureBackButton()
        configureTitle()
        configureProfilePictureView()
        configureCustomTextField()
        configureSaveButton()
    }

    private func configureBackButton() {
        view.addSubview(backButton)

        backButton.setImage(Constants.backImage, for: .normal)
        backButton.tintColor = Constants.accentColor

        backButton.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.headerTopInset)
        backButton.pinLeft(to: view.leadingAnchor, Constants.backButtonLeftInset)
        backButton.setWidth(Constants.backButtonSize)
        backButton.setHeight(Constants.backButtonSize)

        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }

    private func configureTitle() {
        view.addSubview(titleLabel)

        titleLabel.text = Constants.titleText
        titleLabel.font = Constants.titleFont
        titleLabel.textAlignment = .center

        titleLabel.pinCenterX(to: view)
        titleLabel.pinCenterY(to: backButton)
    }

    private func configureProfilePictureView() {
        view.addSubview(profilePictureView)

        profilePictureView.pinTop(to: titleLabel.bottomAnchor, Constants.pictureTopInset)
        profilePictureView.pinCenterX(to: view)
        profilePictureView.setWidth(Constants.pictureSize)
        profilePictureView.setHeight(Constants.pictureSize)
    }

    private func configureCustomTextField() {
        view.addSubview(nameInputField)

        nameInputField.pinTop(to: profilePictureView.bottomAnchor, Constants.nameFieldTopInset)
        nameInputField.pinHorizontal(to: view, Constants.sideInset)
    }

    private func configureSaveButton() {
        view.addSubview(saveButton)

        saveButton.backgroundColor = Constants.saveButtonColor
        saveButton.setTitle(Constants.saveButtonText, for: .normal)
        saveButton.titleLabel?.font = Constants.saveButtonFont
        saveButton.tintColor = Constants.saveButtonTextColor
        saveButton.layer.cornerRadius = Constants.saveButtonCornerRadius

        saveButton.pinCenterX(to: view)
        saveButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, Constants.saveButtonBottomInset)
        saveButton.setWidth(Constants.saveButtonWidth)
        saveButton.setHeight(Constants.saveButtonHeight)

        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
    }

    // MARK: - Button press functions
    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func saveButtonPressed() {
        let name = nameInputField.getTextInput()
        let picture = profilePictureView.getPicture()
        viewModel.saveUserProfile(name: name, profilePicture: picture)
        navigationController?.popViewController(animated: true)
    }
}
