//
//  ViewControllerExtension.swift
//  ArtScope
//
//  Created by loxxy on 29.01.2026.
//

import UIKit

// Extension for correct menu bar management (hiding/showing)
extension UIViewController {
    var menuController: MenuBarControllable? {
        tabBarController as? MenuBarControllable
    }
}
