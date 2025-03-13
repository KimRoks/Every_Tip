//
//  VerificationCodeRepository.swift
//  EveryTipDomain
//
//  Created by 김경록 on 3/12/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import RxSwift

public protocol VerificationCodeRepository {
    func requestCode(with email: String) -> Completable
    func checkCode(with code: String) -> Completable
}
