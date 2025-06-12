//
//  PostTipReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/10/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//
import Foundation

import ReactorKit
import RxSwift

typealias Category = Constants.Category

final class PostTipReactor: Reactor {
    
    enum Action {
        case setCategoryButtonTapped(Category)
        case setTagButtonTapped([String])
    }
    
    enum Mutation {
        case setCategory(Category)
        case setTag([String])
    }
    
    struct State {
        var category: Category?
        var tags: [String]?
    }
    
    var initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .setCategoryButtonTapped(let category):
            return .just(.setCategory(category))
        case .setTagButtonTapped(let tags):
            return .just(.setTag(tags))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
            
        case .setCategory(let category):
            newState.category = category
        case .setTag(let tags):
            newState.tags = tags
        }
        
        return newState
    }
}
