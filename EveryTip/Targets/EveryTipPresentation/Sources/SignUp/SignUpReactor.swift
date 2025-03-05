//
//  SignUpReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 2/17/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDomain

import ReactorKit
import RxSwift

final class SignUpReactor: Reactor {
    
    private let timerSubject = BehaviorSubject<Observable<Mutation>>(value: Observable.empty())
    
    private var timerStream: Observable<Mutation> {
        return timerSubject.switchLatest()
    }
    
    private let timer = Observable<Int>
        .interval(.seconds(1), scheduler: MainScheduler.asyncInstance)
        .map { 300 - $0 }
        .take(while: { $0 >= 0 })
        .map {
            Mutation.updateTimerState(isHidden: false, remainTime: $0)
        }.do(onDispose: { print("타이머 해제") })
    
    enum VerificationButtonState {
        case beforeSending
        case afterSent
        case afterVerified
    }
    
    enum TextFieldType {
        case email
        case VerificationCode
        case password
        case confirmPassword
    }
    
    enum Action {
        case viewDidLoad
        case verifyButtonTapped(email: String)
        case textFieldAction(type: TextFieldType, action: EveryTipTextFieldAction)
        case submitButtonTapped
    }
    
    enum Mutation {
        case updateVerifiedLabelVisibility(Bool)
        case updateCheckEmailButtonState(VerificationButtonState)
        case updateTimerState(isHidden: Bool, remainTime: Int)
        case updateTextFieldText(type: TextFieldType, text: String)
        case updateTextFieldStatus(
            type: TextFieldType,
            status: EveryTipTextFieldStatus,
            errorMessage: String? = nil
        )
        case updateSubmitButtonEnabledState(Bool)
    }
    
    struct State {
        var isVerificationCompletedLabelHidden: Bool = true
        var checkEmailButtonState: VerificationButtonState = .beforeSending
        var isSubmitButtonEnabled: Bool = false
        var remainingTime: Int = 0
        var isTimerHidden: Bool = true
        
        var textFieldText: [TextFieldType: String] = [:]
        var textFieldStatus: [TextFieldType: (status: EveryTipTextFieldStatus, errorMessage: String?)] = [:]
    }
    
    var initialState: State
    
    private let authUseCase: AuthUseCase?
    
    init(authUseCase: AuthUseCase) {
        self.initialState = State()
        self.authUseCase = authUseCase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        guard let useCase = authUseCase else {
            return Observable.empty()
        }
        
        switch action {
            
            // MARK: 초기 설정
        case .viewDidLoad:
            return Observable.merge(
                .just(.updateTextFieldStatus(type: .VerificationCode, status: .notEnabled)),
                .just(.updateTextFieldStatus(type: .password, status: .notEnabled)),
                .just(.updateTextFieldStatus(type: .confirmPassword, status: .notEnabled))
            )
            
            // MARK: 이메일 코드 확인 버튼 눌림
            
        case .verifyButtonTapped(email: let email):
            guard checkRegex(textType: .email, text: email) else {
                return Observable.concat(
                    Observable.just(
                        .updateTextFieldStatus(
                            type: .email,
                            status: .error,
                            errorMessage: "이메일 형식으로 입력해주세요"
                        )
                    )
                )
            }
            
            //Timer 작동
            timerSubject.onNext(timer)
            
            return useCase.requestEmailCode(email: email)
                .asObservable()
                .flatMapLatest { result in
                    return Observable.concat(
                        .just(
                            Mutation.updateTextFieldStatus(
                                type: .VerificationCode,
                                status: .normal,
                                errorMessage: nil
                            )
                        ),
                        .just(Mutation.updateVerifiedLabelVisibility(true)),
                        .just(Mutation.updateCheckEmailButtonState(.afterSent)),
                        self.timerStream
                    )
                }
                .catch { error in
                    return Observable.just(
                        .updateTextFieldStatus(
                            type: .email,
                            status: .error,
                            errorMessage: "이메일을 다시 확인해주세요."
                        )
                    )
                }
            
            // 텍스트 필드 액션내의 타입 별로 작성됨(switch 내부 switch)
            // MARK: 텍스트 필드 액션
            
        case .textFieldAction(let type, let textFieldAction):
            
            switch textFieldAction {
                
            case .textChanged(let text):
                
                switch type {
                    
                    // MARK: email Code textChange 시
                case .VerificationCode:
                    guard checkRegex(textType: .verifyCode, text: text) else {
                        return Observable.concat(
                            .just(
                                .updateTextFieldStatus(
                                    type: .VerificationCode,
                                    status: .error,
                                    errorMessage: "숫자 4자리만 입력해주세요"
                                )
                            ),
                            .just(
                                .updateTextFieldText(type: type,text: text)
                            )
                        )
                    }
                    
                    if text.count == 4 && currentState.remainingTime > 0 {
                        return useCase.checkEmailCode(code: text)
                            .asObservable()
                            .flatMap { _ in
                                print("인증코드 인증 성공")
                                return Observable.concat(
                                    // 비밀번호 텍스트필드 활성화 및 이메일 파트 비활성화
                                    
                                    // TODO:
                                    // verficationCode TextField의 상태 변경 시 이벤트가 겹쳐서 에러나옴.
                                    // 당장은 문제 없어보이지만 추후 수정
                                    
                                    .just(Mutation.updateTimerState(isHidden: true, remainTime: 0)),
                                    .just(Mutation.updateCheckEmailButtonState(.afterVerified)),
                                    .just(Mutation.updateTextFieldStatus(type: .email, status: .notEnabled)),
                                    .just(Mutation.updateTextFieldStatus(type: .VerificationCode, status: .success)),
                                    .just(Mutation.updateTextFieldStatus(type: .VerificationCode, status: .notEnabled)),
                                    .just(Mutation.updateTextFieldStatus(type: .password, status: .normal)),
                                    .just(Mutation.updateTextFieldStatus(type: .confirmPassword, status: .normal)),
                                    .just(Mutation.updateVerifiedLabelVisibility(false))
                                )
                            }
                            .observe(on: MainScheduler.asyncInstance)
                            .catch { _ in
                                print("인증코드 에러")
                                return Observable.just(
                                    Mutation.updateTextFieldStatus(
                                        type: .VerificationCode,
                                        status: .error,
                                        errorMessage: "인증번호를 다시 확인해주세요"
                                    )
                                )
                            }
                    } else {
                        return Observable.concat(
                            .just(Mutation.updateTextFieldText(type: .VerificationCode, text: text)),
                            .just(
                                Mutation.updateTextFieldStatus(
                                    type: .VerificationCode,
                                    status: .editing,
                                    errorMessage: ""
                                )
                            )
                        )
                    }
                    
                    // MARK: password textChange 시
                    
                case .password:
                    if checkRegex(textType: .password, text: text) == false {
                        return Observable.concat(
                            .just(.updateTextFieldText(type: type,text: text)),
                            .just(.updateTextFieldStatus(
                                type: .password,
                                status: .error,
                                errorMessage: "영문 + 숫자 조합 8자리 이상 입력해 주세요.")
                            )
                        )
                    } else {
                        return Observable.concat(
                            .just(.updateTextFieldText(type: type,text: text)),
                            .just(
                                .updateTextFieldStatus(
                                    type: .password,
                                    status: .editing,
                                    errorMessage: ""
                                )
                            )
                        )
                    }
                    
                    // MARK: password Check textChange 시
                    
                case .confirmPassword:
                    let password = currentState.textFieldText[.password]
                    let checkPassword = currentState.textFieldText[.confirmPassword]
                    
                    if password != nil,
                       checkPassword != nil,
                       checkRegex(textType: .password, text: text) == true {
                        return Observable.concat(
                            .just(Mutation.updateTextFieldText(type: .confirmPassword, text: text)),
                            .just(Mutation.updateSubmitButtonEnabledState(true))
                        )
                    }
                    
                    if checkRegex(textType: .password, text: text) {
                        return Observable.concat(
                            .just(
                                Mutation.updateTextFieldStatus(
                                    type: .confirmPassword,
                                    status: .editing,
                                    errorMessage: ""
                                )
                            ),
                            .just(Mutation.updateTextFieldText(type: .confirmPassword, text: text))
                        )
                    } else {
                        return Observable.concat(
                            .just(Mutation.updateTextFieldText(type: .confirmPassword, text: text)),
                            .just(
                                .updateTextFieldStatus(
                                    type: .confirmPassword,
                                    status: .error,
                                    errorMessage: "영문 + 숫자 조합 8자리 이상 입력해 주세요."
                                )
                            )
                        )
                    }
                    
                default :
                    return Observable.concat(
                        .just(
                            .updateTextFieldStatus(
                                type: type,
                                status: .editing,
                                errorMessage: ""
                            )
                        ),
                        .just(.updateTextFieldText(type: type, text: text))
                    )
                }
                
            case .editingDidBegin:
                return Observable.just(.updateTextFieldStatus(type: type, status: .editing))
                
            case .editingDidEnd:
                return Observable.just(.updateTextFieldStatus(type: type, status: .normal))
                
            case .editingDidEndOnExit:
                return Observable.just(.updateTextFieldStatus(type: type, status: .normal))
            }
            
            // MARK: 제출 버튼 눌릴 시
            
        case .submitButtonTapped:
            let currentPassword = currentState.textFieldText[.password]
            let currentConfirmPassword = currentState.textFieldText[.confirmPassword]
            
            if currentPassword == currentConfirmPassword,
               checkRegex(textType: .password, text: currentPassword),
               checkRegex(textType: .password, text: currentConfirmPassword) {
                print("비밀번호 일치, 정규식도 맞음 다음화면 ㄱㄱ")
                return Observable.empty()
            } else {
                return Observable.just(
                    .updateTextFieldStatus(
                        type: .confirmPassword,
                        status: .error,
                        errorMessage: "비밀번호가 일치하지 않습니다."
                    )
                )
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .updateCheckEmailButtonState(let state):
            newState.checkEmailButtonState = state
            
        case .updateTimerState(let isHidden, let remainTime):
            newState.isTimerHidden = isHidden
            newState.remainingTime = remainTime
            
        case .updateTextFieldText(type: let type, text: let text):
            newState.textFieldText[type] = text
            
        case .updateTextFieldStatus(type: let type, status: let status, errorMessage: let message):
            newState.textFieldStatus[type] = (status, message)
            
        case .updateVerifiedLabelVisibility(let isHidden):
            newState.isVerificationCompletedLabelHidden = isHidden
            
        case .updateSubmitButtonEnabledState(let isActive):
            newState.isSubmitButtonEnabled = isActive
        }
        return newState
    }
}

enum TextType {
    case email
    case password
    case verifyCode
}

private func checkRegex(textType: TextType, text: String?) -> Bool {
    
    guard let text = text else { return false }
    
    switch textType {
    case .email:
        let emailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
        return text.range(of: emailRegex, options: .regularExpression) != nil
        
    case .password:
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d).{8,}$"
        return text.range(of: passwordRegex, options: .regularExpression) != nil
        
    case .verifyCode:
        if let _ = Int(text) {
            return true
        } else {
            return false
        }
    }
}

