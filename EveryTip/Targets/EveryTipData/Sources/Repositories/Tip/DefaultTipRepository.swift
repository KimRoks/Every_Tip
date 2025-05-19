//
//  DefaultTipRepository.swift
//  EveryTipData
//
//  Created by 김경록 on 5/19/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

import Alamofire
import RxSwift

struct DefaultTipRepository: TipRepository, SessionInjectable {
    var session: Session?
    private let interceptor = TokenInterceptor()
    
    init(session: Session? = .default) {
        self.session = session
    }
    
    func fetchTotalTips() -> Single<[Tip]> {
        guard let requset = try? TipTarget.fetchTotalTip.asURLRequest() else {
            return Single.error(NetworkError.invalidURLError)
        }
        
        return Single.create { single in
            let task = session?.request(requset, interceptor: interceptor)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: TipDTO.self) { response in
                    switch response.result {
                    case .success(let tipDTO):
                        let tipArr = tipDTO.data.tips.map { $0.toDomain() }
                        
                        return single(.success(tipArr))
                    case .failure(let error):
                        return single(.failure(error))
                    }
                }
            return Disposables.create { task?.cancel() }
        }
    }
}
