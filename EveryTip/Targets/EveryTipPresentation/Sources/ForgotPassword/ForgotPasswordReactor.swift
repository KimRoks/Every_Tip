//
//  ForgotPasswordReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/21/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

import ReactorKit
import RxSwift

final class ForgotPasswordReactor: Reactor {
    
    enum Action {
        case textChanged(String)
        case confirmButtonTapped
    }
    
    enum Mutation {
        case setEmailText(String)
        case setToastMessage(String)
        case setCompletedSignal(Bool)
    }
    
    struct State {
        var emailText: String = ""
        @Pulse var toastMessage: String?
        @Pulse var completedSignal: Bool = false
    }
    
    var initialState: State = State()
    private let authUseCase: AuthUseCase
    
    init(authUseCase: AuthUseCase) {
        self.authUseCase = authUseCase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .textChanged(let text):
            return .just(.setEmailText(text))
        case .confirmButtonTapped:
            let email = currentState.emailText
               return authUseCase.requestTemporaryPassword(for: email)
                   .andThen(
                       Observable.concat([
                           .just(.setToastMessage("임시 비밀번호를 전송했어요.")),
                           .just(.setCompletedSignal(true))
                       ])
                   )
                   .catch { error in
                       print(error)
                       return .just(.setToastMessage("가입하신 이메일을 다시 확인해주세요"))
                   }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newstate = state
        
        switch mutation {
            
        case .setEmailText(let text):
            newstate.emailText = text
        case .setToastMessage(let message):
            newstate.toastMessage = message
        case .setCompletedSignal(let signal):
            newstate.completedSignal = signal
        }
        
        return newstate
    }
}
