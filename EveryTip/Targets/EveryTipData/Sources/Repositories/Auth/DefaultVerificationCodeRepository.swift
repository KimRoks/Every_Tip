//
//  DefaultVerificationCodeRepository.swift
//  EveryTipData
//
//  Created by 김경록 on 3/14/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

import Alamofire
import RxSwift

struct DefaultVerificationCodeRepository: VerificationCodeRepository {
    let session: Session?
    
    init(session: Session? = .default) {
        self.session = session
    }
    
    func requestCode(with email: String) -> Completable {
        Completable.create { completable in
            guard let request = try? AuthTarget.postVerificationEmail(email: email).asURLRequest() else {
                completable(.error(NetworkError.invalidURLError))
                return Disposables.create()
            }
            
            let task = self.session?.request(request, interceptor: nil)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: BaseResponseDTO.self) { response in
                    switch response.result {
                    case .success(let baseResponseDTO):
                        if baseResponseDTO.isSuccess() {
                            return completable(.completed)
                        } else {
                            return completable(.error(NetworkError.invalidEmail))
                        }
                    case .failure(let error):
                        return completable(.error(error))
                    }
                }
            return Disposables.create { task?.cancel() }
            
        }
    }
    
    func checkCode(with code: String) -> Completable {
        Completable.create { completable in
            
            guard let request = try? AuthTarget.getCheckVerificationCode(code: code).asURLRequest() else {
                completable(.error(NetworkError.invalidURLError))
                return Disposables.create()
            }
            
            let task = self.session?.request(request, interceptor: nil)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: BaseResponseDTO.self) { response in
                    switch response.result {
                    case .success(_):
                        return completable(.completed)
                    case .failure(let error):
                        return completable(.error(error))
                    }
                }
            return Disposables.create { task?.cancel() }
            
        }
    }
}
