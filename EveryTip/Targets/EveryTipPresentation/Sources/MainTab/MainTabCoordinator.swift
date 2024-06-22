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
    
    private let mainTabBarController = MainTabBarContoller()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    //MARK: Internal Methods
    
    func start() {
        // TODO: 각 ViewController, Coordinator 정의 및 start 메서드 실행
        let homeNavigationController = UINavigationController()
        let secondVC = UINavigationController()
        let emptyVC = UIViewController()
        emptyVC.tabBarItem.isEnabled = false
        let thirdVC = UINavigationController()
        let fourthVC = UINavigationController()
        
        let homeCoordinator = DefaultHomeViewCoordinator(navigationController: homeNavigationController)
        homeCoordinator.parentCoordinator = self
        append(child: homeCoordinator)
        
        homeCoordinator.start()
        
        mainTabBarController.viewControllers = [
            homeNavigationController,
            secondVC,
            emptyVC,
            thirdVC,
            fourthVC
        ]
        
        mainTabBarController.configureMainTabBarController()
        mainTabBarController.coordinator = self

        navigationController.setViewControllers(
            [mainTabBarController],
            animated: true
        )
    }
    
    func presentPostView() {
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
