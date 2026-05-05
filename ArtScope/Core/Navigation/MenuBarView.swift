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
        static let borderWidth: CGFloat = 1
        
        // Colors
        static let backgroundColor: UIColor = .black
        static let shadowColor: CGColor = UIColor.black.cgColor
        static let unpickedColor: UIColor = .white
        static let pickedColor: UIColor = .artScopePink
        static let tintOverlayColor: UIColor = UIColor.black.withAlphaComponent(0.58)
        static let borderColor: CGColor = UIColor.white.withAlphaComponent(0.16).cgColor
        static let topHighlightColor: CGColor = UIColor.white.withAlphaComponent(0.18).cgColor
        static let bottomHighlightColor: CGColor = UIColor.white.withAlphaComponent(0.02).cgColor
    }
    
    // MARK: - Fields
    weak var delegate: MenuBarDelegate?
    
    private var buttons: [UIButton] = []
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
    private let tintOverlayView = UIView()
    private let topHighlightView = UIView()
    private let topHighlightLayer = CAGradientLayer()
    private let contentContainer = UIView()
    
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
        backgroundColor = .clear
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = false
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowOffset = CGSize(width: Constants.shadowWidthOffset, height: Constants.shadowHeightOffset)
        layer.shadowRadius = Constants.shadowRadius

        contentContainer.backgroundColor = .clear
        contentContainer.layer.cornerRadius = Constants.cornerRadius
        contentContainer.layer.masksToBounds = true
        contentContainer.layer.borderWidth = Constants.borderWidth
        contentContainer.layer.borderColor = Constants.borderColor
        addSubview(contentContainer)
        contentContainer.pin(to: self)

        blurView.clipsToBounds = true
        contentContainer.addSubview(blurView)
        blurView.pin(to: contentContainer)

        tintOverlayView.backgroundColor = Constants.tintOverlayColor
        contentContainer.addSubview(tintOverlayView)
        tintOverlayView.pin(to: contentContainer)

        topHighlightView.backgroundColor = .clear
        contentContainer.addSubview(topHighlightView)
        topHighlightView.pinTop(to: contentContainer.topAnchor)
        topHighlightView.pinLeft(to: contentContainer.leadingAnchor)
        topHighlightView.pinRight(to: contentContainer.trailingAnchor)
        topHighlightView.setHeight(26)

        topHighlightLayer.colors = [
            Constants.topHighlightColor,
            Constants.bottomHighlightColor
        ]
        topHighlightLayer.startPoint = CGPoint(x: 0.5, y: 0)
        topHighlightLayer.endPoint = CGPoint(x: 0.5, y: 1)
        topHighlightView.layer.addSublayer(topHighlightLayer)
        
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

        contentContainer.addSubview(stackView)

        stackView.pinHorizontal(to: contentContainer, Constants.stackViewHorizontal)
        stackView.pinVertical(to: contentContainer)

        selectTab(index: Constants.inititalSelected)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        topHighlightLayer.frame = topHighlightView.bounds
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
