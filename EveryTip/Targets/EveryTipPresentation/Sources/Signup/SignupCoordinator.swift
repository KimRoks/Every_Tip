//
//  SignupCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 4/7/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDomain

import Swinject

protocol SignupCoordinator: Coordinator {
    func pushToNicknameView()
}

final class DefaultSignupCoordinator: SignupCoordinator {
    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    private var signupData = SignupData()
    
    func start() {
        guard let authUseCase = Container.shared.resolve(AuthUseCase.self) else {
            fatalError("의존성 주입이 올바르지않습니다")
        }
        let reactor = SignUpReactor(authUseCase: authUseCase)
        let signupViewController = SignUpViewController(reactor: reactor)
        
        signupViewController.onConfirm = { [weak self] in
            guard let self = self else{ return }
            let state = reactor.currentState
            
            guard let email = state.textFieldText[.email],
                  let password = state.textFieldText[.confirmPassword]
            else {
                fatalError("이전 화면에서 엣지케이스를 통해 넘어옴")
            }
            
            signupData.email = email
            signupData.passwrod = password
        }
        signupViewController.coordinator = self
        navigationController.pushViewController(
            signupViewController,
            animated: true
        )
    }
    
    func didFinish() {
        parentCoordinator?.remove(child: self)
    }
    
    func pushToNicknameView() {
        let nicknameCoordinator = DefaultNicknameCoordinator(
            navigationController: navigationController,
            signupData: signupData
        )
        nicknameCoordinator.parentCoordinator = self
        self.append(child: nicknameCoordinator)
        nicknameCoordinator.start()
    }
}

struct SignupData {
    var email: String = ""
    var passwrod: String = ""
    var nickname: String = ""
    var agreemetns: [Int] = []
}
