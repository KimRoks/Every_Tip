//
//  SectionedTipReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/9/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

import RxSwift
import ReactorKit

final class SectionedTipReactor: Reactor {
    typealias Category = EveryTipDomain.Category
    typealias SectionType = HomeSectionHeaderView.SectionType
    
    enum Action {
        case fetchTips
        case itemSelected(Tip)
    }
    
    enum Mutation {
        case setTips([Tip])
        case setSelectedTip(Tip)
        case setPushSignal(Bool)
    }
    
    struct State {
        var tips: [Tip] = []
        var selectedTip: Tip?
        @Pulse var pushSignal: Bool = false
    }
    
    let initialState: State = State()
    
    private let tipUseCase: TipUseCase
    
    private let sectionType: SectionType
    private let myCategories: [Category]
    
    init(
        tipUseCase: TipUseCase,
        sectionType: SectionType,
        myCategories: [Category]
    ) {
        self.tipUseCase = tipUseCase
        self.sectionType = sectionType
        self.myCategories = myCategories
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchTips:
            return tipUseCase.fetchTotalTips()
                .map { Mutation.setTips($0) }
                .asObservable()
            
        case .itemSelected(let tip):
            return Observable.concat(
                .just(.setSelectedTip(tip)),
                .just(.setPushSignal(true))
            )
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setTips(let tips):
            switch sectionType {
            case .popular:
                newState.tips = tips.sorted(by: .popularity)
            case .interestCategory:
                let categoryIDs = myCategories.map { $0.id }
                newState.tips = tips.filter {
                    categoryIDs.contains($0.categoryId)
                }
            }
        case .setSelectedTip(let tip):
            newState.selectedTip = tip
        case .setPushSignal(let signal):
            newState.pushSignal = signal
        }
        
        return newState
    }
}
