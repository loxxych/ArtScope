//
//  QuizzesViewController.swift
//  ArtScope
//
//  Created by loxxy on 22.01.2026.
//

import UIKit

final class QuizzesViewController: UIViewController {
    private enum Constants {
        static let backgroundColor: UIColor = .artScopeGreen
        static let titleTop: CGFloat = 10
        static let sideInset: CGFloat = 20
        static let sectionSpacing: CGFloat = 20
        static let dailyQuizHeight: CGFloat = 204
        static let dividerHeight: CGFloat = 1
        static let bottomInset: CGFloat = 110

        static let titleText = "Quizzes"
        static let quizzesTitleText = "All quizzes"

        static let titleFont: UIFont = .ByteBounce49
        static let sectionTitleFont: UIFont = .ByteBounce35
    }

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let quizOfTheDayView = QuizOfTheDayView()
    private let divider = UIView()
    private let quizzesTitleLabel = UILabel()
    private let quizzesStackView = UIStackView()
    private let emptyStateLabel = UILabel()
    private let footerSpacer = UIView()

    private let viewModel = QuizzesViewModel(
        quizService: QuizServiceFactory.makeQuizService()
    )

    private var dailyQuiz: Quiz?
    private var quizzes: [QuizListItem] = []

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureUI()
        viewModel.load()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func bindViewModel() {
        quizOfTheDayView.onStartButtonTapped = { [weak self] in
            self?.startDailyQuiz()
        }

        viewModel.onDailyQuizLoaded = { [weak self] quiz in
            self?.dailyQuiz = quiz
            self?.quizOfTheDayView.configure(with: quiz)
        }

        viewModel.onQuizzesLoaded = { [weak self] quizzes in
            self?.quizzes = quizzes
            self?.renderQuizList()
        }

        viewModel.onLoadingFailed = { error in
            print("[Quizzes] quiz generation failed: \(error)")
        }
    }

    private func configureUI() {
        view.backgroundColor = Constants.backgroundColor
        configureScrollView()
        configureTitle()
        configureQuizOfTheDay()
        configureDivider()
        configureQuizzesTitle()
        configureQuizzesStack()
        configureEmptyState()
        configureFooterSpacer()
    }

    private func configureScrollView() {
        view.addSubview(scrollView)

        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        scrollView.pinBottom(to: view.bottomAnchor)
        scrollView.pinLeft(to: view.leadingAnchor)
        scrollView.pinRight(to: view.trailingAnchor)

        scrollView.addSubview(contentView)
        contentView.pinTop(to: scrollView.contentLayoutGuide.topAnchor)
        contentView.pinBottom(to: scrollView.contentLayoutGuide.bottomAnchor)
        contentView.pinLeft(to: scrollView.contentLayoutGuide.leadingAnchor)
        contentView.pinRight(to: scrollView.contentLayoutGuide.trailingAnchor)
        contentView.pinWidth(to: scrollView.frameLayoutGuide.widthAnchor)
    }

    private func configureTitle() {
        contentView.addSubview(titleLabel)

        titleLabel.text = Constants.titleText
        titleLabel.font = Constants.titleFont
        titleLabel.textColor = .black
        titleLabel.pinTop(to: contentView.topAnchor, Constants.titleTop)
        titleLabel.pinCenterX(to: contentView)
    }

    private func configureQuizOfTheDay() {
        contentView.addSubview(quizOfTheDayView)

        quizOfTheDayView.setHeight(Constants.dailyQuizHeight)
        quizOfTheDayView.pinTop(to: titleLabel.bottomAnchor, Constants.sectionSpacing)
        quizOfTheDayView.pinLeft(to: contentView.leadingAnchor, Constants.sideInset)
        quizOfTheDayView.pinRight(to: contentView.trailingAnchor, Constants.sideInset)
    }

    private func configureDivider() {
        contentView.addSubview(divider)

        divider.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        divider.pinTop(to: quizOfTheDayView.bottomAnchor, Constants.sectionSpacing)
        divider.pinLeft(to: contentView.leadingAnchor)
        divider.pinRight(to: contentView.trailingAnchor)
        divider.setHeight(Constants.dividerHeight)
    }

    private func configureQuizzesTitle() {
        contentView.addSubview(quizzesTitleLabel)

        quizzesTitleLabel.text = Constants.quizzesTitleText
        quizzesTitleLabel.font = Constants.sectionTitleFont
        quizzesTitleLabel.textColor = .black
        quizzesTitleLabel.pinTop(to: divider.bottomAnchor, Constants.sectionSpacing)
        quizzesTitleLabel.pinLeft(to: contentView.leadingAnchor, Constants.sideInset)
    }

    private func configureQuizzesStack() {
        contentView.addSubview(quizzesStackView)

        quizzesStackView.axis = .vertical
        quizzesStackView.spacing = 10
        quizzesStackView.pinTop(to: quizzesTitleLabel.bottomAnchor, 10)
        quizzesStackView.pinLeft(to: contentView.leadingAnchor, Constants.sideInset)
        quizzesStackView.pinRight(to: contentView.trailingAnchor, Constants.sideInset)
    }

    private func configureEmptyState() {
        contentView.addSubview(emptyStateLabel)

        emptyStateLabel.font = .InstrumentSansRegular15
        emptyStateLabel.textColor = .black
        emptyStateLabel.numberOfLines = 0
        emptyStateLabel.textAlignment = .left
        emptyStateLabel.text = "No generated quizzes yet. Open artists and let Gemini create quizzes, then they will appear here."
        emptyStateLabel.isHidden = true
        emptyStateLabel.pinTop(to: quizzesTitleLabel.bottomAnchor, 10)
        emptyStateLabel.pinLeft(to: contentView.leadingAnchor, Constants.sideInset)
        emptyStateLabel.pinRight(to: contentView.trailingAnchor, Constants.sideInset)
    }

    private func configureFooterSpacer() {
        contentView.addSubview(footerSpacer)

        footerSpacer.backgroundColor = .clear
        footerSpacer.pinTop(to: quizzesStackView.bottomAnchor)
        footerSpacer.pinLeft(to: contentView.leadingAnchor)
        footerSpacer.pinRight(to: contentView.trailingAnchor)
        footerSpacer.setHeight(Constants.bottomInset)
        footerSpacer.pinBottom(to: contentView.bottomAnchor)
    }

    private func renderQuizList() {
        quizzesStackView.arrangedSubviews.forEach {
            quizzesStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        emptyStateLabel.isHidden = !quizzes.isEmpty

        quizzes.forEach { quiz in
            let itemView = QuizListItemView()
            itemView.configure(with: quiz)
            itemView.addTarget(self, action: #selector(quizItemTapped(_:)), for: .touchUpInside)
            itemView.accessibilityIdentifier = quiz.id
            quizzesStackView.addArrangedSubview(itemView)
        }
    }

    @objc private func quizItemTapped(_ sender: QuizListItemView) {
        guard let quizID = sender.accessibilityIdentifier else { return }
        guard let quiz = viewModel.fetchStoredQuiz(id: quizID) else {
            print("[Quizzes] stored quiz not found: \(quizID)")
            return
        }

        let vc = QuizPlayViewController(quiz: quiz)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func startDailyQuiz() {
        guard let dailyQuiz else {
            print("[Quizzes] daily quiz is not ready yet")
            return
        }

        let vc = QuizPlayViewController(quiz: dailyQuiz)
        navigationController?.pushViewController(vc, animated: true)
    }
}
