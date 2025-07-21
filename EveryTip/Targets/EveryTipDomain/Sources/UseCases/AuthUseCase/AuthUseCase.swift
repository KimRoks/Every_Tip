//
//  AuthUseCase.swift
//  EveryTipDomain
//
//  Created by 김경록 on 2/20/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import RxSwift

import Foundation

public protocol AuthUseCase {
    func requestEmailCode(email: String) -> Completable
    func checkEmailCode(code: String) -> Completable
    func getAgreements() -> Single<[Agreements]>
    func login(email: String, password: String) -> Single<Account>
    func signUp(
        email: String,
        password: String,
        agreementsIDs: [Int],
        nickName: String
    ) -> Single<Account>
    func checkEmailDuplication(for email: String) -> Completable
    func deleteAccount() -> Completable
    func requestTemporaryPassword(for email: String) -> Completable
}

public final class DefaultAuthUseCase: AuthUseCase {
    private let verificationCodeRepository: VerificationCodeRepository
    private let agreementsRepository: AgreementsRepository
    private let accountRepository: AccountRepository
    
    init(
        verificationCodeRepository: VerificationCodeRepository,
        agreementsRepository: AgreementsRepository,
        accountRepository: AccountRepository
    ) {
        self.verificationCodeRepository = verificationCodeRepository
        self.agreementsRepository = agreementsRepository
        self.accountRepository = accountRepository
    }
    
    public func requestEmailCode(email: String) -> Completable {
        verificationCodeRepository.requestCode(with: email)
    }
    
    public func checkEmailCode(code: String) -> Completable {
        verificationCodeRepository.checkCode(with: code)
    }
    
    public func getAgreements() -> Single<[Agreements]> {
        agreementsRepository.fetchAgreements()
    }
    
    public func login(email: String, password: String) -> Single<Account> {
        accountRepository.login(with: email, password: password)
    }
    
    public func signUp(
        email: String,
        password: String,
        agreementsIDs agreementsIds: [Int],
        nickName: String
    ) -> Single<Account> {
        accountRepository.signUp(
            with: email,
            pasword: password,
            agreementIDs: agreementsIds,
            nickName: nickName
        )
    }
    
    public func checkEmailDuplication(for email: String) -> Completable {
        accountRepository.checkEmailDuplication(email: email)
    }
    
    public func deleteAccount() -> Completable {
        accountRepository.deleteAccount()
    }
    
    public func requestTemporaryPassword(for email: String) -> Completable {
        accountRepository.requestTemporaryPassword(for: email)
    }
}
