//
//  TokenUseCase.swift
//  EveryTipDomain
//
//  Created by 김경록 on 10/28/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

import RxSwift

public protocol RequestTokenUseCase {
    func excute(email: String, password: String) -> Single<TokenResponse>
}

final public class DefaultRequestTokenUseCase: RequestTokenUseCase {
    private let tokenRepository: UserLoginRepository
    
    init(tokenRepository: UserLoginRepository) {
        self.tokenRepository = tokenRepository
    }
    
    public func excute(email: String, password: String) -> Single<TokenResponse> {
            return tokenRepository.requestToken(email: email, password: password)
    }
}
