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

final class DefaultUserUseCase: UserUseCase {
    private let nickNameRepository: NickNameRepository
    private let categoryRepository: CategoryRepository
    private let profileRepository: ProfileRepository
    
    init(
        profileRepository: ProfileRepository,
        nickNameRepository: NickNameRepository,
        categoryRepository: CategoryRepository
    ) {
        self.profileRepository = profileRepository
        self.nickNameRepository = nickNameRepository
        self.categoryRepository = categoryRepository
    }
    
    public func createRamdomNickName() -> Single<String> {
        nickNameRepository.createRandomNickName()
    }
    
    public func configureTipCategory(categoryIds: [Int]) -> Completable {
        categoryRepository.setCategory(categoryIds: categoryIds)
    }
    
    public func fetchMyProfile() -> Single<User> {
        profileRepository.fetchMyProfile()
    }
    
    public func fetchUserProfile(for userID: Int) -> Single<User> {
        profileRepository.fetchUserProfile(userID: userID)
    }
}
