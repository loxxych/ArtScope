//
//  QuizzesViewController.swift
//  ArtScope
//
//  Created by loxxy on 22.01.2026.
//

import UIKit

final class QuizzesViewController: UIViewController {
    // MARK: - Constants
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
        static let loadingTitleText = "Preparing quiz..."
        static let loadingBodyText = "Loading the quiz and getting everything ready for you."

        static let titleFont: UIFont = .ByteBounce49
        static let sectionTitleFont: UIFont = .ByteBounce35
    }
    
    // MARK: - Fields
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let quizOfTheDayView = QuizOfTheDayView()
    private let divider = UIView()
    private let quizzesTitleLabel = UILabel()
    private let quizzesStackView = UIStackView()
    private let emptyStateLabel = UILabel()
    private let footerSpacer = UIView()
    private let loadingOverlayView = UIView()
    private let loadingCardView = UIView()
    private let loadingSpinner = UIActivityIndicatorView(style: .large)
    private let loadingTitleLabel = UILabel()
    private let loadingBodyLabel = UILabel()

    private let viewModel = QuizzesViewModel(
        quizService: QuizServiceFactory.makeQuizService()
    )

    private var dailyQuiz: Quiz?
    private var quizzes: [QuizListItem] = []
    private var isShowingQuizLoading = false

    // MARK: - Lifecycle
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        quizOfTheDayView.startAnimation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Bind logic
    private func bindViewModel() {
        quizOfTheDayView.onStartButtonTapped = { [weak self] in
            self?.startDailyQuiz()
        }

        viewModel.onDailyQuizLoaded = { [weak self] quiz in
            self?.dailyQuiz = quiz
        }

        viewModel.onQuizzesLoaded = { [weak self] quizzes in
            self?.quizzes = quizzes
            self?.renderQuizList()
        }

        viewModel.onLoadingFailed = { error in
            print("[Quizzes] quiz generation failed: \(error)")
        }
    }

    // MARK: - UI Configuration
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
        configureLoadingOverlay()
    }

    // MARK: - Scroll view configuration
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

    // MARK: - Title configuration
    private func configureTitle() {
        contentView.addSubview(titleLabel)

        titleLabel.text = Constants.titleText
        titleLabel.font = Constants.titleFont
        titleLabel.textColor = .black
        titleLabel.pinTop(to: contentView.topAnchor, Constants.titleTop)
        titleLabel.pinCenterX(to: contentView)
    }

    // MARK: - Quiz of the day configuration
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
        emptyStateLabel.text = "No quizzes available yet."
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

    private func configureLoadingOverlay() {
        view.addSubview(loadingOverlayView)

        loadingOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.12)
        loadingOverlayView.alpha = 0
        loadingOverlayView.isHidden = true
        loadingOverlayView.pin(to: view)

        loadingOverlayView.addSubview(loadingCardView)
        loadingCardView.backgroundColor = .artScopePink
        loadingCardView.layer.cornerRadius = 18
        loadingCardView.layer.shadowColor = UIColor.artScopePink.cgColor
        loadingCardView.layer.shadowOpacity = 0.35
        loadingCardView.layer.shadowRadius = 14
        loadingCardView.layer.shadowOffset = CGSize(width: 0, height: 6)
        loadingCardView.pinCenterX(to: loadingOverlayView)
        loadingCardView.pinCenterY(to: loadingOverlayView)
        loadingCardView.pinLeft(to: loadingOverlayView.leadingAnchor, 28, .grOE)
        loadingCardView.pinRight(to: loadingOverlayView.trailingAnchor, 28, .lsOE)

        loadingCardView.addSubview(loadingSpinner)
        loadingSpinner.color = .white
        loadingSpinner.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        loadingSpinner.pinTop(to: loadingCardView.topAnchor, 28)
        loadingSpinner.pinCenterX(to: loadingCardView)

        loadingCardView.addSubview(loadingTitleLabel)
        loadingTitleLabel.text = Constants.loadingTitleText
        loadingTitleLabel.font = .ByteBounce28
        loadingTitleLabel.textColor = .black
        loadingTitleLabel.textAlignment = .center
        loadingTitleLabel.pinTop(to: loadingSpinner.bottomAnchor, 18)
        loadingTitleLabel.pinLeft(to: loadingCardView.leadingAnchor, 20)
        loadingTitleLabel.pinRight(to: loadingCardView.trailingAnchor, 20)

        loadingCardView.addSubview(loadingBodyLabel)
        loadingBodyLabel.text = Constants.loadingBodyText
        loadingBodyLabel.font = .InstrumentSansRegular15
        loadingBodyLabel.textColor = .black
        loadingBodyLabel.numberOfLines = 0
        loadingBodyLabel.textAlignment = .center
        loadingBodyLabel.pinTop(to: loadingTitleLabel.bottomAnchor, 18)
        loadingBodyLabel.pinLeft(to: loadingCardView.leadingAnchor, 20)
        loadingBodyLabel.pinRight(to: loadingCardView.trailingAnchor, 20)
        loadingBodyLabel.pinBottom(to: loadingCardView.bottomAnchor, 28)
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
        showQuizLoadingOverlay()
        viewModel.loadCuratedQuiz(id: quizID) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.hideQuizLoadingOverlay()

                switch result {
                case let .success(quiz):
                    let vc = QuizPlayViewController(quiz: quiz)

                    vc.onQuizCompleted = { [weak self] in
                        self?.viewModel.load()
                    }
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                case let .failure(error):
                    print("[Quizzes] curated quiz failed: \(error)")
                }
            }
        }
    }

    private func startDailyQuiz() {
        guard let dailyQuiz else {
            print("[Quizzes] daily quiz is not ready yet")
            return
        }

        showQuizLoadingOverlay()
        let vc = QuizPlayViewController(quiz: dailyQuiz)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            guard let self else { return }
            self.hideQuizLoadingOverlay()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    private func showQuizLoadingOverlay() {
        guard !isShowingQuizLoading else { return }
        isShowingQuizLoading = true
        loadingOverlayView.isHidden = false
        loadingSpinner.startAnimating()
        loadingCardView.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)

        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut]) {
            self.loadingOverlayView.alpha = 1
            self.loadingCardView.transform = .identity
        }
    }

    private func hideQuizLoadingOverlay() {
        guard isShowingQuizLoading else { return }
        isShowingQuizLoading = false

        UIView.animate(withDuration: 0.18, delay: 0, options: [.curveEaseInOut]) {
            self.loadingOverlayView.alpha = 0
        } completion: { _ in
            self.loadingSpinner.stopAnimating()
            self.loadingOverlayView.isHidden = true
        }
    }
}
