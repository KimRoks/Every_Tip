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
        case setSections([SectionOfHomeView])
    }
    
    struct State {
        var posts: [Tip] = []
        var fetchError: Error?
        var selectedItem: Tip?
        var postListSections: [SectionOfHomeView] = []
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
                    let sortedTopThree = posts.sorted { $0.likeCount > $1.likeCount }.prefix(3)
                    let sortedByCategory = posts.filter { $0.category == "레시피" || $0.category == "스포츠" }
                    
                    let sections = [
                        SectionOfHomeView(
                            header: "인기 팁 모아보기 🔥",
                            items: Array(sortedTopThree),
                            footer: true
                        ),
                        SectionOfHomeView(
                            header: "관심 카테고리~ 추천 팁 영역 🔍",
                            items: Array(sortedByCategory)
                        )
                    ]
                    return [.setPosts(Array(sortedTopThree)),
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

struct SectionOfHomeView {
    var header: String
    var items: [Tip]
    var footer: Bool?
}

extension SectionOfHomeView: SectionModelType {
    typealias Item = Tip
    
    init(original: SectionOfHomeView, items: [Item]) {
        self = original
        self.items = items
    }
}
