//
//  TabBarController.swift
//  MarvelAPI
//
//  Created by Victor Luni on 27/02/24.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeViewController = HomeTableViewController()
        let favoritesViewController = FavoritesTableViewController()

        homeViewController.title = "Home"
        favoritesViewController.title = "Favorites"

        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        favoritesViewController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"), tag: 1)

        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        let favoritesNavigationController = UINavigationController(rootViewController: favoritesViewController)
        tabBar.tintColor = .darkGray
        tabBar.backgroundColor = .lightGray
        
        viewControllers = [homeNavigationController, favoritesNavigationController]
    }
}
