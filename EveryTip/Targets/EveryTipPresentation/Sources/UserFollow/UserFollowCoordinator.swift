//
//  UserFollowCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/2/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

protocol UserFollowCoordinator: Coordinator {
    func start(reactor: UserFollowReactor) -> UIViewController
    func pushToUserProfile(userID: Int)
}

final class DefaultUserFollowCoordinator: UserFollowCoordinator {

    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
    
    func start(reactor: UserFollowReactor) -> UIViewController {
        let userFollowVC = UserFollowViewController(reactor: reactor)
        userFollowVC.coordinator = self
        
        return userFollowVC
    }
    
    func pushToUserProfile(userID: Int) {
        let userProfileCoordinator = DefaultUserProfileCoordinator(navigationController: navigationController, userID: userID)
        self.append(child: userProfileCoordinator)
        userProfileCoordinator.parentCoordinator = self

        userProfileCoordinator.start()
    }
    
    func didFinish() {
        parentCoordinator?.remove(child: self)
    }
}
