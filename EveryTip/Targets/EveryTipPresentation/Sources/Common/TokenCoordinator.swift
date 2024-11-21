//
//  TokenCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 11/19/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

import EveryTipCore
import EveryTipDomain

public protocol TokenCoordinator: Coordinator, TokenSessionDelegate {
    var isLogined: Bool { get set }
    var tokenManager: TokenKeyChainManager { get }
    func checkToken(_ tokenManager: TokenKeyChainManager)
    func pushToLoginView()
}

public extension TokenCoordinator {
    func checkToken(_ tokenManager: EveryTipCore.TokenKeyChainManager) {
        if let _ = tokenManager.getToken(type: .access) {
            isLogined = true
        } else {
            return
        }
    }
    
    // TODO: 기획시 로그인화면으로 이동시 알럿 등으로 표시할건지, 이동 방식의 정립 필요(push || present)
    func pushToLoginView() {
        let loginCoordinator: LoginCoordinator = DefaultLoginCoordinator(navigationController: navigationController)
        loginCoordinator.start()
    }
}
