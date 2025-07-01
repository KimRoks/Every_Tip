//
//  CategorizedTipReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/25/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

import ReactorKit
import RxSwift

final class CategorizedTipReactor: Reactor {
    
    enum Action {
        case loadTips
        case tipSelected(IndexPath)
    }
    
    enum Mutation {
        case setTips([Tip])
        case setSelectedTip(Tip)
        
        case setPushSignal(Bool)
    }
    
    struct State {
        var tips: [Tip] = []
        var selectedTip: Tip?
        
        @Pulse var pushSignal: Bool = false
    }
    
    var initialState: State = State()
    
    private let tipUseCase: TipUseCase
    
    private let categoryID: Int
    
    init(tipUseCase: TipUseCase,
         categoryID: Int) {
        self.tipUseCase = tipUseCase
        self.categoryID = categoryID
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .loadTips:
            return tipUseCase.fetchTotalTips()
                .map {
                    $0.filtered(using: .category(self.categoryID))
                }
                .map { Mutation.setTips($0) }
                .asObservable()
            
        case .tipSelected(let indexPath):
            guard indexPath.row < currentState.tips.count else { return .empty() }
            let tip = currentState.tips[indexPath.row]
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
            
        case .setSelectedTip(let tip):
            newState.selectedTip = tip
        case .setPushSignal(let signal):
            newState.pushSignal = signal
        }
        
        return newState
    }
}
