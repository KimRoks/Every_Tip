//
//  UserProfileReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/27/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

import ReactorKit
import RxSwift

final class UserProfileReactor: Reactor {
    
    enum Action {
        case viewDidLoad
        case subScribeButtonTapped
        case sortButtonTapped(SortOptions)
        case itemSelected(Tip)
    }
    
    enum Mutation {
        case setUserProfile(UserProfile)
        case setTips([Tip])
        case setSortedTips([Tip])
        case setSortOption(SortOptions)
        case setSelectedTip(Tip)
        case setPushSignal(Bool)
    }
    
    struct State {
        var userProfile: UserProfile?
        var tips: [Tip] = []
        var sortOption: SortOptions = .latest
        var selectedTip: Tip?
        @Pulse var pushSignal: Bool = false
    }
    
    var initialState: State = State()
    
    private let userID: Int
    
    private let userUseCase: UserUseCase
    private let tipUseCase: TipUseCase
    
    init(
        userID: Int,
        userUseCase: UserUseCase,
        tipUseCase: TipUseCase
    ) {
        self.userID = userID
        self.userUseCase = userUseCase
        self.tipUseCase = tipUseCase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let fetchTips = tipUseCase
                .fetchTips(forUserID: userID)
                .asObservable()
                .map { Mutation.setTips($0) }
            
            let fetchProfile = userUseCase
                .fetchUserProfile(for: userID)
                .asObservable()
                .map { Mutation.setUserProfile($0) }
            
            return Observable.merge(
                fetchTips,
                fetchProfile
            )
            
        case .subScribeButtonTapped:
            return userUseCase.toggleSubscription(to: userID)
                .andThen(.empty())
            
        case .sortButtonTapped(let option):
            let sortedTips = currentState.tips.sorted(by: option.toTipOrder())
            return Observable.from([
                .setSortedTips(sortedTips),
                .setSortOption(option)
            ])
            
        case .itemSelected(let tip):
            return Observable.concat([
                .just(.setSelectedTip(tip)),
                .just(.setPushSignal(true))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setUserProfile(let profile):
            newState.userProfile = profile
            
        case .setTips(let tips):
            newState.tips = tips
            
        case .setSortedTips(let sortedTips):
            newState.tips = sortedTips
            
        case .setSortOption(let option):
            newState.sortOption = option
            
        case .setSelectedTip(let tip):
            newState.selectedTip = tip
            
        case .setPushSignal(let flag):
            newState.pushSignal = flag
        }
        
        return newState
    }
}
