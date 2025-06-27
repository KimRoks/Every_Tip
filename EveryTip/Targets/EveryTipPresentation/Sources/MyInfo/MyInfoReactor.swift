//
//  MyInfoReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/31/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

import EveryTipCore

import ReactorKit
import RxSwift

class MyInfoReactor: Reactor {
    private let tokenManager = TokenKeyChainManager.shared
    
    enum Action {
        // TODO: 프로필 편집, 각 아이템 터치 처리
        case viewDidLoad
        case viewWillAppear
        
        case agreementCellTapped
        case logoutCellTapped
        case logoutConfirmTapped
        case editProfileButtonTapped
        case setCategoryButtonTapped
        case setSubscribeButtonTapped
    }
    
    enum Mutation {
        case setMyProfileData(MyProfile)
        case setToast(String)
        
        // Set Navigation Signal
        case setLogoutCellSignal
        case setAgreementCellSignal
        case setEditProfileSignal
        case setCategorySignal
        case setSubscribeSignal
        
        case setLogoutConfirmSignal(Bool)
    }
    
    struct State {
        var myProfile: MyProfile
        
        @Pulse var toastMessage: String?
        @Pulse var navigationSignal: NavigationSignal?
        
        enum NavigationSignal {
            case agreement
            case logout
            case userContents
            case setCategories
            case editProfile
            case setSubscribe
        }
        @Pulse var logoutConfirmSignal: Bool = false
    }
    
    let initialState: State

    // API가 토큰 없을시 에러만 뱉기떄문에 더미데이터로 대체
    private let guestProfile = MyProfile(
        id: 0,
        status: 0,
        nickName: "게스트",
        profileImageURL: nil,
        email: "everytip",
        registeredDate: "00",
        tipCount: 0,
        savedTipCount: 0,
        subscriberCount: 0
    )
    
    private let userUseCase: UserUseCase
    
    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
        self.initialState = State(
            myProfile: guestProfile
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return userUseCase.fetchMyProfile()
                .asObservable()
                .map(Mutation.setMyProfileData)
                .catch { [weak self] _ in
                    guard let self = self else {
                        return .just(.setToast("잠시 후 다시 시도해주세요"))
                    }
                    return .just(.setMyProfileData(self.guestProfile))
                }
            
        case .viewWillAppear:
            return userUseCase.fetchMyProfile()
                .asObservable()
                .map(Mutation.setMyProfileData)
                .catch { [weak self] _ in
                    guard let self = self else {
                        return .just(.setToast("잠시 후 다시 시도해주세요"))
                    }
                    return .just(.setMyProfileData(self.guestProfile))
                }
            
        case .logoutCellTapped:
            return .just(.setLogoutCellSignal)
            
        case .logoutConfirmTapped:
            if tokenManager.isLoggedIn {
                tokenManager.deleteToken(type: .access)
                tokenManager.deleteToken(type: .refresh)
                
                return .concat(
                    .just(.setMyProfileData(guestProfile)),
                    .just(.setToast("로그아웃 되었어요")),
                    .just(.setLogoutConfirmSignal(true))
                )
            } else {
                return .just(.setToast("로그인이 되어있지않아요."))
            }
            
        case .agreementCellTapped:
            return .just(.setAgreementCellSignal)
        case .editProfileButtonTapped:
            return .just(.setEditProfileSignal)
        case .setCategoryButtonTapped:
            return .just(.setCategorySignal)
        case .setSubscribeButtonTapped:
            return .just(.setSubscribeSignal)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setMyProfileData(let myProfile):
            newState.myProfile = myProfile
        case .setToast(let message):
            newState.toastMessage = message
            
        case .setLogoutConfirmSignal(let signal):
            newState.logoutConfirmSignal = signal
        case .setAgreementCellSignal:
            newState.navigationSignal = .agreement
        case .setLogoutCellSignal:
            newState.navigationSignal = .logout
        case .setEditProfileSignal:
            newState.navigationSignal = .editProfile
        case .setCategorySignal:
            newState.navigationSignal = .setCategories
        case .setSubscribeSignal:
            newState.navigationSignal = .setSubscribe
        }
        
        return newState
    }
    
    func getInfoTableViewItems() -> [String] {
        Constants.MyInfo.tableViewItems
    }
}
