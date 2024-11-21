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

protocol UserContentsCoordinator: TokenCoordinator{ }

final class DefaultUserContentsCoordinator: UserContentsCoordinator {
    
    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    
    var isLogined: Bool = false
    
    var tokenManager: EveryTipCore.TokenKeyChainManager = TokenKeyChainManager.shared
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        checkToken(tokenManager)
        if isLogined == true {
            let userHistoryViewController = UserContentsViewController()
            userHistoryViewController.coordinator = self
            navigationController.pushViewController(userHistoryViewController, animated: true)
        } else {
            pushToLoginView()
        }
    }
    
    func refreshTokenDidExpire(error: any Error) {
        isLogined = false
    }
    
    func didFinish() {
        remove(child: self)
    }
}
