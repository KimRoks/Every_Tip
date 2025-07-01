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
    func fetchRamdomNickName() -> Single<String>
    func fetchMyProfile() -> Single<MyProfile>
    func fetchUserProfile(for userID: Int) -> Single<UserProfile>
    func isNicknameDuplicated(_ nickname: String) -> Single<Bool>
    func toggleSubscription(to userID: Int) -> Completable

    func setMyCategories(categoryIds: [Int]) -> Completable
    func fetchMyCategories() -> Single<[Category]>
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
    
    public func fetchRamdomNickName() -> Single<String> {
        nickNameRepository.fetchRandomNickName()
    }
    
    public func setMyCategories(categoryIds: [Int]) -> Completable {
        categoryRepository.setMyCategories(categoryIDs: categoryIds)
    }
    
    public func fetchMyProfile() -> Single<MyProfile> {
        profileRepository.fetchMyProfile()
    }
    
    public func fetchUserProfile(for userID: Int) -> Single<UserProfile> {
        profileRepository.fetchUserProfile(userID: userID)
    }
    
    func isNicknameDuplicated(_ nickname: String) -> RxSwift.Single<Bool> {
        nickNameRepository.isNicknameDuplicated(nickname)
    }
    
    func toggleSubscription(to userID: Int) -> Completable {
        profileRepository.toggleSubscription(to: userID)
    }
    
    func fetchMyCategories() -> Single<[Category]> {
        categoryRepository.fetchMyCategories()
    }
}
