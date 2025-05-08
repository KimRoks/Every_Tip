//
//  CheckAgreementsReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 4/28/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain
import EveryTipCore

import ReactorKit
import RxSwift
import Alamofire

final class CheckAgreementsReactor: Reactor {
    enum Action {
        case agreeAllButtonTapped
        case requiredButtonTapped
        case optionalButtonTapped
        case confirmButtonTapped
    }

    enum Mutation {
        case setRequiredCheck(Bool)
        case setOptionalCheck(Bool)
        case setToast(String)
        case setNavigationSignal(Bool)
    }

    struct State {
        var isAllChecked: Bool {
            isRequiredChecked && isOptionalChecked
        }
        var isConfirmable: Bool {
            isRequiredChecked
        }
        var isRequiredChecked: Bool = false
        var isOptionalChecked: Bool = false
        @Pulse var toastMessage: String?
        @Pulse var navigationSignal: Bool = false
    }

    var initialState = State()

    var signupData: SignupData
    
    init(
        authUseCase: AuthUseCase,
        signupdata: SignupData
    ) {
        self.authUseCase = authUseCase
        self.signupData = signupdata
    }
    
    var authUseCase: AuthUseCase
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .agreeAllButtonTapped:
            
            // 전체 동의: 현재 둘 다 true면 해제, 아니면 모두 체크
            let allChecked = currentState.isRequiredChecked && currentState.isOptionalChecked
            let next = !allChecked
            return Observable.concat([
                .just(.setRequiredCheck(next)),
                .just(.setOptionalCheck(next))
            ])

        case .requiredButtonTapped:
            let nextRequired = !currentState.isRequiredChecked
            return Observable.just( .setRequiredCheck(nextRequired))

        case .optionalButtonTapped:
            let nextOptional = !currentState.isOptionalChecked
            return Observable.just(.setOptionalCheck(nextOptional))

        case .confirmButtonTapped:
            if !currentState.isConfirmable {
                return .just(.setToast("필수 약관에 동의해주세요."))
            } else {
                // TODO: 현재 api에서 정확한 값 측정을 진행하고 있지않음.관련 사항 업데이트 시 수정 필요
                
                let agreementsIDs: [Int] = [
                    currentState.isRequiredChecked ? 3 : nil,
                    currentState.isOptionalChecked ? 4 : nil
                ].compactMap { $0 }
                
                signupData.agreemetns = agreementsIDs
                
                return authUseCase.signUp(
                    email: signupData.email,
                    password: signupData.passwrod,
                    agreementsIDs: signupData.agreemetns,
                    nickName: signupData.nickname
                )
                .asObservable()
                .map { accountData in
                    let tokenManager = TokenKeyChainManager.shared
                    tokenManager.storeToken(accountData.accessToken, type: .access)
                    tokenManager.storeToken(accountData.refreshToken, type: .refresh)
                    
                    return Mutation.setNavigationSignal(true)
                }
                .catch { _ in
                    return .just(.setToast("일시적 네트워크 오류입니다. 잠시 후 다시 시도해주세요."))
                }
            }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setRequiredCheck(let flag):
            newState.isRequiredChecked = flag
        case .setOptionalCheck(let flag):
            newState.isOptionalChecked = flag
        case .setToast(let message):
            newState.toastMessage = message
        case .setNavigationSignal(let signal):
            newState.navigationSignal = signal
        }
        return newState
    }
}
