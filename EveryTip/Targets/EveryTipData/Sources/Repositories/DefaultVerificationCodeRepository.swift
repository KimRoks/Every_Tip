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
                    case .success(let result):
                        // 통신 자체는 성공했으나 이메일 사용 불가등의 경우로 API가 Code를 Fail로 반환하는 경우를 처리
                        if result.code == "FAIL" {
                            completable(.error(NetworkError.invalidEmail))
                        }
                        completable(.completed)
                    case .failure(let error):
                        completable(.error(error))
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
                        completable(.completed)
                    case .failure(let error):
                        completable(.error(error))
                    }
                }
            return Disposables.create { task?.cancel() }
            
        }
    }
}
