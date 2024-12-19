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
    func checkLoginBeforeAction(onLoggedIn: @escaping () -> Void)
    func pushToLoginView()
    // TODO: 고민해보고 분리해도 좋을듯
    func presentLoginAlert()
}

extension AuthenticationCoordinator {
    /// 로그인 뷰로의 이동은 가급적 알럿을 통해 진행 할 것
    func checkLoginBeforeAction(onLoggedIn: @escaping () -> Void) {
        let isLoggedIn = TokenKeyChainManager.shared.isLoggedIn
        
        if !isLoggedIn {
            presentLoginAlert()
        } else {
            onLoggedIn()
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
