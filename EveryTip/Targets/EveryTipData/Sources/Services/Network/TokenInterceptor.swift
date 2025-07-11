//
//  TokenInterceptor.swift
//  EveryTipData
//
//  Created by 김경록 on 11/15/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain
import EveryTipCore

import Alamofire
import RxSwift


final class TokenInterceptor: RequestInterceptor, SessionInjectable {
    let session: Alamofire.Session? = .default
    var disposeBag = DisposeBag()
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var request = urlRequest
        if let accessToken = TokenKeyChainManager.shared.getToken(type: .access) {
            request.addValue(accessToken, forHTTPHeaderField: "Authorization")
        }
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        
        // 401 인증 오류가 아니면 재시도하지 않음
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401 else {
            print("리트라이에서 401이 아니라서 리트라이 진행하지 않음")
            completion(.doNotRetry)
            return
        }
        //401에러가 발생한 경우 리트라이 진행
        
        guard let currentRefreshToken = TokenKeyChainManager.shared.getToken(type: .refresh) else {
            return
        }
        
        renewToken(with: currentRefreshToken)
            .subscribe(onCompleted: {
                completion(.retryWithDelay(1))
            }, onError: { error in
                TokenKeyChainManager.shared.deleteToken(type: .access)
                TokenKeyChainManager.shared.deleteToken(type: .refresh)
                completion(.doNotRetryWithError(error))
            })
            .disposed(by: disposeBag)
    }

    private func renewToken(with currentRefreshToken: String) -> Completable {
        guard let request = try? AuthTarget.postRenewRefreshToken(currentToken: currentRefreshToken)
            .asURLRequest() else {
            return .error(NetworkError.invalidURLError)
        }

        return Completable.create { completable in
            let task = self.session?.request(request)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: RenewTokenDTO.self) { response in
                    switch response.result {
                    case .success(let dto):
                        let newAccessToken = dto.data.accessToken
                        let newRefreshToken = dto.data.refreshToken
                        
                        TokenKeyChainManager.shared.storeToken(newAccessToken, type: .access)
                        TokenKeyChainManager.shared.storeToken(newRefreshToken, type: .refresh)
                        
                        completable(.completed)
                        
                    case .failure(let error):
                        completable(.error(error))
                    }
                }

            return Disposables.create {
                task?.cancel()
            }
        }
    }
}
