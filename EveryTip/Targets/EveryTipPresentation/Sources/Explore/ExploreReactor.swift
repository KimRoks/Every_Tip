//
//  ExploreReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 12/15/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDomain

import ReactorKit
import RxSwift
final class ExploreReactor: Reactor {
    enum Action {
        case sortButtonTapped(SortOptions)
        case refresh
        case storyCellTapped(selectedStory: DummyStory)
        case itemSelected(Tip)
    }
    
    enum Mutation {
        case setStory([DummyStory])
        case setSortButton(SortOptions)
        case setSelectedStory(DummyStory)
        case setAllTips([Tip])
        case setVisibleTips([Tip])
        case setSelectedTip(Tip)
        case setPushSignal(Bool)
    }
    
    struct State {
        var stories: [DummyStory]
        var sortOption: SortOptions = .latest
        var selectedStory: DummyStory
        var allTips: [Tip] = []        // 원본 전체 tips 저장
        var visibleTips: [Tip] = []    // 현재 UI에 보여줄 tips
        var selectedTip: Tip?
        @Pulse var pushSignal: Bool = false
    }
    
    private let tipUseCase: TipUseCase
    let storyUseCase = DefaultDummyStory()
    
    let initialState: State
    
    // 0번은 항상 전체팁
    var initialStory: [DummyStory] = [
        DummyStory(type: .everyTip)
    ]
    
    init(tipUseCase: TipUseCase) {
        self.initialState = State(
            stories: initialStory,
            selectedStory: initialStory[0]
        )
        self.tipUseCase = tipUseCase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .sortButtonTapped(let option):
            let sortedTips = currentState.visibleTips.sorted(by: option.toTipOrder())
            return Observable.merge(
                .just(.setVisibleTips(sortedTips)),
                .just(.setSortButton(option))
            )
                    
        case .refresh:
            let dummyStories = storyUseCase.getDummy().asObservable()
            let tips = tipUseCase.fetchTotalTips().asObservable()
            
            return Observable.zip(dummyStories, tips)
                .flatMap { stories, tips in
                    Observable.from([
                        .setStory(stories),
                        .setAllTips(tips),
                        .setVisibleTips(tips)
                    ])
                }
            
        case .storyCellTapped(let story):
            let userID = story.userData?.userID ?? 0
            let filteredTips: [Tip]
            if userID == 0 {
                filteredTips = currentState.allTips
            } else {
                filteredTips = currentState.allTips.filtered(using: .userID(userID))
            }
            
            return Observable.concat([
                .just(.setSelectedStory(story)),
                .just(.setVisibleTips(filteredTips))
            ])
        case .itemSelected(let tip):
            return Observable.concat([
                .just(.setSelectedTip(tip)),
                .just(.setPushSignal(true))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setSortButton(let option):
            newState.sortOption = option
            
        case .setStory(let stories):
            newState.stories += stories
            
        case .setSelectedStory(let story):
            newState.selectedStory = story
            
        case .setAllTips(let tips):
            newState.allTips = tips
            
        case .setVisibleTips(let tips):
            newState.visibleTips = tips
        case .setSelectedTip(let tip):
            newState.selectedTip = tip
        case .setPushSignal(let flag):
            newState.pushSignal = flag
        }
        
        return newState
    }
}

extension SortOptions {
    func toTipOrder() -> TipOrder {
        switch self {
        case .latest: return .latest
        case .views: return .views
        case .likes: return .likes
        }
    }
}
