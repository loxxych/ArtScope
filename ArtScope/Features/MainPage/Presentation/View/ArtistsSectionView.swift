//
//  ArtistsSectionView.swift
//  ArtScope
//
//  Created by loxxy on 31.01.2026.
//

import UIKit

final class ArtistsSectionView: UIView {
    // MARK: - Constants
    private enum Constants {
        // Strings
        static let artistsSectionTitle: String = "Artists"
        
        // UI Constraint properties
        static let artistsTitleLeft: CGFloat = 20
        static let collectionLeft: CGFloat = 8
        static let collectionTop: CGFloat = 10
        static let sectionInsetLeft: CGFloat = 8
        static let sectionInsetRight: CGFloat = 20
    }
    
    // MARK: - Fields
    private var artistsSectionTitle: SectionTitleView = .init(title: "Artists")
    private lazy var artistsPreviewCollectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: makeLayout())
    private var artists: [ArtistPreview] = []
    
    var onArtistSelected: ((ArtistPreview) -> Void)?
    var onShowAllArtistsTapped: (() -> Void)?
    
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
        artistsSectionTitle = SectionTitleView(title: Constants.artistsSectionTitle)
        artistsSectionTitle.onButtonPressed = { [weak self] in
            self?.onShowAllArtistsTapped?()
        }
        
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
            ArtistPreviewViewCell.self,
            forCellWithReuseIdentifier: ArtistPreviewViewCell.reuseId
        )
        
        addSubview(artistsPreviewCollectionView)
        
        artistsPreviewCollectionView.pinLeft(to: self.leadingAnchor, Constants.collectionLeft)
        artistsPreviewCollectionView.pinTop(to: artistsSectionTitle.bottomAnchor, Constants.collectionTop)
        artistsPreviewCollectionView.pinRight(to: self.trailingAnchor)
        artistsPreviewCollectionView.pinBottom(to: self.bottomAnchor)
    }
    
    func update(with artists: [ArtistPreview]) {
        self.artists = artists
        artistsPreviewCollectionView.reloadData()
    }
    
    // MARK: - Make layout for collection view function
    private func makeLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 110, height: 160)
        layout.minimumLineSpacing = 12
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
extension ArtistsSectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onArtistSelected?(artists[indexPath.item])
    }
}

// MARK: - UICollectionViewDataSource
extension ArtistsSectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ArtistPreviewViewCell.reuseId,
            for: indexPath
        ) as! ArtistPreviewViewCell
        
        cell.configure(with: artists[indexPath.item])
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        artists.count
    }
}
