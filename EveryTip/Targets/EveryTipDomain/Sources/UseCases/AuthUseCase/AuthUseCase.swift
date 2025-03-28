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
    func getAgreements() -> Single<Agreements>
}

public final class DefaultAuthUseCase: AuthUseCase {
    private let verificationCodeRepository: VerificationCodeRepository
    
    private let agreementsRepository: AgreementsRepository
    
    init(
        verificationCodeRepository: VerificationCodeRepository,
        agreementsRepository: AgreementsRepository
    ) {
        self.verificationCodeRepository = verificationCodeRepository
        self.agreementsRepository = agreementsRepository
    }
    
    public func requestEmailCode(email: String) -> Completable {
        verificationCodeRepository.requestCode(with: email)
    }
    
    public func checkEmailCode(code: String) -> Completable {
        verificationCodeRepository.checkCode(with: code)
    }
    
    public func getAgreements() -> RxSwift.Single<Agreements> {
        agreementsRepository.fetchAgreements()
    }
}
