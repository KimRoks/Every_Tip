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
        //viewDidLoad 시
        case setPosts([Tip])
        case setError(Error)
        
        case pushToItemView(IndexPath)
    }
    
    struct State {
        var posts: [Tip] = []
        var fetchError: Error?
        var selectedIndexPath: IndexPath?
    }
    
    let initialState: State
    
    private let postUseCase: PostListUseCase
    
    init(postUseCase: PostListUseCase) {
        self.postUseCase = postUseCase
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return postUseCase.fetchPosts()
                .asObservable()
                .map(Mutation.setPosts)
                .catch { error in
                    Observable.just(Mutation.setError(error))
                }
            
        case .itemSeleted(let indexPath):
            return .just(Mutation.pushToItemView(indexPath))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setPosts(let posts):
            newState.posts = posts
            
        case .setError(let error):
            newState.fetchError = error
            
        case .pushToItemView(let indexPath):
            newState.selectedIndexPath = indexPath
        }
        
        return newState
    }
}

