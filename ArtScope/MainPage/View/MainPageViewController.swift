//
//  ViewController.swift
//  ArtScope
//
//  Created by loxxy on 22.01.2026.
//

import UIKit

final class MainPageViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        // Strings
        static let artistsSectionTitle: String = "Artists"
        
        // UI Constraint properties
        static let artistsTitleLeft: CGFloat = 20
        
        // Colors
        static let backgroundColor: UIColor = UIColor(named: "ArtScopeGreen") ?? .green
    }
    
    // MARK: - Fields
    private var artistsSectionTitle: SectionTitleView?
    
    // MARK: - Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - UI Configuration
    private func configureUI() {
        view.backgroundColor = Constants.backgroundColor
        
        configureArtistsSection()
    }

    // MARK: - Artist section configuration
    private func configureArtistsSection() {
        artistsSectionTitle = SectionTitleView(title: Constants.artistsSectionTitle)
        
        guard let artistsSectionTitle else { return }
        
        view.addSubview(artistsSectionTitle)
        
        artistsSectionTitle.pinLeft(to: view.leadingAnchor, Constants.artistsTitleLeft)
        artistsSectionTitle.pinCenterY(to: view)
    }
}

