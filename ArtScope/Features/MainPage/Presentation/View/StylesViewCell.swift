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
        static let reuseId: String = "StylesViewCell"
        static let imageHeight: CGFloat = 156
        static let imageCornerRadius: CGFloat = 24
        static let titleTopSpacing: CGFloat = 10
        static let titleFont: UIFont = .InstrumentSansRegular15
        static let titleLinesCount: Int = 2
    }
    
    // MARK: - Fields
    static let reuseId: String = Constants.reuseId
    
    private let nameLabel: UILabel = .init()
    private let imageView: UIImageView = .init()
    private var currentImageURL: URL?
    
    var onStyleTapped: (() -> Void)?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        currentImageURL = nil
        nameLabel.text = nil
        imageView.image = UIImage.artScopeDefaultArtistPreview
    }
    
    func configure(with style: StylePreview) {
        currentImageURL = style.imageURL
        nameLabel.text = style.name
        imageView.image = UIImage.artScopeDefaultArtistPreview
        
        RemoteImageLoader.shared.loadImage(from: style.imageURL) { [weak self] image in
            guard let self, self.currentImageURL == style.imageURL else { return }
            
            DispatchQueue.main.async {
                self.imageView.image = image ?? UIImage.artScopeDefaultArtistPreview
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
        
        imageView.layer.cornerRadius = Constants.imageCornerRadius
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        imageView.setHeight(Constants.imageHeight)
        imageView.pinHorizontal(to: self)
        imageView.pinTop(to: self.topAnchor)
    }
    
    private func configureNameLabel() {
        addSubview(nameLabel)
        
        nameLabel.font = Constants.titleFont
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = Constants.titleLinesCount
        
        nameLabel.pinHorizontal(to: self)
        nameLabel.pinTop(to: imageView.bottomAnchor, Constants.titleTopSpacing)
        nameLabel.pinBottom(to: self.bottomAnchor)
    }
}
