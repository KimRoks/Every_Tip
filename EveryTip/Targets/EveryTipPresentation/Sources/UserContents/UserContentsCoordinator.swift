//
//  UserHistoryCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 11/18/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDomain
import EveryTipCore

import Swinject
import RxSwift

protocol UserContentsCoordinator: AuthenticationCoordinator {
}

final class DefaultUserContentsCoordinator: UserContentsCoordinator {
    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    
    private let myID: Int
    
    init(
        myID: Int,
        navigationController: UINavigationController) {
            self.myID = myID
        self.navigationController = navigationController
    }
        
    func start() {
        guard let tipUseCase = Container.shared.resolve(TipUseCase.self),
              let userUseCase = Container.shared.resolve(UserUseCase.self) else {
            fatalError("의존성 주입이 옳바르지 않습니다!")
        }
        
        let followerReactor = UserFollowReactor(userUseCase: userUseCase, followType: .followers)
        let followerCoordinator = DefaultUserFollowCoordinator(navigationController: navigationController)
        
        let followingReactor = UserFollowReactor(userUseCase: userUseCase, followType: .following)
        let followingCoordinator = DefaultUserFollowCoordinator(navigationController: navigationController)
        
        let savedTipReactor = SavedTipReactor(tipUseCase: tipUseCase)
        let myTipReactor = MyTipReactor(
            myID: myID,
            tipUseCase: tipUseCase
        )
        
        let userContentsViewController: UserContentsViewController = UserContentsViewController(
            viewControllers: [
                followerCoordinator.start(reactor: followerReactor),
                followingCoordinator.start(reactor: followingReactor),
                MyTipViewController(reactor: myTipReactor),
                SavedTipViewController(reactor: savedTipReactor)
            ]
        )
        userContentsViewController.coordinator = self
        self.append(child: followerCoordinator)
        self.append(child: followingCoordinator)
        
        navigationController.pushViewController(
            userContentsViewController,
            animated: true
        )
    }
    
    func didFinish() {
        parentCoordinator?.remove(child: self)
    }
}
