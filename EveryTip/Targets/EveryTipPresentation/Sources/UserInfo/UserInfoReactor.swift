//
//  UserInfoReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/31/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

import ReactorKit
import RxSwift

class UserInfoReactor: Reactor {
    enum Action {
        // TODO: 프로필 편집, 각 아이템 터치 처리
        case viewDidLoad
    }
    
    enum Mutation {
        //viewDidLoad 시
        case setUserData(User)
        case setError(Error)
        
    }
    
    struct State {
        var userInfo: User?
        var userName: String?
        var subscribersCount: Int?
        var postedTipCount: Int?
        var savedTipCount: Int?
        
        var fetchError: Error?
    }
    
    let initialState: State
    
    private let userInfoUserCase: UserInfoUseCase
    
    init(userInfoUserCase: UserInfoUseCase) {
        self.userInfoUserCase = userInfoUserCase
        self.initialState = State()
    }
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return userInfoUserCase.fetchUserInfo()
                .asObservable()
                .map(Mutation.setUserData)
                .catch { error in
                    Observable.just(Mutation.setError(error))
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setUserData(let userInfo):
            newState.userInfo = userInfo
            newState.userName = userInfo.userName
            newState.subscribersCount =  userInfo.userStatistics.subscribersCount
            newState.postedTipCount = userInfo.userStatistics.postedTipCount
            newState.savedTipCount = userInfo.userStatistics.savedTipCount
        case .setError(let error):
            newState.fetchError = error
        }
        
        return newState
    }
    
    func getInfoTableViewItems() -> [String] {
        userInfoUserCase.getInfoTableViewItems()
    }
}
