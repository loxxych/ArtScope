//
//  ArtistQuizResultCardView.swift
//  ArtScope
//
//  Created by loxxy on 14.04.2026.
//

import UIKit

final class ArtistQuizResultCardView: UIView {
    private enum Constants {
        static let backgroundColor: UIColor = UIColor(named: "ArtScopePink") ?? .systemPink
        static let cornerRadius: CGFloat = 18
        static let inset: CGFloat = 20
        static let iconTopSpacing: CGFloat = 4
        static let titleTopSpacing: CGFloat = 10
        static let subtitleTopSpacing: CGFloat = 6
        static let scoreTopSpacing: CGFloat = 18
        static let progressTopSpacing: CGFloat = 16
        static let buttonTopSpacing: CGFloat = 26
        static let iconSize: CGFloat = 80
        static let progressHeight: CGFloat = 10
        static let titleFont: UIFont = UIFont(name: "InstrumentSans-Bold", size: 27) ?? .boldSystemFont(ofSize: 27)
        static let subtitleFont: UIFont = UIFont(name: "InstrumentSans-Regular", size: 15) ?? .systemFont(ofSize: 15)
        static let scoreFont: UIFont = UIFont(name: "ByteBounce", size: 48) ?? .boldSystemFont(ofSize: 48)
        static let titleText: String = "Congratulations!"
        static let subtitleText: String = "You did great! Keep going at it."
        static let retryTitle: String = "Retry"
        static let progressTrackColor: UIColor = UIColor(named: "ArtScopeBlue")?.withAlphaComponent(0.3) ?? .systemBlue.withAlphaComponent(0.3)
        static let progressFillColor: UIColor = UIColor(named: "ArtScopeBlue") ?? .systemBlue
    }
    
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let scoreLabel = UILabel()
    private let progressView = UIProgressView(progressViewStyle: .default)
    private let retryButton = UIButton(type: .system)
    
    var onRetryTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(correctAnswers: Int, totalQuestions: Int) {
        let total = max(totalQuestions, 1)
        let percentage = Int((Double(correctAnswers) / Double(total)) * 100)
        scoreLabel.text = "\(percentage) %"
        progressView.progress = Float(percentage) / 100
    }
    
    private func configureUI() {
        backgroundColor = Constants.backgroundColor
        layer.cornerRadius = Constants.cornerRadius
        
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(scoreLabel)
        addSubview(progressView)
        addSubview(retryButton)
        
        iconView.image = AppImages.leaderboard?.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = UIColor(red: 236/255, green: 244/255, blue: 87/255, alpha: 1)
        iconView.contentMode = .scaleAspectFit
        iconView.setWidth(Constants.iconSize)
        iconView.setHeight(Constants.iconSize)
        iconView.pinTop(to: topAnchor, Constants.inset + Constants.iconTopSpacing)
        iconView.pinCenterX(to: self)
        
        titleLabel.text = Constants.titleText
        titleLabel.font = Constants.titleFont
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.pinTop(to: iconView.bottomAnchor, Constants.titleTopSpacing)
        titleLabel.pinHorizontal(to: self, Constants.inset)
        
        subtitleLabel.text = Constants.subtitleText
        subtitleLabel.font = Constants.subtitleFont
        subtitleLabel.textColor = .white
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.pinTop(to: titleLabel.bottomAnchor, Constants.subtitleTopSpacing)
        subtitleLabel.pinHorizontal(to: self, Constants.inset)
        
        scoreLabel.font = Constants.scoreFont
        scoreLabel.textColor = UIColor(named: "ArtScopeBlue") ?? .systemBlue
        scoreLabel.textAlignment = .center
        scoreLabel.pinTop(to: subtitleLabel.bottomAnchor, Constants.scoreTopSpacing)
        scoreLabel.pinHorizontal(to: self, Constants.inset)
        
        progressView.trackTintColor = Constants.progressTrackColor
        progressView.progressTintColor = Constants.progressFillColor
        progressView.layer.cornerRadius = Constants.progressHeight / 2
        progressView.clipsToBounds = true
        progressView.pinTop(to: scoreLabel.bottomAnchor, Constants.progressTopSpacing)
        progressView.pinHorizontal(to: self, Constants.inset + 12)
        progressView.setHeight(Constants.progressHeight)
        
        retryButton.setTitle(Constants.retryTitle, for: .normal)
        retryButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        retryButton.semanticContentAttribute = .forceRightToLeft
        retryButton.titleLabel?.font = UIFont(name: "InstrumentSans-SemiBold", size: 15) ?? .systemFont(ofSize: 15, weight: .semibold)
        retryButton.tintColor = .white
        retryButton.backgroundColor = .black
        retryButton.layer.cornerRadius = 20
        retryButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 26, bottom: 0, right: 26)
        retryButton.setHeight(40)
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        retryButton.pinTop(to: progressView.bottomAnchor, Constants.buttonTopSpacing)
        retryButton.pinCenterX(to: self)
        retryButton.pinBottom(to: bottomAnchor, Constants.inset)
    }
    
    @objc private func retryTapped() {
        onRetryTapped?()
    }
}
