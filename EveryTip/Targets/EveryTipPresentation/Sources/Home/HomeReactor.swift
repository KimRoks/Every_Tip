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
        case setPosts([Tip])
        case setError(Error)
        case pushToItemView(Tip)
    }
    
    struct State {
        var posts: [Tip] = []
        var fetchError: Error?
        var selectedItem: Tip?
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
                .map { posts in
                    let sortedTopThreeByLikeCount = Array(posts.sorted { $0.likeCount > $1.likeCount }.prefix(3))
                    
                    return Mutation.setPosts(sortedTopThreeByLikeCount)
                }
                .catch { error in
                    Observable.just(Mutation.setError(error))
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
        case .setPosts(let posts):
            newState.posts = posts
            
        case .setError(let error):
            newState.fetchError = error
            
        case .pushToItemView(let tip):
            newState.selectedItem = tip
        }
        
        return newState
    }
}
