//
//  CustomInputField.swift
//  ArtScope
//
//  Created by loxxy on 28.01.2026.
//

import UIKit

final class CustomInputField : UIView {
    // MARK: - Constants
    private enum Constants {
        // Strings
        static let defaultText: String = ""
        static let placeholderStart: String = "Enter your "
        // Fonts
        static let titleFont: UIFont? = UIFont(name: "InstrumentSans-Bold", size: 20)

        // UI Constraint properties
        static let titleLeft: CGFloat = 6
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
    }
    
    private func configureTitle() {
        addSubview(titleLabel)
        
        titleLabel.font = Constants.titleFont
        titleLabel.pinTop(to: self.topAnchor)
        titleLabel.pinLeft(to: self.leftAnchor, Constants.titleLeft)
    }
    
    private func configureTextField() {
        addSubview(textField)
        
        textField.placeholder = "\(Constants.placeholderStart) + \(String(describing: titleLabel.text))"
        
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        
        textField.pinHorizontal(to: self)
        textField.pinTop(to: titleLabel.bottomAnchor, 5)
    }

    // MARK: - Getters
    func getTextInput() -> String {
        return textField.text ?? Constants.defaultText
    }
}
