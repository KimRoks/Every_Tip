//
//  UserTipCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/8/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDomain

import Swinject

protocol UserTipCoordinator: AuthenticationCoordinator {
    func start(reactor: UserTipReactor) -> UIViewController
    func pushToTipDetail(tipID: Int)
}

final class DefaultUserTipCoordinator: UserTipCoordinator {

    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
    
    func start(reactor: UserTipReactor) -> UIViewController {
        let tipListVC = UserTipViewCotroller(reactor: reactor)
        tipListVC.coordinator = self
        
        return tipListVC
    }
    
    func pushToTipDetail(tipID: Int) {
        let tipDetailCoordinator = DefaultTipDetailCoordinator(tipId: tipID, navigationController: navigationController)
        self.append(child: tipDetailCoordinator)
            
        tipDetailCoordinator.start()
    }
    
    func didFinish() {
        parentCoordinator?.remove(child: self)
    }
}
