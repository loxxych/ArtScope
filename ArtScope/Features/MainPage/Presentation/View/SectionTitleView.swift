//
//  SectionTitleView.swift
//  ArtScope
//
//  Created by loxxy on 22.01.2026.
//

import UIKit

final class SectionTitleView : UIView {
    // MARK: - Constants
    private enum Constants {
        // Text
        static let font: UIFont = .ByteBounce41
        
        // UI Constraint properties
        static let buttonLeft: CGFloat = 6
        static let buttonSize: CGFloat = 24
        
        // Colors
        static let tintColor: UIColor = .black
        static let textColor: UIColor = .black
        
        // Images
        static let buttonImage: UIImage? = UIImage.artScopeHandPoint
    }
    
    // MARK: - Fields
    private let label: UILabel = .init()
    private let button: UIButton = .init(type: .system)
    
    var onButtonPressed: (() -> Void)?
    
    // MARK: - Lifecycle
    init(title: String) {
        label.text = title
        
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI configuration
    private func configureUI() {
        configureLabel()
        configureButton()
    }
    
    // MARK: - Label configuration
    private func configureLabel() {
        addSubview(label)
        
        label.font = Constants.font
        label.textColor = Constants.textColor
        
        label.pinVertical(to: self)
        label.pinLeft(to: self)
    }
    
    // MARK: - Button configuration
    private func configureButton() {
        addSubview(button)
        
        button.setImage(Constants.buttonImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = Constants.tintColor
        
        button.pinLeft(to: label.trailingAnchor, Constants.buttonLeft)
        button.pinRight(to: self)
        button.pinCenterY(to: label)
        button.setWidth(Constants.buttonSize)
        button.setHeight(Constants.buttonSize)
        
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    // MARK: - Button press functions
    @objc private func buttonPressed() {
        onButtonPressed?()
    }
}
