//
//  MyTipReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/20/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

import ReactorKit
import RxSwift

final class MyTipReactor: Reactor {
    
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
    private let myID: Int
    private let tipUseCase: TipUseCase
    
    init(
        myID: Int,
        tipUseCase: TipUseCase
    ) {
        self.myID = myID
        self.tipUseCase = tipUseCase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            tipUseCase.fetchTips(forUserID: myID)
                .asObservable()
                .map { Mutation.setTips(tips: $0) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
            
        case .setTips(tips: let tips):
            newState.tips = tips
        }
        
        return newState
    }
}
