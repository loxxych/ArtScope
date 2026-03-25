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
        // Strings
        static let stylesSectionTitle: String = "Styles"
        
        // UI Constraint properties
        static let artistsTitleLeft: CGFloat = 20
    }
    
    // MARK: - Fields
    private var artistsSectionTitle: SectionTitleView = .init(title: Constants.stylesSectionTitle)
    private lazy var artistsPreviewCollectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: makeLayout())
    
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
        
        artistsPreviewCollectionView.showsHorizontalScrollIndicator = false
        artistsPreviewCollectionView.register(
            ArtistPreviewViewCell.self,
            forCellWithReuseIdentifier: ArtistPreviewViewCell.reuseId
        )
        
        addSubview(artistsPreviewCollectionView)
        
        artistsPreviewCollectionView.pinLeft(to: self.leadingAnchor, Constants.artistsTitleLeft)
        artistsPreviewCollectionView.pinTop(to: artistsSectionTitle.bottomAnchor, 10)
    }
    
    // MARK: - Make layout for collection view function
    private func makeLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 110, height: 160)
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: 20,
            bottom: 0,
            right: 20
        )
        return layout
    }
}

// MARK: - UICollectionViewDelegate
extension StylesSectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ArtistPreviewViewCell else { return }
    }
}

// MARK: - UICollectionViewDataSource
extension StylesSectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ArtistPreviewViewCell.reuseId,
            for: indexPath
        ) as! ArtistPreviewViewCell
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        10
    }
}

