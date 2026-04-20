//
//  SettingsView.swift
//  ArtScope
//
//  Created by loxxy on 25.01.2026.
//

import UIKit

final class SettingsView : UIView {
    // MARK: - Constants
    private enum Constants {
        // Layout
        static let horizontalInset: CGFloat = 20
        static let itemTop: CGFloat = 10
        
        // Strings
        static let titleText: String = "Settings"
        
        // Fonts
        static let titleFont: UIFont? = UIFont.InstrumentSansBold27
    }
    
    // MARK: - Fields
    private let title: UILabel = .init()
    let settingsItem: SettingsItem = .init()
    
    var onEditProfileTapped: (() -> Void)?
    
    // MARK: - Lifecycle
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        configureTitle()
        configureSettingsItem()
        
    }
    
    private func configureTitle() {
        addSubview(title)
        
        title.text = Constants.titleText
        title.font = Constants.titleFont
        
        title.pinLeft(to: self, Constants.horizontalInset)
        title.pinTop(to: self)
    }
    
    private func configureSettingsItem() {
        addSubview(settingsItem)
        
        settingsItem.onButtonPressed = { [weak self] in
            self?.onEditProfileTapped?()
        }
        
        settingsItem.isUserInteractionEnabled = true
        
        settingsItem.pinTop(to: title.bottomAnchor, Constants.itemTop)
        settingsItem.pinHorizontal(to: self, Constants.horizontalInset)
        settingsItem.setHeight(50)
    }
}
