//
//  ArtistQuizPlaceholderView.swift
//  ArtScope
//
//  Created by loxxy on 25.03.2026.
//

import UIKit

final class ArtistQuizPlaceholderView: UIView {
    // MARK: - Constants
    private enum Constants {
        static let titleText: String = "Quiz"
        static let subtitleText: String = "Complete a short quiz to test your knowledge!"
        static let loadingSubtitleText: String = "Generating a quiz based on this artist's life and works."
        static let unavailableSubtitleText: String = "We couldn't generate a quiz for this artist right now."
        static let titleBottomSpacing: CGFloat = 6
        static let cardTopSpacing: CGFloat = 12
        static let titleFont: UIFont = .InstrumentSansBold27
        static let subtitleFont: UIFont = .InstrumentSansRegular15
        static let bodyLinesCount: Int = 0
        static let statusCardHeight: CGFloat = 190
        static let readyCardHeight: CGFloat = 190
        static let resultCardHeight: CGFloat = 360
        static let loadingTitleText: String = "Preparing quiz..."
        static let loadingBodyText: String = "Creating a short English quiz from the artist biography and artworks."
        static let unavailableTitleText: String = "Quiz unavailable"
        static let unavailableBodyText: String = "The quiz couldn't be generated. Try requesting it again."
        static let retryButtonTitle: String = "Try again"
    }
    
    private enum State {
        case loading
        case unavailable
        case ready
        case question
        case result
    }
    
    // MARK: - Properties
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let contentContainer = UIView()
    private let statusCardView = ArtistQuizStatusCardView()
    private let startCardView = ArtistQuizStartCardView()
    private let readyOverlayButton = UIButton(type: .custom)
    private let questionCardView = ArtistQuizQuestionCardView()
    private let resultCardView = ArtistQuizResultCardView()
    private var contentContainerHeightConstraint: NSLayoutConstraint?
    private var contentContainerBottomConstraint: NSLayoutConstraint?
    
    private var quiz: Quiz?
    private var currentQuestionIndex = 0
    private var correctAnswersCount = 0
    private var didCountCurrentAnswer = false
    private var selectedAnswersByQuestionID: [String: String] = [:]

    var onRetryTapped: (() -> Void)?
    var onQuizCompleted: ((Quiz, Int, Int, [CompletedQuizAnswerRecord]) -> Void)?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func configureUI() {
        configureTitle()
        configureSubtitle()
        configureContentContainer()
        configureStatusCard()
        configureInteractiveCards()
        show(state: .loading)
    }
    
    private func configureTitle() {
        addSubview(titleLabel)
        titleLabel.text = Constants.titleText
        titleLabel.font = Constants.titleFont
        titleLabel.pinTop(to: topAnchor)
        titleLabel.pinHorizontal(to: self)
    }
    
    private func configureSubtitle() {
        addSubview(subtitleLabel)
        subtitleLabel.text = Constants.subtitleText
        subtitleLabel.font = Constants.subtitleFont
        subtitleLabel.numberOfLines = Constants.bodyLinesCount
        subtitleLabel.pinTop(to: titleLabel.bottomAnchor, Constants.titleBottomSpacing)
        subtitleLabel.pinHorizontal(to: self)
    }
    
    private func configureContentContainer() {
        addSubview(contentContainer)
        contentContainer.pinTop(to: subtitleLabel.bottomAnchor, Constants.cardTopSpacing)
        contentContainer.pinHorizontal(to: self)
        contentContainerBottomConstraint = contentContainer.pinBottom(to: bottomAnchor)
        contentContainerHeightConstraint = contentContainer.setHeight(Constants.statusCardHeight)
    }
    
    private func configureStatusCard() {
        contentContainer.addSubview(statusCardView)
        statusCardView.pin(to: contentContainer)
        statusCardView.onActionTapped = { [weak self] in
            self?.onRetryTapped?()
        }
    }
    
    private func configureInteractiveCards() {
        [startCardView, questionCardView, resultCardView].forEach {
            contentContainer.addSubview($0)
            $0.pin(to: contentContainer)
            $0.isHidden = true
        }
        
        contentContainer.addSubview(readyOverlayButton)
        readyOverlayButton.pin(to: contentContainer)
        readyOverlayButton.backgroundColor = .clear
        readyOverlayButton.isHidden = true
        readyOverlayButton.addTarget(self, action: #selector(beginButtonPressed), for: .touchUpInside)
        
        startCardView.onBeginTapped = { [weak self] in
            self?.beginQuiz()
        }
        
        questionCardView.onAdvance = { [weak self] selectedOptionID, wasCorrect in
            self?.advanceQuestion(selectedOptionID: selectedOptionID, wasCorrect: wasCorrect)
        }
        
        resultCardView.onRetryTapped = { [weak self] in
            self?.resetQuizFlow()
        }
    }
    
    private func show(state: State) {
        statusCardView.isHidden = !(state == .loading || state == .unavailable)
        startCardView.isHidden = state != .ready
        readyOverlayButton.isHidden = state != .ready
        questionCardView.isHidden = state != .question
        resultCardView.isHidden = state != .result
        contentContainerBottomConstraint?.isActive = true
        
        switch state {
        case .loading:
            contentContainerHeightConstraint?.constant = Constants.statusCardHeight
            contentContainerHeightConstraint?.isActive = true
        case .unavailable:
            contentContainerHeightConstraint?.constant = Constants.statusCardHeight
            contentContainerHeightConstraint?.isActive = true
        case .ready:
            contentContainerHeightConstraint?.constant = Constants.readyCardHeight
            contentContainerHeightConstraint?.isActive = true
        case .result:
            contentContainerHeightConstraint?.constant = Constants.resultCardHeight
            contentContainerHeightConstraint?.isActive = true
        case .question:
            contentContainerHeightConstraint?.isActive = false
        }
        
        layoutIfNeeded()
    }
    
    private func beginQuiz() {
        currentQuestionIndex = 0
        correctAnswersCount = 0
        didCountCurrentAnswer = false
        selectedAnswersByQuestionID.removeAll()
        showCurrentQuestion()
    }
    
    @objc private func beginButtonPressed() {
        beginQuiz()
    }
    
    private func showCurrentQuestion() {
        guard
            let quiz,
            quiz.payload.questions.indices.contains(currentQuestionIndex)
        else {
            showResult()
            return
        }
        
        didCountCurrentAnswer = false
        questionCardView.configure(question: quiz.payload.questions[currentQuestionIndex])
        show(state: .question)
    }
    
    private func advanceQuestion(selectedOptionID: String?, wasCorrect: Bool) {
        if !didCountCurrentAnswer {
            if wasCorrect {
                correctAnswersCount += 1
            }
            didCountCurrentAnswer = true
        }

        if
            let quiz,
            quiz.payload.questions.indices.contains(currentQuestionIndex)
        {
            let questionID = quiz.payload.questions[currentQuestionIndex].id
            if let selectedOptionID {
                selectedAnswersByQuestionID[questionID] = selectedOptionID
            }
        }
        
        currentQuestionIndex += 1
        
        guard let quiz else {
            show(state: .unavailable)
            return
        }
        
        if currentQuestionIndex < quiz.payload.questions.count {
            showCurrentQuestion()
        } else {
            showResult()
        }
    }
    
    private func showResult() {
        let totalQuestions = quiz?.payload.questions.count ?? 0
        resultCardView.configure(correctAnswers: correctAnswersCount, totalQuestions: totalQuestions)
        if let quiz {
            onQuizCompleted?(
                quiz,
                correctAnswersCount,
                totalQuestions,
                quiz.payload.questions.map { question in
                    let index = quiz.payload.questions.firstIndex(where: { $0.id == question.id }) ?? 0
                    return CompletedQuizAnswerRecord(
                        questionIndex: index,
                        questionID: question.id,
                        selectedOptionID: selectedAnswersByQuestionID[question.id]
                    )
                }
            )
        }
        show(state: .result)
    }
    
    private func resetQuizFlow() {
        currentQuestionIndex = 0
        correctAnswersCount = 0
        didCountCurrentAnswer = false
        selectedAnswersByQuestionID.removeAll()
        show(state: .ready)
    }
    
    func configure(with quiz: Quiz) {
        self.quiz = quiz
        subtitleLabel.text = Constants.subtitleText
        resetQuizFlow()
    }

    func configureLoadingState() {
        subtitleLabel.text = Constants.loadingSubtitleText
        statusCardView.configureLoading(
            title: Constants.loadingTitleText,
            body: Constants.loadingBodyText
        )
        show(state: .loading)
    }
    
    func configureUnavailableState() {
        quiz = nil
        subtitleLabel.text = Constants.unavailableSubtitleText
        statusCardView.configureFailure(
            title: Constants.unavailableTitleText,
            body: Constants.unavailableBodyText,
            actionTitle: Constants.retryButtonTitle
        )
        show(state: .unavailable)
    }
}
