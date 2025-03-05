//
//  DefaultVerificationCodeRepository.swift
//  EveryTipData
//
//  Created by 김경록 on 2/20/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

import RxSwift
import Alamofire

public struct DefaultVerificationCodeRepository: VerificationCodeRepository {
    private let session: Session
    
    public init(session: Session = .default) {
        self.session = session
    }
    
    public func requestCode(with email: String) -> RxSwift.Single<VerificationCodeResponse> {
        do {
            let request = try AuthTarget.postRequestVerificationCode(email: email).asURLRequest()
            
            return Single.create { single in
                self.session.request(request)
                    .responseDecodable(of: VerificationCodeResponse.self) { response in
                        
                        switch response.result {
                        case .success(let result):
                            // api 통신 자체는 성공했지만 Fail의 경우 처리(사용불가 이메일 등)
                            if result.code == "FAIL" {
                                print(NetworkError.invalidEmail.errorDescription ?? "")
                                single(.failure(NetworkError.invalidEmail))
                            }
                            single(.success(result))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    }
                return Disposables.create()
            }
        } catch {
            return Single.error(NetworkError.invalidURLError)
        }
    }
    
    public func checkCode(with code: String) -> RxSwift.Single<Data> {
        do {
            let request = try AuthTarget.getCheckVerificationCode(code: code).asURLRequest()
            
            return Single.create { single in
                
                self.session.request(request)
                    .validate(statusCode: 200..<300)
                    .response { response in
                        switch response.result {
                        case .success(let result):
                            guard let result = result else {
                                return
                            }
                            print(result)
                            single(.success(result))
                        case .failure(let error):
                            
                            single(.failure(error))
                        }
                    }
                return Disposables.create()
            }
        } catch {
            return Single.error(NetworkError.invalidURLError)
        }
    }
}
