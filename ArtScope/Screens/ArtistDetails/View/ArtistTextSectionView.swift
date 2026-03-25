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
        static let titleFont: UIFont = UIFont(name: "InstrumentSans-Bold", size: 27) ?? .boldSystemFont(ofSize: 27)
        static let bodyFont: UIFont = UIFont(name: "InstrumentSans-Regular", size: 15) ?? .systemFont(ofSize: 15)
        static let bodyLinesCount: Int = 0
    }
    
    // MARK: - Properties
    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()
    
    // MARK: - Lifecycle
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func configureUI() {
        addSubview(titleLabel)
        addSubview(bodyLabel)
        
        titleLabel.font = Constants.titleFont
        titleLabel.pinTop(to: topAnchor)
        titleLabel.pinHorizontal(to: self)
        
        bodyLabel.font = Constants.bodyFont
        bodyLabel.numberOfLines = Constants.bodyLinesCount
        bodyLabel.pinTop(to: titleLabel.bottomAnchor, Constants.titleBottomSpacing)
        bodyLabel.pinHorizontal(to: self)
        bodyLabel.pinBottom(to: bottomAnchor)
    }
    
    // MARK: - Update
    func updateBody(_ text: String) {
        bodyLabel.text = text
    }
}
