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
        case itemSeleted(IndexPath)
    }
    
    enum Mutation {
        case setTips([Tip])
        case pushToItemView(Tip)
        case setToast(String)
    }
    
    struct State {
        var posts: [Tip] = []
        var selectedItem: Tip?
        @Pulse var toastMessage: String?
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
            
        case .itemSeleted(let indexPath):
            guard indexPath.row < currentState.posts.count else { return .empty() }
            let tip = currentState.posts[indexPath.row]
            return .just(Mutation.pushToItemView(tip))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setTips(let posts):
            newState.posts = posts
        case .pushToItemView(let tip):
            newState.selectedItem = tip
        case .setToast(let message):
            newState.toastMessage = message
        }
        
        return newState
    }
}
