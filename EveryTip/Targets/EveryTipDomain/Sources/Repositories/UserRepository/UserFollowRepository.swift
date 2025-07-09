//
//  UserFollowRepository.swift
//  EveryTipDomain
//
//  Created by 김경록 on 7/2/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import RxSwift

public protocol UserFollowRepository {
    func fetchMyFollowers() -> Single<[UserPreview]>
    func fetchMyFollowing() -> Single<[UserPreview]>
}
