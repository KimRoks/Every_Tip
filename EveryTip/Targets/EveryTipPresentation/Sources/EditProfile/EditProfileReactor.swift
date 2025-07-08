//
//  EditProfileReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/26/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

import ReactorKit
import RxSwift

// TODO: 회원 탈퇴 및 비밀번호 변경 API 연동

final class EditProfileReactor: Reactor {
    
    enum EditProfileItem {
        case changePassword
        case deleteAccount
    }
    
    enum Action {
        case itemSelected(Int)
        case EditProfileImageTapped
    }
    
    enum Mutation {
        case setChangePasswordSignal(Bool)
        case setDeleteAccountSignal(Bool)
        case setToast(String)
    }
    
    struct State {
        var nickName: String?
        var options: [EditProfileItem] = [
            .changePassword,
            .deleteAccount
        ]
        
        @Pulse var changePasswordSignal: Bool = false
        @Pulse var deleteAccountSignal: Bool = false
        @Pulse var toastMessage: String?
    }
    
    private let authUseCase: AuthUseCase
    
    var initialState: State
    
    init(authUseCase: AuthUseCase,
         nickName:String) {
        self.authUseCase = authUseCase
        self.initialState = State(nickName: nickName)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
       
        switch action {
        case .itemSelected(let index):
            switch index {
                
            case 0:
                return .just(.setChangePasswordSignal(true))
                
            case 1:
                return .just(.setDeleteAccountSignal(true))
                
            default:
                return .empty()
            }
        case .EditProfileImageTapped:
            return .just(.setToast("프로필 사진 변경은 추후 업데이트 예정이에요!"))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setChangePasswordSignal(let signal):
            newState.changePasswordSignal = signal
        case .setDeleteAccountSignal(let signal):
            newState.deleteAccountSignal = signal
        case .setToast(let message):
            newState.toastMessage = message
        }
        return newState
    }
}
