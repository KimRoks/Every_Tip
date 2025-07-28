//
//  EditPasswordReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/20/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import EveryTipCore
import EveryTipDomain

import ReactorKit
import RxSwift

final class EditPasswordReactor: Reactor {
    
    enum Action {
        case currentPasswordChanged(String)
        case newPasswordChanged(String)
        case newPasswordConfirmationChanged(String)
        case confirmButtonTapped
    }
    
    enum Mutation {
        case setCurrentPassword(String)
        case setNewPassword(String)
        case setNewPasswordConfirmation(String)
        case setToast(String)
        case setSignal(Bool)
        case setIsConfirmed(Bool)
    }
    
    struct State {
        var currentPassword: String = ""
        var newPassword: String = ""
        var newPasswordConfirmation: String = ""
        var isConfirmed: Bool = false
        
        
        @Pulse var toastMessage: String?
        @Pulse var navigationSignal: Bool = false
    }
    
    let initialState: State = State()
    
    private let tokenManager = TokenKeyChainManager.shared
    private let authUseCase: AuthUseCase
    
    init(authUseCase: AuthUseCase) {
        self.authUseCase = authUseCase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .currentPasswordChanged(password):
            return Observable.concat(
                .just(.setCurrentPassword(password)),
                .just(.setIsConfirmed(
                    shouldEnableConfirm(
                        current: password,
                        new: currentState.newPassword,
                        confirm: currentState.newPasswordConfirmation
                    ))
                )
            )
        
        case let .newPasswordChanged(password):
            return Observable.concat(
                .just(.setNewPassword(password)),
                .just(
                    .setIsConfirmed(
                        shouldEnableConfirm(
                            current: password,
                            new: currentState.newPassword,
                            confirm: currentState.newPasswordConfirmation
                        )
                    )
                )
            )
        
        case let .newPasswordConfirmationChanged(password):
            
            return Observable.concat(
                .just(.setNewPasswordConfirmation(password)),
                .just(
                    .setIsConfirmed(
                        shouldEnableConfirm(
                            current: password,
                            new: currentState.newPassword,
                            confirm: currentState.newPasswordConfirmation
                        )
                    )
                )
            )
            
        case .confirmButtonTapped:
            
            guard isPasswordFormatValid() else {
                return .just(.setToast("비밀번호는 영문, 숫자를 포함한 8자리 이상이어야 합니다."))
            }
            guard isNewPasswordMatched() else {
                return .just(.setToast("새 비밀번호가 서로 일치하지 않습니다."))
            }
            
            return authUseCase.checkPassword(with: currentState.currentPassword)
                .andThen(authUseCase.changePassword(to: currentState.newPassword))
                .andThen(deleteTokens())
                .andThen(
                    Observable.concat([
                        .just(.setToast("변경된 비밀번호로 다시 로그인해주세요")),
                        .just(.setSignal(true))
                    ])
                )
                .catch { error in
                    return Observable.just(.setToast("\(error.localizedDescription)"))
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setCurrentPassword(password):
            newState.currentPassword = password
        case let .setNewPassword(password):
            newState.newPassword = password
        case let .setNewPasswordConfirmation(password):
            newState.newPasswordConfirmation = password
            
        case .setToast(let message):
            newState.toastMessage = message
        case .setSignal(let signal):
            newState.navigationSignal = signal
        case .setIsConfirmed(let isConfirmed):
            newState.isConfirmed = isConfirmed
        }
        
        return newState
    }
    
    private func deleteTokens() -> Completable {
        return Completable.create { [weak self] completable in
            self?.tokenManager.deleteToken(type: .access)
            self?.tokenManager.deleteToken(type: .refresh)
            completable(.completed)
            
            return Disposables.create()
        }
    }
    
    private func shouldEnableConfirm(current: String, new: String, confirm: String) -> Bool {
        return !current.isEmpty && !new.isEmpty && !confirm.isEmpty
    }
    
    private func isPasswordFormatValid() -> Bool {
        return currentState.newPassword.checkRegex(type: .password)
            && currentState.newPasswordConfirmation.checkRegex(type: .password)
        
    }
    
    private func isNewPasswordMatched() -> Bool {
        currentState.newPassword == currentState.newPasswordConfirmation
    }
}
