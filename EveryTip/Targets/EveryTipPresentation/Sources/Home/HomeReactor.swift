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
        case fetchPosts
    }
    
    enum Mutation {
        case setPosts([Tip])
        case setError(Error)
    }
    
    struct State {
        var posts: [Tip] = []
        var fetchError: Error?
    }
    
    let initialState: State
    
    private let postUseCase: PostListUseCase
    
    init(postUseCase: PostListUseCase) {
        self.postUseCase = postUseCase
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchPosts:
            return postUseCase.fetchPosts()
                .asObservable()
                .map(Mutation.setPosts)
                .catch { error in
                    Observable.just(Mutation.setError(error))
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setPosts(posts):
            newState.posts = posts
    
        case let .setError(error):
            newState.fetchError = error
        }
        
        return newState
    }
}
