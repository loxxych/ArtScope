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
        // UI Constraint properties
        static let strapAlpha: CGFloat = 0.22
        static let strapWidth: CGFloat = 402
        static let strapHeight: CGFloat = 1
        
        // Fonts
        static let titleFont: UIFont = UIFont(name: "ByteBounce", size: 49) ?? .systemFont(ofSize: 49)
        
        // Strings
        static let titleText: String = "My profile"
        static let quizzesSectionViewTitleText: String = "Quizzes"
        static let quizzesSectionViewDescriptionText: String = "Your completed quiz results"
        static let completedSectionViewTitleText: String = "Completed"
        static let completedSectionViewDescriptionText: String = "The artists, styles and eras you’ve discovered"
        
        // Colors
        static let backgroundColor: UIColor = .artScopeGreen
        static let strapColor: UIColor = .black
    }
    
    // MARK: - Fields
    private let viewModel: ProfileViewModel = ProfileViewModel()
    
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private var titleLabel: UILabel = .init()
    private var miniProfileView: MiniProfileView?
    private let strap: UIView = .init()
    private let settingsView = SettingsView()
    private let quizzesSectionView = SectionView(title: Constants.quizzesSectionViewTitleText, description: Constants.quizzesSectionViewDescriptionText)
    private let completedSectionView = SectionView(title: Constants.completedSectionViewTitleText, description: Constants.completedSectionViewDescriptionText)

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
    
    // MARK: - View model configuration
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
        configureStrap()
        configureSettingsView()
        configureScrollView()
        configureContentStack()
    }
    
    private func configureTitle() {
        view.addSubview(titleLabel)
        
        titleLabel.text = Constants.titleText
        titleLabel.font = Constants.titleFont
        
        titleLabel.pinTop(to: view.topAnchor, 50)
        titleLabel.pinCenterX(to: view)
    }
    
    private func configureStrap() {
        strap.backgroundColor = Constants.strapColor
        strap.alpha = Constants.strapAlpha
        
        strap.setWidth(Constants.strapWidth)
        strap.setHeight(Constants.strapHeight)
    }
    
    private func configureSettingsView() {
        settingsView.onEditProfileTapped = { [weak self] in
            self?.showEditProfileScreen()
        }
        settingsView.setHeight(100)
    }
    
    private func configureQuizzesSection() {
        quizzesSectionView.setHeight(200)
    }
    
    private func configureCompletedSection() {
        completedSectionView.setHeight(200)
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
                
        scrollView.pinTop(to: titleLabel.bottomAnchor, 20)
        scrollView.pinHorizontal(to: view)
        scrollView.pinBottom(to: view.bottomAnchor)
    }
    
    private func configureContentStack() {
        scrollView.addSubview(contentStack)
        
        contentStack.axis = .vertical
        contentStack.spacing = 25
        contentStack.alignment = .fill

        contentStack.addArrangedSubview(strap)
        contentStack.addArrangedSubview(settingsView)
        contentStack.addArrangedSubview(quizzesSectionView)
        contentStack.addArrangedSubview(completedSectionView)
        
        contentStack.pinTop(to: scrollView.contentLayoutGuide.topAnchor)
        contentStack.pinBottom(to: scrollView.contentLayoutGuide.bottomAnchor)
        contentStack.pinHorizontal(to: view)
    }
    
    // MARK: - Navigation
    private func showEditProfileScreen() {
        let vc = EditProfileViewController()

        navigationController?.pushViewController(vc, animated: true)
    }
}

