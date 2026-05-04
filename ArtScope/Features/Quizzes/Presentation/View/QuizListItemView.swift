//
//  QuizListItemView.swift
//  ArtScope
//
//  Created by loxxy on 20.04.2026.
//

import UIKit

final class QuizListItemView: UIControl {
    private enum Constants {
        static let verticalInset: CGFloat = 8
        static let titleFont: UIFont = .InstrumentSansBold18
        static let descriptionFont: UIFont = .InstrumentSansRegular15
        static let iconSize: CGFloat = 20
    }

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let iconView = UIImageView()
    private let checkmarkView = UIImageView()
    private let titleRowView = UIView()
    private let titleContentStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: QuizListItem) {
        titleLabel.text = item.title
        descriptionLabel.text = item.description
        
        checkmarkView.isHidden = !item.isCompleted
    }

    private func configureUI() {
        backgroundColor = .clear
        isUserInteractionEnabled = true

        let textStack = UIStackView(arrangedSubviews: [titleRowView, descriptionLabel])
        let containerStack = UIStackView(arrangedSubviews: [textStack, iconView])
        
        addSubview(containerStack)

        titleRowView.addSubview(titleContentStack)
        titleRowView.translatesAutoresizingMaskIntoConstraints = false

        titleContentStack.axis = .horizontal
        titleContentStack.alignment = .center
        titleContentStack.spacing = 4
        titleContentStack.addArrangedSubview(titleLabel)
        titleContentStack.addArrangedSubview(checkmarkView)
        titleContentStack.pinTop(to: titleRowView.topAnchor)
        titleContentStack.pinLeft(to: titleRowView.leadingAnchor)
        titleContentStack.pinBottom(to: titleRowView.bottomAnchor)
        titleContentStack.pinRight(to: titleRowView.trailingAnchor, 0, .lsOE)
        
        textStack.axis = .vertical
        textStack.spacing = 2
        textStack.setContentHuggingPriority(.required, for: .horizontal)
        
        containerStack.axis = .horizontal
        containerStack.alignment = .center
        containerStack.spacing = 12
        containerStack.distribution = .fill
        containerStack.pinTop(to: topAnchor, Constants.verticalInset)
        containerStack.pinBottom(to: bottomAnchor, Constants.verticalInset)
        containerStack.pinLeft(to: leadingAnchor)
        containerStack.pinRight(to: trailingAnchor)
        
        titleLabel.font = Constants.titleFont
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 1
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        descriptionLabel.font = Constants.descriptionFont
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 2

        iconView.image = UIImage.artScopeHandPoint
        iconView.tintColor = .black
        iconView.contentMode = .scaleAspectFit
        iconView.setWidth(Constants.iconSize)
        iconView.setHeight(Constants.iconSize)
        
        checkmarkView.image = UIImage.checkmarkIcon
        checkmarkView.tintColor = .systemGreen
        checkmarkView.isHidden = true
        checkmarkView.setContentHuggingPriority(.required, for: .horizontal)
        checkmarkView.setContentCompressionResistancePriority(.required, for: .horizontal)
        checkmarkView.setWidth(20)
        checkmarkView.setHeight(20)
    }

    override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.65 : 1
        }
    }
}
