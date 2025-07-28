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
        case termsButtonTapped
        case privacyPolicyButtonTapped
        case confirmButtonTapped
        case detailButtonTapped
    }

    enum Mutation {
        case setTermCheck(Bool)
        case setPrivacyPolicyCheck(Bool)
        case setToast(String)
        case setNavigationSignal(Bool)
        case setTermsDetailSignal(Bool)
    }

    struct State {
        var isAllChecked: Bool {
            isTermsChecked && isPrivacyPolicyChecked
        }
        var isConfirmable: Bool {
            isTermsChecked && isPrivacyPolicyChecked
        }
        var isTermsChecked: Bool = false
        var isPrivacyPolicyChecked: Bool = false
        @Pulse var toastMessage: String?
        @Pulse var navigationSignal: Bool = false
        @Pulse var termsDetailSignal: Bool = false
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
            let allChecked = currentState.isTermsChecked && currentState.isPrivacyPolicyChecked
            let next = !allChecked
            return Observable.concat([
                .just(.setTermCheck(next)),
                .just(.setPrivacyPolicyCheck(next))
            ])

        case .termsButtonTapped:
            let nextRequired = !currentState.isTermsChecked
            return Observable.just( .setTermCheck(nextRequired))

        case .privacyPolicyButtonTapped:
            let nextOptional = !currentState.isPrivacyPolicyChecked
            return Observable.just(.setPrivacyPolicyCheck(nextOptional))

        case .confirmButtonTapped:
            if !currentState.isConfirmable {
                return .just(.setToast("필수 약관에 동의해주세요."))
            } else {
                let agreementsIDs: [Int] = [
                    currentState.isTermsChecked ? 3 : nil,
                    currentState.isPrivacyPolicyChecked ? 4 : nil
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
                    
                    return Mutation.setNavigationSignal(true)
                }
                .catch { _ in
                    return .just(.setToast("일시적 네트워크 오류입니다. 잠시 후 다시 시도해주세요."))
                }
            }
        case .detailButtonTapped:
            return .just(.setTermsDetailSignal(true))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setTermCheck(let flag):
            newState.isTermsChecked = flag
        case .setPrivacyPolicyCheck(let flag):
            newState.isPrivacyPolicyChecked = flag
        case .setToast(let message):
            newState.toastMessage = message
        case .setNavigationSignal(let signal):
            newState.navigationSignal = signal
        case .setTermsDetailSignal(let signal):
            newState.termsDetailSignal = signal
        }
        return newState
    }
}
