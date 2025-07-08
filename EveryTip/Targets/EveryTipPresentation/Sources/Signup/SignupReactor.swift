//
//  SignupReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 4/7/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDomain

import ReactorKit
import RxSwift
import RxRelay

// TODO: MVVM 관점에서의 관심사 분리 고려 필요
// TODO: 가이드 메세지 최적화, 데이터 전달 고려 필요

final class SignUpReactor: Reactor {
    private let timerSubject = BehaviorSubject<Observable<Mutation>>(value: Observable.empty())
    private var timerStream: Observable<Mutation> {
        return timerSubject.switchLatest()
    }
    
    private func runTimer() -> Observable<Mutation> {
        return Observable<Int>
            .interval(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .map { 300 - $0 }
            .take(while: { $0 >= 0 })
            .map {
                Mutation.updateTimerState(
                    isHidden: false,
                    remainTime: $0
                )
            }
            .do(onDispose: { print("타이머 해제") })
    }
    
    let submitButtonTapRelay = PublishRelay<Void>()
    
    enum VerificationButtonState {
        case beforeSending
        case afterSent
        case afterVerified
    }
    
    enum TextFieldType {
        case email
        case verificationCode
        case password
        case confirmPassword
    }
    
    enum Action {
        case verifyButtonTapped(email: String)
        case textFieldAction(type: TextFieldType, action: EveryTipTextFieldAction)
        case confirmButtonTapped
    }
    
    enum Mutation {
        case updateVerifiedLabelVisibility(Bool)
        case updateCheckEmailButtonState(VerificationButtonState)
        case updateTimerState(isHidden: Bool, remainTime: Int)
        case updateTextField(
            type: TextFieldType,
            text: String?,
            status: EveryTipTextFieldStatus,
            errorMessage: String? = nil
        )
        case updateSubmitButtonEnabledState(Bool)
        case setToast(String)
    }
    
    struct State {
        var isVerificationCompletedLabelHidden = true
        var checkEmailButtonState: VerificationButtonState = .beforeSending
        var isSubmitButtonEnabled = false
        var remainingTime = 0
        var isTimerHidden = true
        var textFieldText: [TextFieldType: String] = [:]
        var textFieldStatus: [TextFieldType: (status: EveryTipTextFieldStatus, errorMessage: String?)] = [:]
        @Pulse var toastMessage: String?
    }
    
    var initialState: State
    private let authUseCase: AuthUseCase?
    
    init(authUseCase: AuthUseCase) {
        self.initialState = State(
            textFieldStatus: [
                .verificationCode: (.notEnabled, nil),
                .password: (.notEnabled, nil),
                .confirmPassword: (.notEnabled, nil)
            ]
        )
        self.authUseCase = authUseCase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .verifyButtonTapped(let email):
            return handleVerifyButton(email: email)
        case .textFieldAction(let type, let action):
            return handleTextFieldAction(type: type, action: action)
        case .confirmButtonTapped:
            return handleSubmit()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .updateVerifiedLabelVisibility(let hidden):
            newState.isVerificationCompletedLabelHidden = hidden
        case .updateCheckEmailButtonState(let buttonState):
            newState.checkEmailButtonState = buttonState
        case .updateTimerState(let hidden, let time):
            newState.isTimerHidden = hidden
            newState.remainingTime = time
        case .updateTextField(let type, let text, let status, let errorMessage):
            if let textValue = text {
                newState.textFieldText[type] = textValue
            }
            newState.textFieldStatus[type] = (status, errorMessage)
        case .updateSubmitButtonEnabledState(let isEnabled):
            newState.isSubmitButtonEnabled = isEnabled
        case .setToast(let message):
            newState.toastMessage = message
        }
        return newState
    }
    
    // MARK: - Handlers
    
    private func handleVerifyButton(email: String) -> Observable<Mutation> {
        guard let authUseCase = authUseCase else { return Observable.empty() }
        
        guard email.checkRegex(type: .email) else {
            return Observable.just(
                .updateTextField(
                    type: .email,
                    text: nil,
                    status: .error,
                    errorMessage: "이메일 형식으로 입력해주세요"
                )
            )
        }
        
        return authUseCase.checkEmailDuplication(for: email)
            .andThen(
                Observable.deferred { [weak self] in
                    guard let self = self else { return .empty() }
                    
                    self.timerSubject.onNext(self.runTimer().share())
                    
                    return authUseCase.requestEmailCode(email: email)
                        .andThen(
                            Observable.concat([
                                .just(.updateTextField(type: .verificationCode, text: nil, status: .normal)),
                                .just(.updateVerifiedLabelVisibility(true)),
                                .just(.updateCheckEmailButtonState(.afterSent)),
                                .just(.setToast("인증 코드를 입력한 이메일로 전달드렸어요.")),
                                self.timerStream
                            ])
                        )
                }
            )
            .catch { error in
                // 중복 검사 또는 인증 요청 중 에러 발생 시
                return Observable.just(
                    .updateTextField(
                        type: .email,
                        text: nil,
                        status: .error,
                        errorMessage: "이미 가입된 이메일이에요."
                    )
                )
            }
    }
    
    private func handleTextFieldAction(type: TextFieldType, action: EveryTipTextFieldAction) -> Observable<Mutation> {
        switch action {
        case .textChanged(let text):
            return handleTextChanged(type: type, text: text)
        case .editingDidBegin:
            return Observable.just(.updateTextField(type: type, text: nil, status: .editing))
        case .editingDidEnd:
            if type == .verificationCode {
                return Observable.empty()
            }
            return Observable.just(.updateTextField(type: type, text: nil, status: .normal))
        case .editingDidEndOnExit:
            return Observable.just(.updateTextField(type: type, text: nil, status: .normal))
        }
    }
    
    private func handleTextChanged(type: TextFieldType, text: String) -> Observable<Mutation> {
        switch type {
        case .email:
            return Observable.just(.updateTextField(type: .email, text: text, status: .editing))
        case .verificationCode:
            return handleVerificationCode(text)
        case .password:
            let isValidPassword = text.checkRegex(type: .password)
            return Observable.just(
                .updateTextField(
                    type: .password,
                    text: text,
                    status: isValidPassword ? .editing : .error,
                    errorMessage: isValidPassword ? "" : "영문 + 숫자 조합 8자리 이상 입력해 주세요."
                )
            )
        case .confirmPassword:
            return handleConfirmPassword(text)
        }
    }
    
    private func handleVerificationCode(_ text: String) -> Observable<Mutation> {
        guard let authUseCase = authUseCase else { return Observable.empty() }
        guard text.checkRegex(type: .verifyCode) else {
            return Observable.just(
                .updateTextField(
                    type: .verificationCode,
                    text: text,
                    status: .error,
                    errorMessage: "숫자 4자리만 입력해주세요"
                )
            )
        }
        if text.count == 4 && currentState.remainingTime > 0 {
            return authUseCase.checkEmailCode(code: text)
                .observe(on: MainScheduler.asyncInstance)
                .andThen(
                    Observable.concat([
                        .just(.updateTimerState(isHidden: true, remainTime: 0)),
                        .just(.updateCheckEmailButtonState(.afterVerified)),
                        .just(.updateTextField(type: .email, text: nil, status: .notEnabled)),
                        .just(.updateTextField(type: .verificationCode, text: nil, status: .notEnabled)),
                        .just(.updateTextField(type: .password, text: nil, status: .normal)),
                        .just(.updateTextField(type: .confirmPassword, text: nil, status: .normal)),
                        .just(.setToast("인증이 완료되었습니다.")),
                        .just(.updateVerifiedLabelVisibility(false))
                    ])
                )
                .catch { _ in
                    Observable.just(
                        .updateTextField(
                            type: .verificationCode,
                            text: text,
                            status: .error,
                            errorMessage: "인증번호를 다시 확인해주세요"
                        )
                    )
                }
        }
        return Observable.just(.updateTextField(type: .verificationCode, text: text, status: .editing))
    }
    
    private func handleConfirmPassword(_ text: String) -> Observable<Mutation> {
        let passwordText = currentState.textFieldText[.password] ?? ""
        let isMatching = passwordText == text && text.checkRegex(type: .password)
        let status: EveryTipTextFieldStatus = isMatching ? .editing : .error
        let errorMessage = status == .error ? "비밀번호가 일치하지 않습니다." : ""
        let enableSubmit = Observable.just(Mutation.updateSubmitButtonEnabledState(isMatching))
        return Observable.concat([
            .just(
                .updateTextField(
                    type: .confirmPassword,
                    text: text,
                    status: status,
                    errorMessage: errorMessage
                )
            ),
            enableSubmit
        ])
    }
    
    
    private func handleSubmit() -> Observable<Mutation> {
        submitButtonTapRelay.accept(())
        return .empty()
    }
}
