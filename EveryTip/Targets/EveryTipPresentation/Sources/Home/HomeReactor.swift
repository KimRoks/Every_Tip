//
//  HomeReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/19/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//
import Foundation

import EveryTipDomain

import ReactorKit
import RxSwift

class HomeReactor: Reactor {
    enum Action {
        case viewDidLoad
        case itemSelected(Tip)
        case refesh
        case searchButtonTapped
    }
    
    enum Mutation {
        case setTips([Tip])
        case setSelectedTip(Tip)
        case setToast(String)
        case setPushSignal(Bool)
        case setSearchSiganl(Bool)
    }
    
    struct State {
        var tips: [Tip] = []
        var selectedTip: Tip?
        
        var popularTips: [Tip] = []
        
        @Pulse var pushSignal: Bool = false
        @Pulse var toastMessage: String?
        @Pulse var seachSignal: Bool = false
    }
    
    let initialState: State
    private let tipUseCase: TipUseCase
    
    init(tipUseCase: TipUseCase) {
        self.tipUseCase = tipUseCase
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return tipUseCase.fetchTotalTips()
                .asObservable()
                .map { return Mutation.setTips($0) }
                .catch { _ in
                    return Observable.just(.setToast("팁 목록을 불러오는데 실패했어요. 잠시 후 다시 시도해주세요"))
                }
            
        case .itemSelected(let tip):
            return Observable.concat(
                .just(.setSelectedTip(tip)),
                .just(.setPushSignal(true))
            )
            
        case .refesh:
            return tipUseCase.fetchTotalTips()
                .asObservable()
                .map { return Mutation.setTips($0) }
                .catch { _ in
                    return Observable.just(.setToast("팁 목록을 불러오는데 실패했어요. 잠시 후 다시 시도해주세요"))
                }
        case .searchButtonTapped:
            return .just(.setSearchSiganl(true))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setTips(let tips):
            newState.tips = tips
            newState.popularTips = tips.topPopular()
            
        case .setSelectedTip(let tip):
            newState.selectedTip = tip
        case .setToast(let message):
            newState.toastMessage = message
        case .setPushSignal(let signal):
            newState.pushSignal = signal
        case .setSearchSiganl(let signal):
            newState.seachSignal = signal
        }
        
        return newState
    }
}
