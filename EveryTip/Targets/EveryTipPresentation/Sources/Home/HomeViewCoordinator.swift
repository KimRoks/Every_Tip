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

protocol HomeViewCoordinator: AuthenticationCoordinator {
    func start() -> UIViewController
    func pushToTipDetailView(with tipID: Int)
}

final class DefaultHomeViewCoordinator: HomeViewCoordinator {
   
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
        guard let useCase = container.resolve(TipUseCase.self) else {
            fatalError("의존성 주입이 옳바르지 않습니다!")
        }
        let reactor = HomeReactor(tipUseCase: useCase)
        let homeViewController = HomeViewController(reactor: reactor)
        
        homeViewController.coordinator = self
        
        return homeViewController
    }
    
    func didFinish() {
        parentCoordinator?.remove(child: self)
    }
    
    func pushToTipDetailView(with tipID: Int) {
        let tipDetailCoordinator = DefaultTipDetailCoordinator(
            tipId: tipID,
            navigationController: navigationController
        )
        tipDetailCoordinator.parentCoordinator = self
        append(child: tipDetailCoordinator)
        
        tipDetailCoordinator.start()
    }
}
