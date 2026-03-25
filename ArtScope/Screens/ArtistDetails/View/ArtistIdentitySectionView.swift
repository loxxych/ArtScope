//
//  ArtistIdentitySectionView.swift
//  ArtScope
//
//  Created by loxxy on 25.03.2026.
//

import UIKit

final class ArtistIdentitySectionView: UIView {
    // MARK: - Properties
    private let nameLabel = UILabel()
    private let lifeSpanLabel = UILabel()
    private let stackView = UIStackView()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func configureUI() {
        addSubview(stackView)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 6
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(lifeSpanLabel)
        stackView.pinTop(to: topAnchor)
        stackView.pinLeft(to: leadingAnchor)
        stackView.pinRight(to: trailingAnchor)
        stackView.pinBottom(to: bottomAnchor)
        
        nameLabel.font = UIFont(name: "ByteBounce", size: 52) ?? .boldSystemFont(ofSize: 52)
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        
        lifeSpanLabel.font = UIFont(name: "InstrumentSans-Regular", size: 16) ?? .systemFont(ofSize: 16)
        lifeSpanLabel.textAlignment = .center
        lifeSpanLabel.numberOfLines = 0
    }
    
    // MARK: - Update
    func configure(name: String, lifeSpan: String) {
        nameLabel.text = name
        lifeSpanLabel.text = lifeSpan
    }
}
