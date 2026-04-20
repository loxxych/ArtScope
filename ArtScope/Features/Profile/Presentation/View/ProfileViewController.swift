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
        // Layout
        static let titleTopInset: CGFloat = 16
        static let titleLeftInset: CGFloat = 24
        static let scrollTopInset: CGFloat = 18
        static let sectionSpacing: CGFloat = 28
        static let contentBottomInset: CGFloat = 120
        static let settingsHeight: CGFloat = 108
        static let quizzesHeight: CGFloat = 230
        static let completedHeight: CGFloat = 230
        static let strapAlpha: CGFloat = 0.22
        static let strapHeight: CGFloat = 1

        // Fonts
        static let titleFont: UIFont = .ByteBounce49

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
    private let contentView = UIView()
    private let contentStack = UIStackView()
    private let titleLabel: UILabel = .init()
    private var miniProfileView: MiniProfileView?
    private let strap: UIView = .init()
    private let settingsView = SettingsView()
    private let quizzesSectionView = SectionView(
        title: Constants.quizzesSectionViewTitleText,
        description: Constants.quizzesSectionViewDescriptionText
    )
    private let completedSectionView = SectionView(
        title: Constants.completedSectionViewTitleText,
        description: Constants.completedSectionViewDescriptionText
    )

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
        configureUI()

        viewModel.loadUserProfile()
    }

    // MARK: - View model configuration
    private func configureViewModel() {
        viewModel.onProfileUpdated = { [weak self] profile in
            guard let self, let profile = profile else { return }

            if let miniProfileView {
                miniProfileView.updateUsername(with: profile.name)
                miniProfileView.updatePicture(with: profile.profilePicture)
                return
            }

            let profileView = MiniProfileView(title: profile.name, image: profile.profilePicture)
            miniProfileView = profileView
            contentStack.insertArrangedSubview(profileView, at: 0)
        }
    }

    // MARK: - UI Configuration
    private func configureUI() {
        view.backgroundColor = Constants.backgroundColor

        configureTitle()
        configureStrap()
        configureSettingsView()
        configureQuizzesSection()
        configureCompletedSection()
        configureScrollView()
        configureContentView()
        configureContentStack()
    }

    private func configureTitle() {
        view.addSubview(titleLabel)

        titleLabel.text = Constants.titleText
        titleLabel.font = Constants.titleFont

        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.titleTopInset)
        titleLabel.pinLeft(to: view.leadingAnchor, Constants.titleLeftInset)
    }

    private func configureStrap() {
        strap.backgroundColor = Constants.strapColor
        strap.alpha = Constants.strapAlpha
        strap.setHeight(Constants.strapHeight)
    }

    private func configureSettingsView() {
        settingsView.onEditProfileTapped = { [weak self] in
            self?.showEditProfileScreen()
        }

        settingsView.setHeight(Constants.settingsHeight)
    }

    private func configureQuizzesSection() {
        quizzesSectionView.setHeight(Constants.quizzesHeight)
    }

    private func configureCompletedSection() {
        completedSectionView.setHeight(Constants.completedHeight)
    }

    private func configureScrollView() {
        view.addSubview(scrollView)

        scrollView.pinTop(to: titleLabel.bottomAnchor, Constants.scrollTopInset)
        scrollView.pinHorizontal(to: view)
        scrollView.pinBottom(to: view.bottomAnchor)
    }

    private func configureContentView() {
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }

    private func configureContentStack() {
        contentView.addSubview(contentStack)

        contentStack.axis = .vertical
        contentStack.spacing = Constants.sectionSpacing
        contentStack.alignment = .fill
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        contentStack.addArrangedSubview(strap)
        contentStack.addArrangedSubview(settingsView)
        contentStack.addArrangedSubview(quizzesSectionView)
        contentStack.addArrangedSubview(completedSectionView)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.contentBottomInset)
        ])
    }

    // MARK: - Navigation
    private func showEditProfileScreen() {
        let vc = EditProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
