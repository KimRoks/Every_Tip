//
//  UserUseCase.swift
//  EveryTipDomain
//
//  Created by 김경록 on 3/28/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import RxSwift

public protocol UserUseCase {
    func createRamdomNickName() -> Single<String>
    func configureTipCategory(categoryIds: [Int]) -> Completable
    func fetchMyProfile() -> Single<User>
    func fetchUserProfile(for userID: Int) -> Single<User>
}
