//
//  MenuBarView.swift
//  ArtScope
//
//  Created by loxxy on 22.01.2026.
//

import UIKit

final class MenuBarView: UIView {
    // MARK: - Constants
    private enum Constants {
        // UI Constraint properties
        static let cornerRadius: CGFloat = 24
        static let shadowOpacity: Float = 0.25
        static let shadowWidthOffset: CGFloat = 0
        static let shadowHeightOffset: CGFloat = -4
        static let shadowRadius: CGFloat = 10
        static let inititalSelected: Int = 0
        static let stackViewHorizontal: CGFloat = 16
        
        // Colors
        static let backgroundColor: UIColor = .black
        static let shadowColor: CGColor = UIColor.black.cgColor
        static let unpickedColor: UIColor = .white
        static let pickedColor: UIColor = .artScopePink
    }
    
    // MARK: - Fields
    weak var delegate: MenuBarDelegate?
    
    private var buttons: [UIButton] = []
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI configuration
    private func configureUI() {
        backgroundColor = Constants.backgroundColor
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = false
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowOffset = CGSize(width: Constants.shadowWidthOffset, height: Constants.shadowHeightOffset)
        layer.shadowRadius = Constants.shadowRadius
        
        configureButtons()
    }

    private func configureButtons() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center

        MenuItem.allCases.forEach { item in
            let button = UIButton(type: .system)
            button.tag = item.rawValue

            button.setImage(item.icon, for: .normal)
            button.tintColor = Constants.unpickedColor

            button.addTarget(self,
                             action: #selector(tabTapped(_:)),
                             for: .touchUpInside)

            buttons.append(button)
            stackView.addArrangedSubview(button)
        }

        addSubview(stackView)

        stackView.pinHorizontal(to: self, Constants.stackViewHorizontal)
        stackView.pinVertical(to: self)

        selectTab(index: Constants.inititalSelected)
    }
    
    // MARK: - Button press functions
    @objc private func tabTapped(_ sender: UIButton) {
        selectTab(index: sender.tag)
        delegate?.didSelectTab(index: sender.tag)
    }
    
    // MARK: - Utility functions
    private func selectTab(index: Int) {
        buttons.forEach {
            $0.tintColor = $0.tag == index ? Constants.pickedColor : Constants.unpickedColor
        }
    }
}
