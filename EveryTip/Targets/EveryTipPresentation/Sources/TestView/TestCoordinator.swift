//
//  TestCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/29/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//


import UIKit

import EveryTipDomain

protocol TestViewCoordinator: Coordinator {
    func start(with tip: Tip)
}

final class DefaultTestViewCoordinator: TestViewCoordinator {
    
    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
    
    func start(with tip: Tip) {
        let testView = TestView(tip: tip)
        testView.coordinator = self
        navigationController
            .pushViewController(
            testView,
            animated: true
        )
    }
    
    func didFinish() {
        parentCoordinator?.remove(child: self)
    }
}
