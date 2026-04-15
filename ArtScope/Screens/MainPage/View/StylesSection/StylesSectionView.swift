//
//  StylesSectionView.swift
//  ArtScope
//
//  Created by loxxy on 31.01.2026.
//

import UIKit

final class StylesSectionView: UIView {
    // MARK: - Constants
    private enum Constants {
        static let stylesSectionTitle: String = "Styles"
        static let artistsTitleLeft: CGFloat = 20
        static let collectionLeft: CGFloat = 8
        static let collectionTop: CGFloat = 10
        static let sectionInsetLeft: CGFloat = 12
        static let sectionInsetRight: CGFloat = 20
        static let itemSize = CGSize(width: 170, height: 210)
        static let minimumLineSpacing: CGFloat = 16
    }
    
    // MARK: - Fields
    private var artistsSectionTitle: SectionTitleView = .init(title: Constants.stylesSectionTitle)
    private lazy var artistsPreviewCollectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: makeLayout())
    private var styles: [StylePreview] = []
    var onStyleSelected: ((StylePreview) -> Void)?
    
    // MARK: - Lifecycle
    init() {
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI configuration
    private func configureUI() {
        configureArtistsSectionTitle()
        configureArtistsCollectionView()
    }
    
    // MARK: - Artist section title configuration
    private func configureArtistsSectionTitle() {
        addSubview(artistsSectionTitle)
        
        artistsSectionTitle.pinLeft(to: self.leadingAnchor, Constants.artistsTitleLeft)
        artistsSectionTitle.pinTop(to: self.topAnchor)
    }
    
    // MARK: - Collection view configuration
    private func configureArtistsCollectionView() {
        artistsPreviewCollectionView.delegate = self
        artistsPreviewCollectionView.dataSource = self
        artistsPreviewCollectionView.backgroundColor = .clear
        
        artistsPreviewCollectionView.showsHorizontalScrollIndicator = false
        artistsPreviewCollectionView.register(
            StylesViewCell.self,
            forCellWithReuseIdentifier: StylesViewCell.reuseId
        )
        
        addSubview(artistsPreviewCollectionView)
        
        artistsPreviewCollectionView.pinLeft(to: self.leadingAnchor, Constants.collectionLeft)
        artistsPreviewCollectionView.pinTop(to: artistsSectionTitle.bottomAnchor, Constants.collectionTop)
        artistsPreviewCollectionView.pinRight(to: self.trailingAnchor)
        artistsPreviewCollectionView.pinBottom(to: self.bottomAnchor)
    }
    
    func update(with styles: [StylePreview]) {
        self.styles = styles
        artistsPreviewCollectionView.reloadData()
    }
    
    // MARK: - Make layout for collection view function
    private func makeLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = Constants.itemSize
        layout.minimumLineSpacing = Constants.minimumLineSpacing
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: Constants.sectionInsetLeft,
            bottom: 0,
            right: Constants.sectionInsetRight
        )
        return layout
    }
}

// MARK: - UICollectionViewDelegate
extension StylesSectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard styles.indices.contains(indexPath.item) else { return }
        onStyleSelected?(styles[indexPath.item])
    }
}

// MARK: - UICollectionViewDataSource
extension StylesSectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StylesViewCell.reuseId,
            for: indexPath
        ) as! StylesViewCell
        
        cell.configure(with: styles[indexPath.item])
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        styles.count
    }
}
