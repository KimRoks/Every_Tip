//
//  EditPasswordCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/16/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

protocol EditPasswordCoordinator: Coordinator {

}

final class DefaultEditPasswordCoordinator: EditPasswordCoordinator {
    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let editPasswordVC = EditPasswordViewController()
        editPasswordVC.coordinator = self
        navigationController.pushViewController(editPasswordVC, animated: true)
    }
    
    func didFinish() {
        parentCoordinator?.remove(child: self)
    }
}
