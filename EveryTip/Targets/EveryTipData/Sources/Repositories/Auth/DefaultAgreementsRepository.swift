//
//  LoginAPI.swift
//  EveryTipData
//
//  Created by 김경록 on 9/5/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

import EveryTipDomain

public struct DefaultAgreementsRepository: AgreementsRepository, SessionInjectable {
    var session: Session?
    
    init(session: Session? = .default) {
        self.session = session
    }
    
    public func fetchAgreements() -> Single<[Agreements]> {
        guard let request = try? AuthTarget.getAgreements.asURLRequest() else {
            return Single.error(NetworkError.invalidURLError)
        }
        
        return Single.create { single in
            let task = self.session?.request(request, interceptor: nil)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: AgreementsDTO.self) { respose in
                    switch respose.result {
                    case .success(let agreementsDTO):
                        guard let agreements = agreementsDTO.toDomain() else {
                            return single(.failure(NetworkError.emptyResponseData))
                        }
                        return single(.success(agreements))
                        
                    case .failure(let error):
                        return single(.failure(error))
                    }
                }
            return Disposables.create { task?.cancel() }
        }
    }
}
