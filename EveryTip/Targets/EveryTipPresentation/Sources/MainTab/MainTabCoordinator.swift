//
//  MainTabCoordinator.swift
//  EveryTip
//
//  Created by 손대홍 on 1/21/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit
import SnapKit

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
        let mainTab = MainTabBarContoller()
        navigationController.setViewControllers([mainTab], animated: true)
    }
    
    func didFinish() {}
}
