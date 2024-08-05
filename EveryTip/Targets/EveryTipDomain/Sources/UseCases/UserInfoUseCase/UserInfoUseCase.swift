//
//  UserInfoUseCase.swift
//  EveryTipDomain
//
//  Created by 김경록 on 8/3/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

import RxSwift

public protocol UserInfoUseCase: FetchUserInfoUseCase, GetInfoTableViewItemsUseCase{ }

final class DefaultUserInfoUseCase: UserInfoUseCase {
    
    private let userRepository: UserInfoRepository
    
    init(userRepository: UserInfoRepository) {
        self.userRepository = userRepository
    }
    
    public func fetchUserInfo() -> RxSwift.Single<User> {
        userRepository.fetchUserInfo()
    }
    
    func getInfoTableViewItems() -> [String] {
        return userRepository.getInfoTableViewItems()
    }
}
