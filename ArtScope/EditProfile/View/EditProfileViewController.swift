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
        
        // Colors
        static let backgroundColor: UIColor = UIColor(named: "ArtScopeGreen") ?? .green
    }
    
    // MARK: - Fields
    private let viewModel: ProfileViewModel = ProfileViewModel()
    
    private var titleLabel: UILabel = .init()
    private var profilePictureView: ProfilePictureView = ProfilePictureView()
    private var nameInputField: CustomInputField = CustomInputField(title: "Name")
    
    // MARK: - Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //configureViewModel()
        
        //viewModel.loadUserProfile()
        
        configureUI()
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        view.backgroundColor = Constants.backgroundColor
        
        configureTitle()
        configureProfilePictureView()
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
        
        profilePictureView.pinTop(to: view.topAnchor, 100)
        profilePictureView.pinCenterX(to: view)
    }
    
    private func configureCustomTextField() {
        view.addSubview(nameInputField)
        
        nameInputField.pinTop(to: profilePictureView.topAnchor, 30)
        nameInputField.pinCenterX(to: view)
    }
}

