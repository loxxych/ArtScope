//
//  ViewController.swift
//  ArtScope
//
//  Created by loxxy on 22.01.2026.
//

import UIKit

final class QuizzesViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        // UI Constraint properties
        static let titleTop: CGFloat = 20
        static let quizOfTheDayViewWidth: CGFloat = 353
        static let quizOfTheDayViewHeight: CGFloat = 204
        static let quizOfTheDayViewTop: CGFloat = 20
        static let strapAlpha: CGFloat = 0.22
        static let strapWidth: CGFloat = 400
        static let strapHeight: CGFloat = 1
        static let strapTopBottom: CGFloat = 20
        static let quizzesTitleLeft: CGFloat = 20
        
        // Strings
        static let titleText: String = "Quizzes"
        static let quizzesTitleText: String = "All quizzes"
        
        // Colors
        static let backgroundColor: UIColor = UIColor(named: "ArtScopeGreen") ?? .green
        static let strapColor: UIColor = .black
        
        // Fonts
        static let titleFont: UIFont = UIFont(name: "ByteBounce", size: 49) ?? .systemFont(ofSize: 49)
        static let quizzesTitleFont: UIFont = UIFont(name: "ByteBounce", size: 35) ?? .systemFont(ofSize: 35)
    }
    
    // MARK: - Fields
    private let titleLabel: UILabel = .init()
    private let quizOfTheDayView: QuizOfTheDayView = .init()
    private let strap: UIView = .init()
    private let quizzesTitleLabel: UILabel = .init()
    
    // MARK: - Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - UI Configuration
    private func configureUI() {
        view.backgroundColor = Constants.backgroundColor
        
        configureTitle()
        configureQuizOfTheDay()
        configureStrap()
        configureQuizzesTitle()
    }

    private func configureTitle() {
        view.addSubview(titleLabel)
        
        titleLabel.text = Constants.titleText
        titleLabel.font = Constants.titleFont
        
        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.pinCenterX(to: view)
    }
    
    private func configureQuizOfTheDay() {
        view.addSubview(quizOfTheDayView)
        
        quizOfTheDayView.setWidth(Constants.quizOfTheDayViewWidth)
        quizOfTheDayView.setHeight(Constants.quizOfTheDayViewHeight)
        quizOfTheDayView.pinTop(to: titleLabel.bottomAnchor, Constants.quizOfTheDayViewTop)
        quizOfTheDayView.pinCenterX(to: view)
    }
    
    private func configureStrap() {
        view.addSubview(strap)
        
        strap.backgroundColor = Constants.strapColor
        strap.alpha = Constants.strapAlpha
        
        strap.setWidth(Constants.strapWidth)
        strap.setHeight(Constants.strapHeight)
        strap.pinTop(to: quizOfTheDayView.bottomAnchor, Constants.strapTopBottom)
        strap.pinCenterX(to: view)
    }

    private func configureQuizzesTitle() {
        view.addSubview(quizzesTitleLabel)
        
        quizzesTitleLabel.text = Constants.quizzesTitleText
        quizzesTitleLabel.font = Constants.quizzesTitleFont
        
        quizzesTitleLabel.pinTop(to: strap.bottomAnchor, Constants.strapTopBottom)
        quizzesTitleLabel.pinLeft(to: view.leadingAnchor, Constants.quizzesTitleLeft)
    }

}

