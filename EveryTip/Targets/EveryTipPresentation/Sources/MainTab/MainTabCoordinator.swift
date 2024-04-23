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
        mainTabBarController = MainTabBarContoller()
        guard let mainTab = mainTabBarController else {
            return
        }
        mainTab.coordinator = self
        navigationController.setViewControllers(
            [mainTab],
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
