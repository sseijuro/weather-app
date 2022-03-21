//
//  TabBarController.swift
//  weather-app
//
//  Created by U19809810 on 21.03.2022.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .systemOrange
        viewControllers = [
            setupConcretteModule(for: HomeViewController(), withTag: "Home", withIconTag: "house"),
            setupConcretteModule(for: UIViewController(), withTag: "Weather", withIconTag: "smoke"),
            setupConcretteModule(for: UIViewController(), withTag: "About", withIconTag: "info.circle")
        ]
    }
    
    private func setupConcretteModule(
        for rootViewController: UIViewController,
        withTag tag: String,
        withIconTag iconTag: String
    ) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = NSLocalizedString(tag, comment: "")
        navController.tabBarItem.image = UIImage(systemName: iconTag)
        rootViewController.navigationItem.title = tag
        return navController
    }
    
}
