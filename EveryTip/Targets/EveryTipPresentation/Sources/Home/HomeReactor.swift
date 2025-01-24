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
import RxDataSources
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
        
        case pushToItemView(Tip)
        case setSections([HomeTableViewSection])
    }
    
    struct State {
        var posts: [Tip] = []
        var fetchError: Error?
        var selectedItem: Tip?
        var postListSections: [HomeTableViewSection] = []
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
                    
                    // 로그인이 되어있지않았거나 선택된 카테고리가 없어 빈 배열을 받았다는 가정
                    let empty: [Tip] = []
                    
                    let sections = [
                        HomeTableViewSection(
                            sectionType: .popular,
                            items: sortedTopThreeByLikeCount
                        ),
                        HomeTableViewSection(
                            sectionType: .interestCategory,
                            items: empty
                        )
                    ]
                    return [.setPosts(Array(sortedTopThreeByLikeCount)),
                            .setSections(sections)]
                }
                .catch { error in
                    Observable.just([.setError(error)])
                }
                .flatMap { Observable.from($0) }
            
            
        case .itemSeleted(let indexPath):
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
        case .setSections(let section):
            newState.postListSections = section
        }
        
        return newState
    }
}
