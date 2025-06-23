//
//  SearchCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/23/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

protocol SearchCoordinator: Coordinator {
    
}

final class DefaultSearchCoordinator: SearchCoordinator {
    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let searchView = SearchViewController()
        searchView.coordinator = self
        navigationController.pushViewController(searchView, animated: true)
    }
    
    func didFinish() {
        parentCoordinator?.remove(child: self)
    }
    
    
}
