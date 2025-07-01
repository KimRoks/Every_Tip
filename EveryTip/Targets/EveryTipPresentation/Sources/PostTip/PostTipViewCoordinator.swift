//
//  PostTipViewCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 4/7/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import EveryTipDomain

import UIKit

import Swinject

protocol PostTipViewCoordinator: Coordinator { }

final class DefaultPostTipViewCoordinator: PostTipViewCoordinator {
    
    //MARK: Internal Properties
    
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    //MARK: Private Properties
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    //MARK: Internal Methods
    
    func start() {
        guard let tipUseCase = Container.shared.resolve(TipUseCase.self) else {
            fatalError("의존성 주입이 잘못됐습니다!")
        }
        let reactor = PostTipReactor(tipUseCase: tipUseCase)
        let postTipViewController = PostTipViewController(reactor: reactor)
        postTipViewController.coordinator = self
        
        let navi = UINavigationController(rootViewController: postTipViewController)
        navi.modalPresentationStyle = .fullScreen
        navigationController.present(navi, animated: true)
    }
    
    func didFinish() {
        navigationController.dismiss(
            animated: true,
            completion: removeSelfFromParentCoordinator
        )
    }
    
    //MARK: Private Methods
    
    private func removeSelfFromParentCoordinator() {
        parentCoordinator?.remove(child: self)
    }
}
