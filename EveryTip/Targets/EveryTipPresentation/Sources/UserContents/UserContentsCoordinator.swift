//
//  UserHistoryCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 11/18/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDomain
import EveryTipCore

protocol UserContentsCoordinator: Coordinator {
    func pushToLoginView()
}

final class DefaultUserContentsCoordinator: UserContentsCoordinator {
    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    let keychainManager: TokenKeyChainManager = TokenKeyChainManager.shared
    let userContentsViewController: UserContentsViewController = UserContentsViewController()
    
    func start() {
        if keychainManager.isLogined {
            userContentsViewController.coordinator = self
            navigationController.pushViewController(
                userContentsViewController,
                animated: true
            )
        } else {
            userContentsViewController.coordinator = self
            navigationController.pushViewController(
                userContentsViewController,
                animated: true
            )
//            pushToLoginView()
        }
    }
    
    func didFinish() {
        remove(child: self)
    }
    
    func pushToLoginView() {
        let loginCoordinator: LoginCoordinator = DefaultLoginCoordinator(navigationController: navigationController)
        loginCoordinator.start()
    }
}
