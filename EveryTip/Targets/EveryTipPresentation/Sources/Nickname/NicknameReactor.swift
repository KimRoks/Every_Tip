//
//  NicknameReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 4/20/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

import ReactorKit
import RxSwift

final class NicknameReactor: Reactor {
        
    enum NicknameInputState {
        case normal
        case editing
        case success(reason: NicknameValidationResult)
        case error(reason: NicknameValidationResult)
        case notEnabled
    }
    
    enum NicknameValidationResult {
        case empty
        case invalidFormat
        case duplicated
        case success

        var message: String {
            switch self {
            case .empty:
                return "닉네임을 입력해주세요."
            case .invalidFormat:
                return "닉네임 형식이 옳바르지 않습니다."
            case .duplicated:
                return "이미 사용 중인 닉네임입니다."
            case .success:
                return "사용 가능한 닉네임입니다."
            }
        }
    }

    // MARK: Reactor
    
    enum Action {
        case checkDuplication(nickName: String)
        case randomButtonTapped
        case confirmButtonTapped
        
        case textEditingDidBegin
        case textEditingDidEnd
        case textDidEndOnExit
        case textChanged(String)
    }
    
    enum Mutation {
        case setNickName(String)
        case setIsCheckedDuplication(Bool)
        case setNicknameInputState(NicknameInputState)
        case setToast(String)
    }

    struct State {
        var nicknameText: String?
        var isCheckedDuplication: Bool = false
        var nicknameInputState: NicknameInputState = .normal
        @Pulse var toastMessage: String?
    }
    
    var initialState: State = State()
    
    private let userUseCase: UserUseCase
    
    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .checkDuplication:
            // TODO: 현재 닉네임 중복 체크 API없어서 공백으로 기준삼아놨음
            if currentState.nicknameText == nil {
                return Observable.just(.setNicknameInputState(.error(reason: .duplicated)))
            } else {
                return Observable.concat(
                    .just(.setIsCheckedDuplication(true)),
                    .just(.setNicknameInputState(.success(reason: .success)))
                )
            }
            
        case .randomButtonTapped:
            return userUseCase.fetchRamdomNickName()
                .asObservable()
                .flatMap { nickname in
                    return Observable.concat(
                        .just(.setNickName(nickname)),
                        .just(.setIsCheckedDuplication(false))
                    )
                }

        case .textChanged(let text):
            let result: NicknameValidationResult? = {
                if text.isEmpty {
                    return .empty
                }
                
                if !text.checkRegex(type: .nickname) {
                    return .invalidFormat
                }
                
                return nil
            }()
            
            let fieldState: NicknameInputState = {
                if let result = result {
                    return .error(reason: result)
                } else {
                    return .editing
                }
            }()
            
            return .concat(
                .just(.setIsCheckedDuplication(false)),
                .just(.setNickName(text)),
                .just(.setNicknameInputState(fieldState))
            )
        case .textEditingDidBegin:
            return Observable.just(.setNicknameInputState(.editing))
        case .textEditingDidEnd:
            return Observable.just(.setNicknameInputState(.normal))
        case .textDidEndOnExit:
            return Observable.just(.setNicknameInputState(.normal))
            
        case .confirmButtonTapped:
            if currentState.isCheckedDuplication == false {
                return Observable.just(.setToast("닉네임 중복 확인을 진행해주세요"))
            }
            
            return Observable.concat(
                Observable.just(.setToast("닉네임 설정이 완료되었어요"))
            )
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setNickName(let nickname):
            newState.nicknameText = nickname
        case .setIsCheckedDuplication(let isChecked):
            newState.isCheckedDuplication = isChecked
        case .setNicknameInputState(let state):
            newState.nicknameInputState = state
        case .setToast(let toast):
            newState.toastMessage = toast
        }
        
        return newState
    }
}
