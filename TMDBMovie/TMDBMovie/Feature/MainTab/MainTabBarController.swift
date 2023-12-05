//
//  MainTabBarController.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 19/10/23.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewController()
    }
    
    override func loadView() {
        super.loadView()
    }
    
    func setupView() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .lightGray
    }
    
    func setupViewController() {
        let homeVC = HomeViewRouter.assembleModule()
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        homeVC.title = "Home"


        let searchVC = SearchRouter.assembleModule()
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        searchVC.title = "Search"
        let searchNavVC = UINavigationController(rootViewController: searchVC)

        
        let watchlistVC = WatchlistRouter.assembleModule()
        watchlistVC.tabBarItem.image = UIImage(systemName: "square.and.arrow.down.on.square")
        watchlistVC.title = "Watchlist"
        let watchlistNavVC = UINavigationController(rootViewController: watchlistVC)


        setViewControllers([homeVC, searchNavVC, watchlistNavVC], animated: true)
    }

}
