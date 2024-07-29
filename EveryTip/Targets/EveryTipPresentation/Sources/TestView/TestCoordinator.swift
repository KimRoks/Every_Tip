//
//  TestCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/29/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//


import UIKit

protocol TestViewCoordinator: Coordinator {
    func start(with data: String)
}

final class DefaultTestViewCoordinator: TestViewCoordinator {
    
    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
    
    func start(with data: String) {
        let testView = TestView(text: data)
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
