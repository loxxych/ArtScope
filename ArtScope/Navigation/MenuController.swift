//
//  MenuController.swift
//  ArtScope
//
//  Created by loxxy on 22.01.2026.
//

import UIKit

final class MenuController : UITabBarController, MenuBarDelegate {
    // MARK: - Constants
    private enum Constants {
        // UI Constraint properties
        static let menuHorizontal: CGFloat = 20
        static let menuBottom: CGFloat = 20
        static let menuHeight: CGFloat = 64
    }
    
    // MARK: - Fields
    private let menuBarView = MenuBarView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewControllers()
        configureMenuBar()
    }
    
    // MARK: - Configuration
    private func configureViewControllers() {
        let mainVC = UINavigationController(rootViewController: MainPageViewController())
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        let quizzesVC = UINavigationController(rootViewController: QuizzesViewController())
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        
        viewControllers = [mainVC, searchVC, quizzesVC, profileVC]
    }
    
    private func configureMenuBar() {
        view.addSubview(menuBarView)
        
        menuBarView.delegate = self
        
        menuBarView.pinHorizontal(to: view, Constants.menuHorizontal)
        menuBarView.pinBottom(to: view, Constants.menuBottom)
        menuBarView.setHeight(Constants.menuHeight)
        
        tabBar.isHidden = true
    }
    
    // MARK: - Menu bar delegate
    func didSelectTab(index: Int) {
        selectedIndex = index
    }
}
