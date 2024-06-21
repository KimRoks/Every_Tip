//
//  MainTabCoordinator.swift
//  EveryTip
//
//  Created by 손대홍 on 1/21/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

protocol MainTabCoordinator: Coordinator {
    func presentPostView()
}

final class DefaultMainTabCoordinator: MainTabCoordinator {
    
    //MARK: Internal Properties
    
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    //MARK: Private Properties
    
    private var mainTabBarController: MainTabBarContoller?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    //MARK: Internal Methods
    
    func start() {
        let homeCoordinator = DefaultHomeViewCoordinator(navigationController: navigationController)
        homeCoordinator.parentCoordinator = self
        homeCoordinator.start()
        
        guard let homeViewController = homeCoordinator.homeViewController else {
            fatalError("Failed to get HomeViewController from HomeViewCoordinator")
        }
        
        // TODO: 각 ViewController, Coordinator 정의 및 start 메서드 실행
    
        let secondVC = UIViewController()
        
        let emptyVC = UIViewController()
        emptyVC.tabBarItem.isEnabled = false
        
        let thirdVC = UIViewController()
        
        let fourthVC = UIViewController()
        
        mainTabBarController = MainTabBarContoller()
        guard let mainTabBarController = mainTabBarController else {
            return
        }
        mainTabBarController.coordinator = self
        mainTabBarController.setViewControllers([
            homeViewController,
            secondVC,
            // Empty for middle button
            emptyVC,
            thirdVC,
            fourthVC
        ], animated: true)
        
        mainTabBarController.configureMainTabBarController()

        navigationController.setViewControllers(
            [mainTabBarController],
            animated: true
        )
    }
    
    func presentPostView() {
        guard let mainTabBarController = mainTabBarController else {
            return
        }
        let postCoordinator = DefaultPostTipViewCoordinator(
            navigationController: navigationController,
            presentingViewController: mainTabBarController
        )
        postCoordinator.parentCoordinator = self
        childCoordinators.append(postCoordinator)
        postCoordinator.start()
    }
    
    func didFinish() {}
}
