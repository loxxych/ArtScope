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
        // UI Constraint properties
        static let viewHeight: CGFloat = 42
        static let itemTop: CGFloat = 10
        
        // Strings
        static let titleText: String = "Settings"
        
        // Fonts
        static let titleFont: UIFont? = UIFont(name: "InstrumentSans-Bold", size: 27)
    }
    
    // MARK: - Fields
    private let title: UILabel = .init()
    private let settingsItem: SettingsItem = .init()
    
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
        
        title.pinLeft(to: self)
        title.pinTop(to: self)
    }
    
    private func configureSettingsItem() {
        addSubview(settingsItem)
        
        settingsItem.pinTop(to: title.bottomAnchor, Constants.itemTop)
        settingsItem.pinHorizontal(to: self)
    }
}
