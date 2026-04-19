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
        static let titleText: String = "Works"
        static let scrollTopSpacing: CGFloat = 12
        static let stackSpacing: CGFloat = 12
        static let titleFont: UIFont = UIFont(name: "InstrumentSans-Bold", size: 27) ?? .boldSystemFont(ofSize: 27)
    }
    
    // MARK: - Properties
    private let titleLabel = UILabel()
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    var onWorkSelected: ((ArtistWork) -> Void)?
    
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
        
        titleLabel.text = Constants.titleText
        titleLabel.font = Constants.titleFont
        titleLabel.pinTop(to: topAnchor)
        titleLabel.pinHorizontal(to: self)
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.pinTop(to: titleLabel.bottomAnchor, Constants.scrollTopSpacing)
        scrollView.pinHorizontal(to: self)
        scrollView.setHeight(Constants.itemSize.height)
        scrollView.pinBottom(to: bottomAnchor)
        
        scrollView.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.spacing = Constants.stackSpacing
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
            let cardView = ArtistWorkCardView(work: work)
            cardView.onTap = { [weak self] in
                self?.onWorkSelected?(work)
            }
            stackView.addArrangedSubview(cardView)
        }
    }
}

private final class ArtistWorkCardView: UIView {
    // MARK: - Constants
    private enum Constants {
        static let cardSize = CGSize(width: 148, height: 180)
        static let imageHeight: CGFloat = 104
        static let imageCornerRadius: CGFloat = 16
        static let titleTopSpacing: CGFloat = 8
        static let titleFont: UIFont = UIFont(name: "InstrumentSans-SemiBold", size: 18) ?? .systemFont(ofSize: 18)
        static let titleLinesCount: Int = 3
    }
    
    // MARK: - Properties
    private let work: ArtistWork
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    var onTap: (() -> Void)?
    
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
        
        addSubview(imageView)
        addSubview(titleLabel)
        
        imageView.backgroundColor = .white.withAlphaComponent(0.28)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.imageCornerRadius
        imageView.image = AppImages.defaultArtistPreview
        imageView.pinTop(to: topAnchor)
        imageView.pinHorizontal(to: self)
        imageView.setHeight(Constants.imageHeight)
        
        titleLabel.text = work.title
        titleLabel.font = Constants.titleFont
        titleLabel.numberOfLines = Constants.titleLinesCount
        titleLabel.pinTop(to: imageView.bottomAnchor, Constants.titleTopSpacing)
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
    
    // MARK: - Actions
    @objc private func handleTap() {
        onTap?()
    }
}
