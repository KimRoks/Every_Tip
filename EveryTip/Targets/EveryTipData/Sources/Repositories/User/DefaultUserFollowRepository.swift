//
//  DefaultUserFollowRepository.swift
//  EveryTipData
//
//  Created by 김경록 on 7/2/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

import Alamofire
import RxSwift

struct DefaultUserFollowRepository: UserFollowRepository, SessionInjectable {
    var session: Session?
    
    private let interceptor: TokenInterceptor = TokenInterceptor()
    init(session: Session? = .default) {
        self.session = session
    }
    
    func fetchMyFollowers() -> Single<[EveryTipDomain.UserPreview]> {
        guard let request = try? UserTarget.getMyFollowers.asURLRequest() else {
            return Single.error(NetworkError.invalidURLError)
        }
        
        return Single.create { single in
            let task = session?.request(request, interceptor: interceptor)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: UserPreviewDTO.self) { response in
                    switch response.result {
                    case .success(let response):
                        let userPreview = response.data.map { $0.toDomain() }
                        return single(.success(userPreview))
                        
                    case .failure(let error):
                        return single(.failure(error))
                    }
                }
            return Disposables.create {
                task?.cancel()
            }
        }
    }
    
    func fetchMyFollowing() -> Single<[EveryTipDomain.UserPreview]> {
        guard let request = try? UserTarget.getMyFollowing.asURLRequest() else {
            return Single.error(NetworkError.invalidURLError)
        }
        
        return Single.create { single in
            let task = session?.request(request, interceptor: interceptor)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: UserPreviewDTO.self) { response in
                    switch response.result {
                    case .success(let response):
                        let userPreview = response.data.map { $0.toDomain() }
                        return single(.success(userPreview))
                        
                    case .failure(let error):
                        return single(.failure(error))
                    }
                }
            return Disposables.create {
                task?.cancel()
            }
        }
    }
}
