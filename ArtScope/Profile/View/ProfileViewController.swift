//
//  ViewController.swift
//  ArtScope
//
//  Created by loxxy on 22.01.2026.
//

import UIKit

final class ProfileViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        // Text
        static let titleText: String = "My profile"
        static let titleFont: UIFont = UIFont(name: "ByteBounce", size: 49) ?? .systemFont(ofSize: 49)
        
        // Colors
        static let backgroundColor: UIColor = UIColor(named: "ArtScopeGreen") ?? .green
    }
    
    // MARK: - Fields
    private let viewModel: ProfileViewModel = ProfileViewModel()
    
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private var titleLabel: UILabel = .init()
    private var miniProfileView: MiniProfileView?
    
    // MARK: - Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        
        viewModel.loadUserProfile()
        
        configureUI()
    }
    
    //    // MARK: - View model configuration
        private func configureViewModel() {
            viewModel.onProfileUpdated = { [weak self] profile in
                guard let self, let profile = profile else { return }
    
                if (miniProfileView != nil) { // Mini profile view exists
                    // Update info
                    miniProfileView?.updateUsername(with: profile.name)
                    miniProfileView?.updatePicture(with: profile.profilePicture)
                } else { // Mini profile doesnt exist
                    miniProfileView = MiniProfileView(title: profile.name, image: profile.profilePicture)
                    
                    guard let miniProfileView else { return }
                    
                    contentStack.addArrangedSubview(miniProfileView)
                }
    
            }
        }
    
    // MARK: - UI Configuration
    private func configureUI() {
        view.backgroundColor = Constants.backgroundColor
        
        configureTitle()
        configureScrollView()
        configureContentStack()
    }
    
    private func configureTitle() {
        view.addSubview(titleLabel)
        
        titleLabel.text = Constants.titleText
        titleLabel.font = Constants.titleFont
        
        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.pinLeft(to: view.leadingAnchor, 20)
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        
        scrollView.pinTop(to: titleLabel.bottomAnchor, 20)
        scrollView.pinLeft(to: view.leadingAnchor)
        scrollView.pinRight(to: view.trailingAnchor)
        scrollView.pinBottom(to: view.bottomAnchor)
    }
    
    private func configureContentStack() {
        scrollView.addSubview(contentStack)
        
        contentStack.axis = .vertical
        contentStack.spacing = 24
        contentStack.alignment = .fill
        
        contentStack.addArrangedSubview(SettingsView())
        
        contentStack.pinTop(to: scrollView.contentLayoutGuide.topAnchor)
        contentStack.pinBottom(to: scrollView.contentLayoutGuide.bottomAnchor)
        contentStack.pinLeft(to: scrollView.frameLayoutGuide.leadingAnchor, 10)
        contentStack.pinRight(to: scrollView.frameLayoutGuide.trailingAnchor, 10)
    }
}

