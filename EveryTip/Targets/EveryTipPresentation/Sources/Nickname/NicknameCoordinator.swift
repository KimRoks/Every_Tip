//
//  NicknameCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 4/20/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDomain

import Swinject

protocol NicknameCoordinator: Coordinator {

}

final class DefaultNicknameCoordinator: NicknameCoordinator {
    
    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [any Coordinator] = []
     
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let userUseCase = Container.shared.resolve(UserUseCase.self) else {
            fatalError("의존성 주입이 옳바르지 않습니다!")
        }
        
        let nicknameReactor = NicknameReactor(userUseCase: userUseCase)
        let nicknameViewController = NicknameViewController(reactor: nicknameReactor)
        nicknameViewController.coordinator = self
        
        navigationController.pushViewController(
            nicknameViewController,
            animated: true
        )
    }
    
    func didFinish() {
        parentCoordinator?.remove(child: self)
    }
}
