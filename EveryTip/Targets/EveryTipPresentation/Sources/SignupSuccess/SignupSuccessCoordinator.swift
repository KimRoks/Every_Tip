//
//  SignupSuccessCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 4/28/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

protocol SignupSuccessCoordinator: Coordinator {
    func popToRootView()
}

final class DefaultSignupSuccessCoordinator: SignupSuccessCoordinator {
    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationContoller: UINavigationController) {
        self.navigationController = navigationContoller
    }
    
    func start() {
        let completedView = SignupSuccessViewController()
        completedView.coordinator = self
        
        navigationController.pushViewController(completedView, animated: true)
    }
    
    func didFinish() {
        parentCoordinator?.remove(child: self)
    }
    
    func popToRootView() {
        didFinish()
        navigationController.popToRootViewController(animated: true)
    }
}
