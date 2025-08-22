//
//  DefaultProfileRepository.swift
//  EveryTipData
//
//  Created by 김경록 on 3/31/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

import Alamofire
import RxSwift

struct DefaultProfileRepository: ProfileRepository, SessionInjectable {
    
    var session: Session?
    private let interceptor: TokenInterceptor
    = TokenInterceptor()
    init(session: Session? = .default) {
        self.session = session
    }
    
    func fetchMyProfile() -> Single<MyProfile> {
        guard let request = try? UserTarget.getMyProfile.asURLRequest() else {
            return Single.error(NetworkError.invalidURLError)
        }
        
        return Single.create { single in
            let task = self.session?.request(request, interceptor: interceptor)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: MyProfileDTO.self) { response in
                    switch response.result {
                    case .success(let result):
                        guard let myProfile = result.toDomain() else {
                            return single(.failure(NetworkError.emptyResponseData))
                        }
                        return single(.success(myProfile))
                    case .failure(let error):
                        return single(.failure(error))
                    }
                }
            return Disposables.create { task?.cancel() }
        }
    }
    
    func fetchUserProfile(userID: Int) -> Single<UserProfile> {
        guard let request = try? UserTarget.getUserProfile(userID: userID).asURLRequest() else {
            return Single.error(NetworkError.invalidURLError)
        }
        
        return Single.create { single in
            let task = self.session?.request(request, interceptor: interceptor)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: UserProfileDTO.self) { response in
                    switch response.result {
                    case .success(let userProfileDTO):
                        guard let userProfile = userProfileDTO.toDomain() else {
                            return single(.failure(NetworkError.emptyResponseData))
                        }
                        return single(.success(userProfile))
                        
                    case .failure(let error):
                        return single(.failure(error))
                    }
                }
            return Disposables.create { task?.cancel() }
        }
    }
    
    func toggleSubscription(to userID: Int) -> Completable {
        guard let request = try? UserTarget.postSubscribe(userID: userID).asURLRequest() else {
            return Completable.error(NetworkError.invalidURLError)
        }
        
        return Completable.create { completable in
            let task = session?.request(request, interceptor: interceptor)
                .validate(statusCode: 200..<300)
                .response { response in
                    switch response.result {
                    case .success(_):
                        return completable(.completed)
                    case .failure(let error):
                        return completable(.error(error))
                    }
                }
            return Disposables.create {
                task?.cancel()
            }
        }
    }
    
    func reportUser() -> Completable {
        Completable.empty()
    }
}
