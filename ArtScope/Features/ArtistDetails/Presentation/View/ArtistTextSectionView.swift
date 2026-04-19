//
//  ArtistTextSectionView.swift
//  ArtScope
//
//  Created by loxxy on 25.03.2026.
//

import UIKit

final class ArtistTextSectionView: UIView {
    // MARK: - Constants
    private enum Constants {
        static let titleBottomSpacing: CGFloat = 8
        static let buttonTopSpacing: CGFloat = 10
        static let titleFont: UIFont = UIFont(name: "InstrumentSans-Bold", size: 27) ?? .boldSystemFont(ofSize: 27)
        static let bodyFont: UIFont = UIFont(name: "InstrumentSans-Regular", size: 15) ?? .systemFont(ofSize: 15)
        static let bodyLinesCount: Int = 0
        static let collapsedBodyLinesCount: Int = 4
        static let actionFont: UIFont = UIFont(name: "InstrumentSans-Regular", size: 15) ?? .systemFont(ofSize: 15)
        static let actionTitleExpanded: String = "Hide >"
        static let actionTitleCollapsed: String = "Learn more >"
        static let actionTintColor: UIColor = .artScopeBlue
    }
    
    // MARK: - Properties
    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()
    private let actionButton = UIButton(type: .system)
    private var isExpandable = false
    private var isExpanded = false
    private var currentBodyText: String?
    
    // MARK: - Lifecycle
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        refreshExpansionAvailability()
    }
    
    // MARK: - UI Setup
    private func configureUI() {
        addSubview(titleLabel)
        addSubview(bodyLabel)
        addSubview(actionButton)
        
        titleLabel.font = Constants.titleFont
        titleLabel.pinTop(to: topAnchor)
        titleLabel.pinHorizontal(to: self)
        
        bodyLabel.font = Constants.bodyFont
        bodyLabel.numberOfLines = Constants.bodyLinesCount
        bodyLabel.pinTop(to: titleLabel.bottomAnchor, Constants.titleBottomSpacing)
        bodyLabel.pinHorizontal(to: self)
        
        actionButton.titleLabel?.font = Constants.actionFont
        actionButton.tintColor = Constants.actionTintColor
        actionButton.contentHorizontalAlignment = .left
        actionButton.addTarget(self, action: #selector(toggleExpandedState), for: .touchUpInside)
        actionButton.pinTop(to: bodyLabel.bottomAnchor, Constants.buttonTopSpacing)
        actionButton.pinLeft(to: leadingAnchor)
        actionButton.pinRight(to: trailingAnchor)
        actionButton.pinBottom(to: bottomAnchor)
        actionButton.isHidden = true
    }
    
    // MARK: - Update
    func updateBody(_ text: String) {
        currentBodyText = text
        bodyLabel.text = text
        refreshExpansionAvailability()
    }
    
    func setExpandable(_ expandable: Bool) {
        isExpandable = expandable
        isExpanded = false
        refreshExpansionAvailability()
    }
    
    @objc private func toggleExpandedState() {
        guard isExpandable else { return }
        isExpanded.toggle()
        refreshExpansionAvailability()
        invalidateIntrinsicContentSize()
        superview?.layoutIfNeeded()
    }
    
    private func refreshExpansionAvailability() {
        guard isExpandable else {
            bodyLabel.numberOfLines = Constants.bodyLinesCount
            actionButton.isHidden = true
            return
        }
        
        let hasOverflow = bodyTextExceedsCollapsedLimit()
        actionButton.isHidden = !hasOverflow
        bodyLabel.numberOfLines = isExpanded || !hasOverflow
            ? Constants.bodyLinesCount
            : Constants.collapsedBodyLinesCount
        actionButton.setTitle(
            isExpanded ? Constants.actionTitleExpanded : Constants.actionTitleCollapsed,
            for: .normal
        )
    }
    
    private func bodyTextExceedsCollapsedLimit() -> Bool {
        guard let text = currentBodyText, !text.isEmpty else { return false }
        
        let labelWidth = bodyLabel.bounds.width > 0 ? bodyLabel.bounds.width : bounds.width
        guard labelWidth > 0 else { return false }
        
        let maxCollapsedHeight = Constants.bodyFont.lineHeight * CGFloat(Constants.collapsedBodyLinesCount)
        let constrainedSize = CGSize(width: labelWidth, height: .greatestFiniteMagnitude)
        let textBounds = (text as NSString).boundingRect(
            with: constrainedSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: Constants.bodyFont],
            context: nil
        )
        
        return ceil(textBounds.height) > ceil(maxCollapsedHeight)
    }
}
