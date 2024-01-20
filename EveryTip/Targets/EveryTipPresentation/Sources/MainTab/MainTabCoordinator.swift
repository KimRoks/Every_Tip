//
//  MainTabCoordinator.swift
//  EveryTip
//
//  Created by 손대홍 on 1/21/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

protocol MainTabCoordinator: Coordinator { }

final class DefaultMainTabCoordinator: MainTabCoordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        // TODO: MainTabBarController 추가
        let mainTab = UITabBarController(nibName: nil, bundle: nil)
        configureMainTabBarController(mainTab)
        navigationController.setViewControllers([mainTab], animated: true)
    }
    
    func didFinish() {}
    
    private func configureMainTabBarController(_ tabBarController: UITabBarController) {
        let firstViewController = BaseViewController()
        let secondViewController = UIViewController()
        
        firstViewController.view.backgroundColor = .red.withAlphaComponent(0.8)
        secondViewController.view.backgroundColor = .blue.withAlphaComponent(0.8)
        tabBarController.setViewControllers(
            [firstViewController, secondViewController],
            animated: true
        )
        
        tabBarController.tabBar.tintColor = .systemPink
        tabBarController.tabBar.backgroundColor = .systemGray3
        tabBarController.tabBar.items?[0].title = "first"
        tabBarController.tabBar.items?[1].title = "second"
    }
}
