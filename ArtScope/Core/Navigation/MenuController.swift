//
//  MenuController.swift
//  ArtScope
//
//  Created by loxxy on 22.01.2026.
//

import UIKit

final class MenuController : UITabBarController, MenuBarControllable {
    // MARK: - Constants
    private enum Constants {
        // UI Constraint properties
        static let menuHorizontal: CGFloat = 20
        static let menuBottom: CGFloat = 20
        static let menuHeight: CGFloat = 64
        static let visible: CGFloat = 1
        static let invisible: CGFloat = 0
        static let animationDuration: TimeInterval = 0.25

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
    
    // MARK: - Utility functions
    func setMenuBarHidden(_ hidden: Bool, animated: Bool) {
        let animations = {
            self.menuBarView.alpha = hidden ? Constants.invisible : Constants.visible
        }
        
        if animated {
            UIView.animate(withDuration: Constants.animationDuration, animations: animations)
        } else {
            animations()
        }
        
        menuBarView.isUserInteractionEnabled = !hidden
    }
}

// MARK: - Menu bar delegate
extension MenuController: MenuBarDelegate {
    func didSelectTab(index: Int) {
        selectedIndex = index
    }
}

