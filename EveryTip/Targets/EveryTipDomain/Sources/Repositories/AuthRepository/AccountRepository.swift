//
//  AccountRepository.swift
//  EveryTipDomain
//
//  Created by 김경록 on 3/28/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import RxSwift

// TODO: 비밀번호 변경 api확정시 추가 예정
public protocol AccountRepository {
    func login(with email: String, password: String) -> Single<Account>
    func signUp(
        with email: String,
        pasword: String,
        agreementIDs: [Int],
        nickName: String
    ) -> Single<Account>
    func checkEmailDuplication(email: String) -> Completable
    func deleteAccount() -> Completable
    func requestTemporaryPassword(for email: String) -> Completable
}
