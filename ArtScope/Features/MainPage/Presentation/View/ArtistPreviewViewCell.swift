//
//  ArtistPreviewView.swift
//  ArtScope
//
//  Created by loxxy on 28.01.2026.
//

import UIKit

final class ArtistPreviewViewCell : UICollectionViewCell {
    // MARK: - Constants
    private enum Constants {
        // UI Constraint properties
        static let imageSize: CGFloat = 82
        
        // Strings
        static let reuseId: String = "ArtistPreviewViewCell"
        
        // Fonts
        static let font: UIFont? = UIFont(name: "InstrumentSans-Regular", size: 15)
    }
    
    // MARK: - Fields
    static let reuseId: String = Constants.reuseId
    
    private let nameLabel: UILabel = .init()
    private let imageView: UIImageView = .init()
    private var currentImageURL: URL?
    
    var onArtistTapped: (() -> Void)?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.bounds.width / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        currentImageURL = nil
        nameLabel.text = nil
        imageView.image = AppImages.defaultArtistPreview
    }
    
    func configure(with artist: ArtistPreview) {
        currentImageURL = artist.imageURL
        nameLabel.text = artist.name
        imageView.image = AppImages.defaultArtistPreview
        
        RemoteImageLoader.shared.loadImage(from: artist.imageURL) { [weak self] image in
            guard let self, self.currentImageURL == artist.imageURL else { return }
            
            DispatchQueue.main.async {
                self.imageView.image = image ?? AppImages.defaultArtistPreview
            }
        }
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        configureImageView()
        configureNameLabel()
    }
    
    private func configureImageView() {
        addSubview(imageView)
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill

        imageView.setWidth(Constants.imageSize)
        imageView.setHeight(Constants.imageSize)
        imageView.pinCenterX(to: self)
        imageView.pinTop(to: self.topAnchor)
    }
    
    private func configureNameLabel() {
        addSubview(nameLabel)
        
        nameLabel.font = Constants.font
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 3
        
        nameLabel.pinHorizontal(to: self)
        nameLabel.pinTop(to: imageView.bottomAnchor, 8)
    }
}
