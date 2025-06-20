//
//  SavedTipReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/20/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

import ReactorKit
import RxSwift

final class SavedTipReactor: Reactor {
    
    enum Action {
        case refresh
    }
    
    enum Mutation {
        case setTips(tips: [Tip])
    }
    
    struct State {
        var tips: [Tip] = []
    }
    
    var initialState: State = State()
    
    private let tipUseCase: TipUseCase
    
    init(tipUseCase: TipUseCase) {
        self.tipUseCase = tipUseCase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            tipUseCase.fetchSavedTips()
                .asObservable()
                .map { Mutation.setTips(tips: $0)}
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
            
        case .setTips(let tips):
            newState.tips = tips
        }
        
        return newState
    }
}
