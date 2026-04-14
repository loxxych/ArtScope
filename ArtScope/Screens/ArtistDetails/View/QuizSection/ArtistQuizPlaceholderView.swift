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
        static let unavailableSubtitleText: String = "Quiz content for this artist will be added next."
        static let titleBottomSpacing: CGFloat = 6
        static let cardTopSpacing: CGFloat = 12
        static let titleFont: UIFont = UIFont(name: "InstrumentSans-Bold", size: 27) ?? .boldSystemFont(ofSize: 27)
        static let subtitleFont: UIFont = UIFont(name: "InstrumentSans-Regular", size: 15) ?? .systemFont(ofSize: 15)
        static let bodyLinesCount: Int = 0
        static let unavailableCardColor: UIColor = UIColor(named: "ArtScopePink") ?? .systemPink
        static let unavailableCardCornerRadius: CGFloat = 18
        static let unavailableCardInset: CGFloat = 18
        static let unavailableCardHeight: CGFloat = 190
        static let readyCardHeight: CGFloat = 190
        static let resultCardHeight: CGFloat = 300
        static let unavailableTitleFont: UIFont = UIFont(name: "ByteBounce", size: 30) ?? .boldSystemFont(ofSize: 30)
        static let unavailableBodyFont: UIFont = UIFont(name: "InstrumentSans-Regular", size: 15) ?? .systemFont(ofSize: 15)
        static let unavailableTitleText: String = "Test yourself!"
        static let unavailableBodyText: String = "We will add questions, answers and scoring here later."
    }
    
    private enum State {
        case unavailable
        case ready
        case question
        case result
    }
    
    // MARK: - Properties
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let contentContainer = UIView()
    private let unavailableCard = UIView()
    private let unavailableTitleLabel = UILabel()
    private let unavailableBodyLabel = UILabel()
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
        configureUnavailableCard()
        configureInteractiveCards()
        show(state: .unavailable)
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
        contentContainerHeightConstraint = contentContainer.setHeight(Constants.unavailableCardHeight)
    }
    
    private func configureUnavailableCard() {
        contentContainer.addSubview(unavailableCard)
        unavailableCard.backgroundColor = Constants.unavailableCardColor
        unavailableCard.layer.cornerRadius = Constants.unavailableCardCornerRadius
        unavailableCard.pin(to: contentContainer)
        
        unavailableCard.addSubview(unavailableTitleLabel)
        unavailableCard.addSubview(unavailableBodyLabel)
        
        unavailableTitleLabel.text = Constants.unavailableTitleText
        unavailableTitleLabel.font = Constants.unavailableTitleFont
        unavailableTitleLabel.pinTop(to: unavailableCard.topAnchor, Constants.unavailableCardInset)
        unavailableTitleLabel.pinHorizontal(to: unavailableCard, Constants.unavailableCardInset)
        
        unavailableBodyLabel.text = Constants.unavailableBodyText
        unavailableBodyLabel.font = Constants.unavailableBodyFont
        unavailableBodyLabel.numberOfLines = 0
        unavailableBodyLabel.pinTop(to: unavailableTitleLabel.bottomAnchor, 10)
        unavailableBodyLabel.pinHorizontal(to: unavailableCard, Constants.unavailableCardInset)
        unavailableBodyLabel.pinBottom(to: unavailableCard.bottomAnchor, Constants.unavailableCardInset)
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
        
        questionCardView.onAdvance = { [weak self] _, wasCorrect in
            self?.advanceQuestion(wasCorrect: wasCorrect)
        }
        
        resultCardView.onRetryTapped = { [weak self] in
            self?.resetQuizFlow()
        }
    }
    
    private func show(state: State) {
        unavailableCard.isHidden = state != .unavailable
        startCardView.isHidden = state != .ready
        readyOverlayButton.isHidden = state != .ready
        questionCardView.isHidden = state != .question
        resultCardView.isHidden = state != .result
        contentContainerBottomConstraint?.isActive = true
        
        switch state {
        case .unavailable:
            contentContainerHeightConstraint?.constant = Constants.unavailableCardHeight
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
    
    private func advanceQuestion(wasCorrect: Bool) {
        if !didCountCurrentAnswer {
            if wasCorrect {
                correctAnswersCount += 1
            }
            didCountCurrentAnswer = true
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
        show(state: .result)
    }
    
    private func resetQuizFlow() {
        currentQuestionIndex = 0
        correctAnswersCount = 0
        didCountCurrentAnswer = false
        show(state: .ready)
    }
    
    func configure(with quiz: Quiz) {
        self.quiz = quiz
        subtitleLabel.text = Constants.subtitleText
        resetQuizFlow()
    }
    
    func configureUnavailableState() {
        quiz = nil
        subtitleLabel.text = Constants.unavailableSubtitleText
        show(state: .unavailable)
    }
}
