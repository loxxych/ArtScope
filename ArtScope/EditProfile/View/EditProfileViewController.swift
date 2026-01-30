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
        // Text
        static let titleText: String = "Edit profile"
        static let titleFont: UIFont = UIFont(name: "ByteBounce", size: 49) ?? .systemFont(ofSize: 49)
        static let saveButtonText: String = "Save"
        
        // Colors
        static let backgroundColor: UIColor = UIColor(named: "ArtScopeGreen") ?? .green
    }
    
    // MARK: - Fields
    private let viewModel: EditProfileViewModel = EditProfileViewModel()
    
    private var titleLabel: UILabel = .init()
    private var profilePictureView: ProfilePictureView = ProfilePictureView()
    private var nameInputField: CustomInputField = CustomInputField(title: "Name")
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
        menuController?.setMenuBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        menuController?.setMenuBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        
        viewModel.loadUserProfile()
        
        configureUI()
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
        
        configureTitle()
        configureProfilePictureView()
        configureCustomTextField()
        configureSaveButton()
    }
    
    private func configureTitle() {
        view.addSubview(titleLabel)
        
        titleLabel.text = Constants.titleText
        titleLabel.font = Constants.titleFont
        
        titleLabel.pinTop(to: view.topAnchor, 40)
        titleLabel.pinLeft(to: view.leadingAnchor, 20)
    }
    
    private func configureProfilePictureView() {
        view.addSubview(profilePictureView)
        
        profilePictureView.layer.cornerRadius = 100
        
        profilePictureView.pinTop(to: titleLabel.bottomAnchor, 100)
        profilePictureView.pinCenterX(to: view)
        profilePictureView.setHeight(200)
        profilePictureView.setWidth(200)
    }
    
    private func configureCustomTextField() {
        view.addSubview(nameInputField)
        
        nameInputField.pinTop(to: profilePictureView.bottomAnchor, 30)
        nameInputField.pinCenterX(to: view)
        nameInputField.setHeight(100)
        nameInputField.setWidth(200)
    }
    
    private func configureSaveButton() {
        view.addSubview(saveButton)
        
        saveButton.backgroundColor = UIColor(named: "ArtScopeBlue")
        saveButton.setTitle(Constants.saveButtonText, for: .normal)
        saveButton.tintColor = .white
        saveButton.pinTop(to: nameInputField.topAnchor, 400)
        saveButton.pinCenterX(to: view)
        saveButton.setWidth(133)
        saveButton.setHeight(43)
        saveButton.layer.cornerRadius = 20
        
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
    }
    
    // MARK: - Button press functions
    @objc private func saveButtonPressed() {
        let name = nameInputField.getTextInput()
        let picture = profilePictureView.getPicture()
        viewModel.saveUserProfile(name: name, profilePicture: picture)
    }
}

