//
//  CustomInputField.swift
//  ArtScope
//
//  Created by loxxy on 28.01.2026.
//

import UIKit

final class CustomInputField: UIView {
    // MARK: - Constants
    private enum Constants {
        // Layout
        static let titleBottomInset: CGFloat = 10
        static let horizontalTextInset: CGFloat = 18
        static let fieldHeight: CGFloat = 56
        static let cornerRadius: CGFloat = 28
        static let borderWidth: CGFloat = 1

        // Strings
        static let defaultText: String = ""
        static let placeholderPrefix: String = "Enter your "

        // Fonts
        static let titleFont: UIFont = UIFont(name: "InstrumentSans-Bold", size: 18) ?? .systemFont(ofSize: 18, weight: .bold)
        static let textFont: UIFont = UIFont(name: "InstrumentSans-Regular", size: 18) ?? .systemFont(ofSize: 18)

        // Colors
        static let textColor: UIColor = .black
        static let placeholderColor: UIColor = UIColor.black.withAlphaComponent(0.28)
        static let borderColor: UIColor = UIColor.black.withAlphaComponent(0.18)
        static let backgroundColor: UIColor = .clear
    }

    // MARK: - Fields
    private let textField: UITextField = .init()
    private let titleLabel: UILabel = .init()

    // MARK: - Lifecycle
    init(title: String) {
        titleLabel.text = title
        super.init(frame: .zero)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Configuration
    private func configureUI() {
        configureTitle()
        configureTextField()
        pinBottom(to: textField.bottomAnchor)
    }

    private func configureTitle() {
        addSubview(titleLabel)

        titleLabel.font = Constants.titleFont
        titleLabel.textColor = Constants.textColor

        titleLabel.pinTop(to: topAnchor)
        titleLabel.pinLeft(to: leadingAnchor)
        titleLabel.pinRight(to: trailingAnchor)
    }

    private func configureTextField() {
        addSubview(textField)

        textField.font = Constants.textFont
        textField.textColor = Constants.textColor
        textField.backgroundColor = Constants.backgroundColor
        textField.borderStyle = .none
        textField.layer.cornerRadius = Constants.cornerRadius
        textField.layer.borderWidth = Constants.borderWidth
        textField.layer.borderColor = Constants.borderColor.cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.horizontalTextInset, height: Constants.fieldHeight))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.horizontalTextInset, height: Constants.fieldHeight))
        textField.rightViewMode = .always
        textField.attributedPlaceholder = NSAttributedString(
            string: Constants.placeholderPrefix + (titleLabel.text ?? "").lowercased(),
            attributes: [.foregroundColor: Constants.placeholderColor]
        )

        textField.pinTop(to: titleLabel.bottomAnchor, Constants.titleBottomInset)
        textField.pinHorizontal(to: self)
        textField.setHeight(Constants.fieldHeight)
    }

    // MARK: - Getters and setters
    func getTextInput() -> String {
        textField.text ?? Constants.defaultText
    }

    func setTextInput(_ text: String) {
        textField.text = text
    }
}
