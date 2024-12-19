//
//  AuthenticationCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 12/6/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import EveryTipCore

import RxSwift

protocol AuthenticationCoordinator: Coordinator {
    func checkLoginBeforePush(actionIfLoggedIn: @escaping () -> Void)
    func pushToLoginView()
    func presentLoginAlert()
}

extension AuthenticationCoordinator {
    /// 로그인 뷰로의 이동은 가급적 알럿을 통해 진행 할 것
    func checkLoginBeforePush(actionIfLoggedIn: @escaping () -> Void) {
        let isLoggedIn = TokenKeyChainManager.shared.isLogined
        
        if !isLoggedIn {
            presentLoginAlert()
        } else {
            actionIfLoggedIn()
        }
    }
    
    func pushToLoginView() {
        let loginCoordinator: LoginCoordinator = DefaultLoginCoordinator(navigationController: navigationController)
        
        loginCoordinator.start()
    }
    
    func presentLoginAlert() {
        let loginAlertController: UIAlertController = UIAlertController(
            title: "로그인이 필요한 서비스 입니다.",
            message: "로그인을 하러 이동할까요?",
            preferredStyle: .alert
        )
        
        let okAction: UIAlertAction = UIAlertAction(
            title: "예",
            style: .default
        ) { [weak self] _ in
            self?.pushToLoginView()
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(
            title: "아니요",
            style: .cancel
        )
        
        loginAlertController.addAction(okAction)
        loginAlertController.addAction(cancelAction)
        
        navigationController.present(
            loginAlertController,
            animated: true
        )
    }
}
