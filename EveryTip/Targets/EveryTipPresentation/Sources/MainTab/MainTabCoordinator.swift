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
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    var mainTabBarController: MainTabBarContoller?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        // TODO: MainTabBarController 추가
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
        guard let mainTab = mainTabBarController else {
            return
        }
        let postCoordinator = DefaultPostTipViewCoordinator(
            navigationController: navigationController,
            presentingViewController: mainTab
        )
        postCoordinator.parentCoordinator = self
        childCoordinators.append(postCoordinator)
        postCoordinator.start()
    }
    
    func didFinish() {}
}
