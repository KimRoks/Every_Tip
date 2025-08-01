//
//  SearchReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/25/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

import ReactorKit
import RxSwift
final class SearchReactor: Reactor {
    
    enum Action {
        case searchButtonTapped
        case keywordInputChanged(String)
        case loadRecentKeywords
        case removeRecentKeyword(String)
        case backButtonTapped
        
        case tipSelected(IndexPath)
        case sortButtonTapped(SortOptions)
        case removeAllButtonTapped
    }
    
    enum Mutation {
        case setKeyword(String)
        case setToast(String)
        case setTips([Tip])
        case setRecentKeywords([String])
        case setIsSearched(Bool)
        case setSelectedTip(Tip)
        case setSortButton(SortOptions)

        
        case setPushSignal(Bool)
        case setDismissSignal(Bool)
    }
    
    struct State {
        var keyword: String = ""
        var tips: [Tip] = []
        var recentKeywords: [String] = []
        var isSearched: Bool = false
        var sortOption: SortOptions = .latest
        var selectedTip: Tip?
        
        @Pulse var toastMessage: String?
        @Pulse var pushSignal: Bool = false
        @Pulse var dismissSignal: Bool = false
    }
    
    var initialState = State()
    
    private let searchHistoryUseCase: SearchHistoryUseCase
    private let tipUseCase: TipUseCase
    
    init(
        tipUseCase: TipUseCase,
        searchHistoryUseCase: SearchHistoryUseCase
    ) {
        self.tipUseCase = tipUseCase
        self.searchHistoryUseCase = searchHistoryUseCase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .keywordInputChanged(let keyword):
            return .just(.setKeyword(keyword))
            
        case .searchButtonTapped:
            guard !currentState.keyword.trimmingCharacters(in: .whitespaces).isEmpty else {
                return .just(.setToast("검색어를 입력해주세요"))
            }
            
            searchHistoryUseCase.addKeyword(currentState.keyword)
            
            return tipUseCase.searchTip(with: currentState.keyword)
                .asObservable()
                .flatMap { tips in
                    return Observable.from([
                        .setTips(tips),
                        .setRecentKeywords(self.searchHistoryUseCase.fetchKeywords()),
                        .setIsSearched(true)
                    ])
                }
                .catch { error in
                    return .just(.setToast("검색에 실패했어요"))
                }
            
        case .loadRecentKeywords:
            return .just(.setRecentKeywords(searchHistoryUseCase.fetchKeywords()))
            
        case .removeRecentKeyword(let keyword):
            searchHistoryUseCase.removeKeyword(keyword)
            return .just(.setRecentKeywords(searchHistoryUseCase.fetchKeywords()))
            
        case .tipSelected(let indexPath):
            guard indexPath.row < currentState.tips.count else { return .empty() }
            let tip = currentState.tips[indexPath.row]
            return Observable.concat(
                .just(.setSelectedTip(tip)),
                .just(.setPushSignal(true))
            )
        case .backButtonTapped:
            return .just(.setDismissSignal(true))
        case .sortButtonTapped(let option):
            let sortedTips = currentState.tips.sorted(by: option.toTipOrder())
            return Observable.merge(
                .just(.setTips(sortedTips)),
                .just(.setSortButton(option))
            )
        case .removeAllButtonTapped:
            searchHistoryUseCase.clearKeywords()
            let updated = searchHistoryUseCase.fetchKeywords()
            return .just(.setRecentKeywords(updated))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setKeyword(let keyword):
            newState.keyword = keyword
            
        case .setTips(let tips):
            newState.tips = tips
            
        case .setToast(let message):
            newState.toastMessage = message
            
        case .setRecentKeywords(let keywords):
            newState.recentKeywords = keywords
        case .setIsSearched(let isSearched):
            newState.isSearched = isSearched
        case .setPushSignal(let signal):
            newState.pushSignal = signal
        case .setDismissSignal(let signal):
            newState.dismissSignal = signal
        case .setSelectedTip(let tip):
            newState.selectedTip = tip
        case .setSortButton(let option):
            newState.sortOption = option
        }
        
        return newState
    }
}
