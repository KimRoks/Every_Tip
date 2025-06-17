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
        case addImageButtonTapped
        case savePhoto([SelectedPhoto])
        case confirmButtonTapped
    }
    
    enum Mutation {
        case setCategory(Category)
        case setTag([String])
        case setPhotos([SelectedPhoto])
        
        case setConfirmSignal(Bool)
        case setImageViewSignal(Bool)
    }
    
    struct State {
        var category: Category?
        var tags: [String]?
        var selectedPhotos: [SelectedPhoto] = []
        
        @Pulse var imageSignal: Bool = false
        @Pulse var confirmSignal: Bool = false
    }
    
    var initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setCategoryButtonTapped(let category):
            return .just(.setCategory(category))
        case .setTagButtonTapped(let tags):
            return .just(.setTag(tags))
        case .addImageButtonTapped:
            return .just(.setImageViewSignal(true))
        case .savePhoto(let photos):
            return .just(.setPhotos(photos))
        case .confirmButtonTapped:
            print(currentState)
            return .just(.setConfirmSignal(true))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
            
        case .setCategory(let category):
            newState.category = category
        case .setTag(let tags):
            newState.tags = tags
        case .setImageViewSignal(let signal):
            newState.imageSignal = signal
        case .setPhotos(let photos):
            newState.selectedPhotos = photos
        case .setConfirmSignal(let signal):
            newState.confirmSignal = signal
        }
        
        return newState
    }
}
