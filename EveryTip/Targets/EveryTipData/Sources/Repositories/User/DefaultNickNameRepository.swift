//
//  DefaultNickNameRepository.swift
//  EveryTipData
//
//  Created by 김경록 on 3/31/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

import Alamofire
import RxSwift

struct DefaultNickNameRepository: NickNameRepository, SessionInjectable {
    var session: Session?
    
    init(session: Session? = .default) {
        self.session = session
    }
    
    func fetchRandomNickName() -> Single<String> {
        guard let request = try? UserTarget.getRandomNickName.asURLRequest() else {
            return Single.error(NetworkError.invalidURLError)
        }
        return Single.create { single in
            let task = self.session?.request(request, interceptor: nil)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: RandomNickNameDTO.self) { response in
                    switch response.result {
                    case .success(let randomNickNameDTO):
                        guard let randomNickName = randomNickNameDTO.toDomain() else {
                            return single(.failure(NetworkError.emptyResponseData))
                        }
                        return single(.success(randomNickName))
                    case .failure(let error):
                        return single(.failure(error))
                    }
                }
            return Disposables.create { task?.cancel() }
        }
    }
    
    func isNicknameDuplicated(_ nickname: String) -> Single<Bool> {
        guard let request = try? UserTarget.getIsDuplicatedNickname(nickname).asURLRequest() else {
            return Single.error(NetworkError.invalidURLError)
        }
        
        return Single.create { single in
            
            let task = self.session?.request(request, interceptor: nil)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: NicknameCheckDTO.self) { response in
                    switch response.result {
                    case .success(let isDuplicated):
                        let isDubplicated = isDuplicated.data.isRedundant
                        
                        return single(.success(isDubplicated))
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
