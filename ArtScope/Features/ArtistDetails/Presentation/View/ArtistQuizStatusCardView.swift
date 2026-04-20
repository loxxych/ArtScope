//
//  ArtistQuizStatusCardView.swift
//  ArtScope
//
//  Created by loxxy on 15.04.2026.
//

import UIKit

final class ArtistQuizStatusCardView: UIView {
    private enum Constants {
        static let backgroundColor: UIColor = .artScopePink
        static let cornerRadius: CGFloat = 18
        static let inset: CGFloat = 20
        static let titleTopSpacing: CGFloat = 12
        static let bodyTopSpacing: CGFloat = 10
        static let buttonTopSpacing: CGFloat = 18
        static let titleFont: UIFont = .ByteBounce28
        static let bodyFont: UIFont = .InstrumentSansRegular15
        static let spinnerScale: CGFloat = 1.15
    }

    private let spinner = UIActivityIndicatorView(style: .large)
    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()
    private let actionButton = ArtistQuizActionButton()

    var onActionTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureLoading(title: String, body: String) {
        titleLabel.text = title
        bodyLabel.text = body
        spinner.isHidden = false
        spinner.startAnimating()
        actionButton.isHidden = true
    }

    func configureFailure(title: String, body: String, actionTitle: String) {
        titleLabel.text = title
        bodyLabel.text = body
        spinner.stopAnimating()
        spinner.isHidden = true
        actionButton.isHidden = false
        actionButton.isEnabled = true
        actionButton.setTitleText(actionTitle)
    }

    private func configureUI() {
        backgroundColor = Constants.backgroundColor
        layer.cornerRadius = Constants.cornerRadius

        addSubview(spinner)
        addSubview(titleLabel)
        addSubview(bodyLabel)
        addSubview(actionButton)

        spinner.transform = CGAffineTransform(scaleX: Constants.spinnerScale, y: Constants.spinnerScale)
        spinner.color = .white
        spinner.pinTop(to: topAnchor, Constants.inset)
        spinner.pinCenterX(to: self)

        titleLabel.font = Constants.titleFont
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.pinTop(to: spinner.bottomAnchor, Constants.titleTopSpacing)
        titleLabel.pinHorizontal(to: self, Constants.inset)

        bodyLabel.font = Constants.bodyFont
        bodyLabel.numberOfLines = 0
        bodyLabel.textAlignment = .center
        bodyLabel.pinTop(to: titleLabel.bottomAnchor, Constants.bodyTopSpacing)
        bodyLabel.pinHorizontal(to: self, Constants.inset)

        actionButton.isHidden = true
        actionButton.addTarget(self, action: #selector(actionPressed), for: .touchUpInside)
        actionButton.pinTop(to: bodyLabel.bottomAnchor, Constants.buttonTopSpacing)
        actionButton.pinCenterX(to: self)
        actionButton.pinBottom(to: bottomAnchor, Constants.inset)
    }

    @objc private func actionPressed() {
        onActionTapped?()
    }
}
