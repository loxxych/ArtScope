//
//  StylesSectionViewCell.swift
//  ArtScope
//
//  Created by loxxy on 31.01.2026.
//

import UIKit

final class StylesViewCell : UICollectionViewCell {
    // MARK: - Constants
    private enum Constants {
        // UI Constraint properties
        
        // Strings
        static let reuseId: String = "ArtistPreviewViewCell"
        
        // Fonts
        static let font: UIFont? = UIFont(name: "InstrumentSans-Regular", size: 15)
    }
    
    // MARK: - Fields
    static let reuseId: String = Constants.reuseId
    
    private let nameLabel: UILabel = .init()
    private let imageView: UIImageView = .init()
    
    var onStyleTapped: (() -> Void)?
    
    // MARK: - Lifecycle
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(artistName: String, artistPicture: UIImage) {
        nameLabel.text = artistName
        imageView.image = artistPicture
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        configureImageView()
        configureNameLabel()
    }
    
    private func configureImageView() {
        addSubview(imageView)
        
        imageView.layer.cornerRadius = 41

        imageView.setWidth(82)
        imageView.setHeight(82)
        imageView.pinHorizontal(to: self)
        imageView.pinTop(to: self.topAnchor)
    }
    
    private func configureNameLabel() {
        addSubview(nameLabel)
        
        nameLabel.font = Constants.font
        nameLabel.textAlignment = .center
        
        nameLabel.pinHorizontal(to: self)
        nameLabel.pinTop(to: imageView.bottomAnchor, 8)
    }
}

