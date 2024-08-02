//
//  FetchUserInfoUseCase.swift
//  EveryTipDomain
//
//  Created by 김경록 on 8/3/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

import RxSwift

public protocol FetchUserInfoUseCase {
    func fetchUserInfo() -> Single<User>
}
