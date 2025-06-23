//
//  SetCategoryReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/23/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

import ReactorKit
import RxSwift

final class SetCategoryReactor: Reactor {
    typealias Category = Constants.Category

    enum Action {
        case confirmButtonTapped
        case toggleCategory(Category)
    }

    enum Mutation {
        case toggleCategory(Category)
        case setSelectedCategories([Category])
        case setCompletedSignal(Bool)
        case setToast(message: String)
    }

    struct State {
        var selectedCategories: [Category] = []
        @Pulse var completedSignal: Bool = false
        @Pulse var toastMessage: String?
    }

    private let userUseCase: UserUseCase

    var initialState: State = State()

    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .confirmButtonTapped:
            let ids = currentState.selectedCategories.map { $0.id }
            return userUseCase.setMyCategories(categoryIds: ids)
                .andThen(
                    Observable.concat(
                        .just(.setToast(message: "관심 카테고리 설정이 완료되었어요")),
                        .just(.setCompletedSignal(true))
                    )
                )

        case .toggleCategory(let category):
            return .just(.toggleCategory(category))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .toggleCategory(let category):
            if newState.selectedCategories.contains(where: { $0.id == category.id }) {
                newState.selectedCategories.removeAll { $0.id == category.id }
            } else {
                newState.selectedCategories.append(category)
            }

        case .setSelectedCategories(let categories):
            newState.selectedCategories = categories

        case .setToast(let message):
            newState.toastMessage = message
        case .setCompletedSignal(let signal):
            newState.completedSignal = signal
        }

        return newState
    }
}
