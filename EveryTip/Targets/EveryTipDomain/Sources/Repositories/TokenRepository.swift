//
//  TokenRepository.swift
//  EveryTipDomain
//
//  Created by 김경록 on 10/28/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

import RxSwift

public protocol TokenRepository {
    func requestToken(email: String, password: String) -> Single<TokenResponse>
}
