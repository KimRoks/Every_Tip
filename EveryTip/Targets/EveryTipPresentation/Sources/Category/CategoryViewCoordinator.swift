//
//  CategoryViewCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/4/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDomain

import Swinject

protocol CategoryViewCoordinator: Coordinator {
    func start() -> UIViewController
    func pushToCategorizedTip(with categoryID: Int)
}

final class DefaultCategoryViewCoordinator: CategoryViewCoordinator {
   
    //MARK: Internal Properties

    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    //MARK: Private Properties

    private let container = Container.shared

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    //MARK: Internal Methods

    func start() { }

    func start() -> UIViewController {
        let categoryViewContoller = CategoryViewController()
        categoryViewContoller.coordinator = self
        
        return categoryViewContoller
    }

    func didFinish() {
        parentCoordinator?.remove(child: self)
    }
    
    func pushToCategorizedTip(with categoryID: Int) {
        let selectedCoordinator = DefaultCategorizedTipCoordinator(
            navigationController: navigationController,
            categoryID: categoryID
        )
        self.append(child: selectedCoordinator)
        
        selectedCoordinator.start()
    }
}
