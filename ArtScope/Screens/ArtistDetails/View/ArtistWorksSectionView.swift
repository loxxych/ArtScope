//
//  ArtistWorksSectionView.swift
//  ArtScope
//
//  Created by loxxy on 25.03.2026.
//

import UIKit

final class ArtistWorksSectionView: UIView {
    // MARK: - Constants
    private enum Constants {
        static let itemSize = CGSize(width: 148, height: 180)
    }
    
    // MARK: - Properties
    private let titleLabel = UILabel()
    private let scrollView = UIScrollView()
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
        addSubview(titleLabel)
        addSubview(scrollView)
        
        titleLabel.text = "Works"
        titleLabel.font = UIFont(name: "InstrumentSans-Bold", size: 27) ?? .boldSystemFont(ofSize: 27)
        titleLabel.pinTop(to: topAnchor)
        titleLabel.pinHorizontal(to: self)
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.pinTop(to: titleLabel.bottomAnchor, 12)
        scrollView.pinHorizontal(to: self)
        scrollView.setHeight(Constants.itemSize.height)
        scrollView.pinBottom(to: bottomAnchor)
        
        scrollView.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.pinTop(to: scrollView.contentLayoutGuide.topAnchor)
        stackView.pinLeft(to: scrollView.contentLayoutGuide.leadingAnchor)
        stackView.pinRight(to: scrollView.contentLayoutGuide.trailingAnchor)
        stackView.pinBottom(to: scrollView.contentLayoutGuide.bottomAnchor)
        stackView.pinHeight(to: scrollView.frameLayoutGuide.heightAnchor)
    }
    
    // MARK: - Update
    func update(with works: [ArtistWork]) {
        stackView.arrangedSubviews.forEach { view in
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        works.forEach { work in
            stackView.addArrangedSubview(ArtistWorkCardView(work: work))
        }
    }
}

private final class ArtistWorkCardView: UIView {
    // MARK: - Constants
    private enum Constants {
        static let cardSize = CGSize(width: 148, height: 180)
    }
    
    // MARK: - Properties
    private let work: ArtistWork
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    // MARK: - Lifecycle
    init(work: ArtistWork) {
        self.work = work
        super.init(frame: .zero)
        configureUI()
        loadImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func configureUI() {
        setWidth(Constants.cardSize.width)
        
        addSubview(imageView)
        addSubview(titleLabel)
        
        imageView.backgroundColor = .white.withAlphaComponent(0.28)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.image = AppImages.defaultArtistPreview
        imageView.pinTop(to: topAnchor)
        imageView.pinHorizontal(to: self)
        imageView.setHeight(104)
        
        titleLabel.text = work.title
        titleLabel.font = UIFont(name: "InstrumentSans-Regular", size: 14) ?? .systemFont(ofSize: 14)
        titleLabel.numberOfLines = 3
        titleLabel.pinTop(to: imageView.bottomAnchor, 8)
        titleLabel.pinHorizontal(to: self)
        titleLabel.pinBottom(to: bottomAnchor)
    }
    
    // MARK: - Data
    private func loadImage() {
        RemoteImageLoader.shared.loadImage(from: work.imageURL) { [weak self] image in
            DispatchQueue.main.async {
                self?.imageView.image = image ?? AppImages.defaultArtistPreview
            }
        }
    }
}
