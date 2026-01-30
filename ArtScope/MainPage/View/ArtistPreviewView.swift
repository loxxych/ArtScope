//
//  ArtistPreviewView.swift
//  ArtScope
//
//  Created by loxxy on 28.01.2026.
//

import UIKit

final class ArtistPreviewView : UIView {
    // MARK: - Constants
    private enum Constants {
        // UI Constraint properties
        
        // Strings
        
        // Fonts
        static let font: UIFont? = UIFont(name: "InstrumentSans-Regular", size: 15)
    }
    
    // MARK: - Fields
    private let nameLabel: UILabel = .init()
    private let imageView: UIImageView = .init()
    
    var onArtistTapped: (() -> Void)?
    
    // MARK: - Lifecycle
    init(name: String, image: UIImage) {
        super.init(frame: .zero)
        
        nameLabel.text = name
        imageView.image = image
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

