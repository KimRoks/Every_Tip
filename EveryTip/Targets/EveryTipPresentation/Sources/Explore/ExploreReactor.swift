//
//  ExploreReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 12/15/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDesignSystem

import ReactorKit
import RxSwift

final class ExploreReactor: Reactor {
    enum Action {
        case sortButtonTapped(SortOptions)
        case viewDidLoad
        case storyCellTapped(selectedStory: DummyStory)
    }
    
    enum Mutation {
        case setStory([DummyStory])
        case setSortButton(SortOptions)
        case setSelectedStory(DummyStory)
    }
    
    struct State {
        var stories: [DummyStory]
        var sortOption: SortOptions = .latest
        var selectedStory: DummyStory
    }
    
    let initialState: State
    
    // ID 0번의 전체팁을 기본으로 가짐
    var initialStory: [DummyStory] = [
        DummyStory(
            type: .everyTip
        )
    ]
    
    // TODO: real useCase로 변경
    let useCase = DefaultDummyStory()
    
    init() {
        self.initialState = State(
            stories: initialStory,
            selectedStory: initialStory[0]
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case .sortButtonTapped(let option):
            return .just(.setSortButton(option))
            
        case .viewDidLoad:
            return useCase
                .getDummy()
                .asObservable()
                .map(Mutation.setStory)
            
        case .storyCellTapped(selectedStory: let story):
            return .just(Mutation.setSelectedStory(story))
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
        }
        return newState
    }
}
