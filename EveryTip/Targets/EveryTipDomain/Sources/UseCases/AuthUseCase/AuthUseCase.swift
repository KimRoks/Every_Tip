//
//  AuthUseCase.swift
//  EveryTipDomain
//
//  Created by 김경록 on 2/20/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import RxSwift

import Foundation

// TODO: 각 Auth관련 UseCase 통합

public protocol AuthUseCase {
    func requestEmailCode(email: String) -> Completable
    func checkEmailCode(code: String) -> Completable
}

public final class DefaultAuthUseCase: AuthUseCase {
    
    private let verificationCodeRepository: VerificationCodeRepository
    
    init(
        verificationCodeRepository: VerificationCodeRepository
    ) {
        self.verificationCodeRepository = verificationCodeRepository
    }
    
    public func requestEmailCode(email: String) -> Completable {
        verificationCodeRepository.requestCode(with: email)
    }
    
    public func checkEmailCode(code: String) -> Completable {
        verificationCodeRepository.checkCode(with: code)
    }
}
