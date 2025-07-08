//
//  UserTipReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/20/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//
import Foundation

import EveryTipDomain

import ReactorKit
import RxSwift

final class UserTipReactor: Reactor {
    
    enum ListType {
        case myTips(userID: Int)
        case savedTips
    }
    
    enum Action {
        case refresh
        case itemSelected(Tip)
    }
    
    enum Mutation {
        case setTips([Tip])
        case setPushSignal(Bool)
        case setSelectedTip(Tip)
    }
    
    struct State {
        var tips: [Tip] = []
        var selectedTip: Tip?
        @Pulse var pushSignal: Bool = false
    }
    
    let initialState: State = State()
    
    private let tipUseCase: TipUseCase
    let listType: ListType
    
    init(tipUseCase: TipUseCase, listType: ListType) {
        self.tipUseCase = tipUseCase
        self.listType = listType
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            let fetchTips: Single<[Tip]>
            switch listType {
            case .myTips(let userID):
                fetchTips = tipUseCase.fetchTips(forUserID: userID)
            case .savedTips:
                fetchTips = tipUseCase.fetchSavedTips()
            }
            return fetchTips
                .asObservable()
                .map { .setTips($0) }
        case .itemSelected(let tip):
            return Observable.concat(
                .just(.setSelectedTip(tip)),
                .just(.setPushSignal(true))
            )
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setTips(let tips):
            newState.tips = tips
        case .setPushSignal(let signal):
            newState.pushSignal = signal
        case .setSelectedTip(let tip):
            newState.selectedTip = tip
        }
        return newState
    }
}
