//
//  HomeViewCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/11/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import EveryTipDomain

import UIKit

import Swinject

protocol HomeViewCoordinator: Coordinator { }

final class DefaultHomeViewCoordinator: HomeViewCoordinator {
    
    //MARK: Internal Properties
    
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    //MARK: Private Properties
    
    private var homeViewController: HomeViewController?
    private let container = Container.shared
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    //MARK: Internal Methods

    func start() {
        guard let useCase = container.resolve(PostListUseCase.self) else {
            print("의존성 주입이 옳바르지 않습니다!")
            fatalError()
        }
        
        let viewModel = HomeViewModel(postUseCase: useCase)
        homeViewController = HomeViewController(viewModel: viewModel)
        homeViewController?.coordinator = self
        if let homeViewController = homeViewController {
            navigationController.viewControllers = [homeViewController]
        }
    }
    
    func didFinish() {
        parentCoordinator?.remove(child: self)
    }
}
