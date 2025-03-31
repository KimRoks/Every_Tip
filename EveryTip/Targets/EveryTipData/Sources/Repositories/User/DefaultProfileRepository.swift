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
                .responseDecodable(of: MyProfileResponse.self) { response in
                    switch response.result {
                    case .success(let result):
                        let myProfile = result.data.toDomain()
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
                .responseDecodable(of: UserProfileResponse.self) { response in
                    switch response.result {
                    case .success(let result):
                        let userProfile = result.data.userProfile.toDomain()
                        return single(.success(userProfile))
                    case .failure(let error):
                        return single(.failure(error))
                    }
                }
            return Disposables.create { task?.cancel() }
        }
    }
}
