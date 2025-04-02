//
//  DefaultAccountRepository.swift
//  EveryTipData
//
//  Created by 김경록 on 10/29/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

import Alamofire
import RxSwift

struct DefaultAccountRepository: AccountRepository, SessionInjectable{
    let session: Session?
    
    init(session: Session? = .default) {
        self.session = session
    }
    
    func signUp(
        with email: String,
        pasword: String,
        agreementIDs agreementIDs: [Int],
        nickName: String
    ) -> Single<Account> {
        guard let request = try? AuthTarget.postSignUp(
            email: email,
            password: pasword,
            agreementsIDs: agreementIDs,
            nickName: nickName
        ).asURLRequest() else { return Single.error(NetworkError.invalidURLError) }
        
        return Single.create { single in
            let task = self.session?.request(request, interceptor: nil)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: AccountResponse.self) { response in
                    switch response.result {
                    case .success(let accountResponse):
                        guard let entity = accountResponse.data?.toDomain() else { return }
                        return single(.success(entity))
                    case .failure(let error):
                        return single(.failure(error))
                    }
                }
            return Disposables.create{ task?.cancel() }
        }
    }
    
    func checkEmailDuplication(email: String) -> Completable {
        return Completable.create { completable in
            guard let request = try? AuthTarget.getCheckEmailDuplication(email: email).asURLRequest() else {
                completable(.error(NetworkError.invalidURLError))
                return Disposables.create()
            }
            
            let task = self.session?.request(request, interceptor: nil)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: EmailDuplicationDTO.self) { response in
                    switch response.result {
                    case .success(let duplicateDTO):
                        if duplicateDTO.check {
                            return completable(.completed)
                        } else {
                            return completable(.error(NetworkError.invalidEmail))
                        }
                        
                    case .failure(let error):
                        completable(.error(error))
                    }
                }
            
            return Disposables.create { task?.cancel() }
        }
    }
    
    func login(with email: String, password: String) -> Single<Account> {
        guard let request = try? AuthTarget.postUserLogin(
            email: email,
            password: password
        ).asURLRequest() else {
            return Single.error(NetworkError.invalidURLError)
        }
        
        return Single.create { single in
            let task = self.session?.request(request, interceptor: nil)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: AccountResponse.self) { response in
                    switch response.result {
                    case .success(let accountResponse):
                        guard let account = accountResponse.data?.toDomain() else { return }
                        single(.success(account))
                    case .failure(let error):
                        single(.failure(error))
                    }
                }
            return Disposables.create { task?.cancel() }
        }
    }
}
