//
//  UserFollowReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/2/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//
import Foundation

import EveryTipDomain

import ReactorKit
import RxSwift

final class UserFollowReactor: Reactor {
    
    enum Action {
        case viewDidLoad
        case removeButtonTapped(userID: Int)
        case itemSelected(UserPreview)
    }
    
    enum Mutation {
        case setUserList([UserPreview])
        case setPushSignal(UserPreview)
    }
    
    struct State {
        var userList: [UserPreview] = []
        @Pulse var pushSignal: UserPreview?
    }
    
    enum FollowType {
        case following
        case followers
    }
    
    var initialState: State = State()
    private let userUseCase: UserUseCase
    let followType: FollowType
    
    init(
        userUseCase: UserUseCase,
        followType: FollowType
    ) {
        self.userUseCase = userUseCase
        self.followType = followType
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let fetch: Single<[UserPreview]> = {
                switch followType {
                case .following:
                    return userUseCase.fetchMyFollowing()
                case .followers:
                    return userUseCase.fetchMyFollowers()
                }
            }()
            
            return fetch
                .asObservable()
                .map { Mutation.setUserList($0) }
        case .removeButtonTapped(userID: let userID):
            return userUseCase.toggleSubscription(to: userID)
                .andThen(userUseCase.fetchMyFollowing())
                .asObservable()
                .map { Mutation.setUserList($0) }
        case .itemSelected(let user):
            return .just(.setPushSignal(user))
        }
    }
    
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setUserList(let list):
            newState.userList = list
        case .setPushSignal(let signal):
            newState.pushSignal = signal
        }
        
        return newState
    }
}
