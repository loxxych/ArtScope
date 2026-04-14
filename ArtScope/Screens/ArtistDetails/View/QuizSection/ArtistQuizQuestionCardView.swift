//
//  ArtistQuizQuestionCardView.swift
//  ArtScope
//
//  Created by loxxy on 14.04.2026.
//

import UIKit

final class ArtistQuizQuestionCardView: UIView {
    private enum Constants {
        static let backgroundColor: UIColor = UIColor(named: "ArtScopePink") ?? .systemPink
        static let cornerRadius: CGFloat = 18
        static let inset: CGFloat = 18
        static let stackSpacing: CGFloat = 14
        static let promptBottomSpacing: CGFloat = 18
        static let explanationBottomSpacing: CGFloat = 12
        static let buttonTopSpacing: CGFloat = 20
        static let promptFont: UIFont = UIFont(name: "InstrumentSans-Bold", size: 24) ?? .boldSystemFont(ofSize: 24)
        static let promptLines: Int = 0
        static let answerTitle: String = "Answer"
        static let nextTitle: String = "Next"
    }
    
    private let promptLabel = UILabel()
    private let explanationView = ArtistQuizExplanationView()
    private let optionsStack = UIStackView()
    private let actionButton = ArtistQuizActionButton()
    private var explanationHeightConstraint: NSLayoutConstraint?
    
    private var optionViews: [ArtistQuizOptionView] = []
    private var question: QuizQuestion?
    private var selectedOptionID: String?
    private var hasRevealedAnswer = false
    
    var onAdvance: ((String, Bool) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(question: QuizQuestion) {
        self.question = question
        selectedOptionID = nil
        hasRevealedAnswer = false
        promptLabel.text = question.prompt
        explanationView.configure(text: nil)
        explanationHeightConstraint?.constant = 0
        explanationHeightConstraint?.isActive = true
        actionButton.isEnabled = false
        actionButton.setTitleText(Constants.answerTitle)
        rebuildOptions(for: question)
    }
    
    private func configureUI() {
        backgroundColor = Constants.backgroundColor
        layer.cornerRadius = Constants.cornerRadius
        
        addSubview(promptLabel)
        addSubview(explanationView)
        addSubview(optionsStack)
        addSubview(actionButton)
        
        promptLabel.font = Constants.promptFont
        promptLabel.numberOfLines = Constants.promptLines
        promptLabel.pinTop(to: topAnchor, Constants.inset)
        promptLabel.pinHorizontal(to: self, Constants.inset)
        
        explanationView.isHidden = true
        explanationView.pinTop(to: promptLabel.bottomAnchor, Constants.promptBottomSpacing)
        explanationView.pinHorizontal(to: self, Constants.inset)
        explanationHeightConstraint = explanationView.setHeight(0)
        
        optionsStack.axis = .vertical
        optionsStack.spacing = Constants.stackSpacing
        optionsStack.pinTop(to: explanationView.bottomAnchor, Constants.explanationBottomSpacing)
        optionsStack.pinHorizontal(to: self, Constants.inset)
        
        actionButton.setTitleText(Constants.answerTitle)
        actionButton.isEnabled = false
        actionButton.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
        actionButton.pinTop(to: optionsStack.bottomAnchor, Constants.buttonTopSpacing)
        actionButton.pinCenterX(to: self)
        actionButton.pinBottom(to: bottomAnchor, Constants.inset)
    }
    
    private func rebuildOptions(for question: QuizQuestion) {
        optionViews.forEach {
            optionsStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        optionViews.removeAll()
        
        question.options.forEach { option in
            let optionView = ArtistQuizOptionView(optionID: option.id, title: option.text)
            optionView.addTarget(self, action: #selector(optionTapped(_:)), for: .touchUpInside)
            optionsStack.addArrangedSubview(optionView)
            optionViews.append(optionView)
        }
    }
    
    @objc private func optionTapped(_ sender: ArtistQuizOptionView) {
        guard !hasRevealedAnswer else { return }
        selectedOptionID = sender.optionID
        actionButton.isEnabled = true
        
        optionViews.forEach {
            $0.apply(style: $0.optionID == sender.optionID ? .selected : .normal)
        }
    }
    
    @objc private func actionTapped() {
        guard let question else { return }
        
        if hasRevealedAnswer {
            onAdvance?(question.correctOptionID, selectedOptionID == question.correctOptionID)
            return
        }
        
        revealAnswer(for: question)
    }
    
    private func revealAnswer(for question: QuizQuestion) {
        guard let selectedOptionID else { return }
        
        hasRevealedAnswer = true
        actionButton.setTitleText(Constants.nextTitle)
        explanationView.configure(text: question.explanation)
        explanationHeightConstraint?.isActive = false
        setNeedsLayout()
        layoutIfNeeded()
        
        optionViews.forEach { optionView in
            if optionView.optionID == question.correctOptionID {
                optionView.apply(style: .correct)
            } else if optionView.optionID == selectedOptionID, selectedOptionID != question.correctOptionID {
                optionView.apply(style: .incorrect)
            } else {
                optionView.apply(style: .subdued)
            }
        }
    }
}
