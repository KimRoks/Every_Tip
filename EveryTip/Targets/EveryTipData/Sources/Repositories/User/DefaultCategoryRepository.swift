//
//  DefaultCategoryRepository.swift
//  EveryTipData
//
//  Created by 김경록 on 3/31/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import Alamofire
import RxSwift

import EveryTipDomain

struct DefaultCategoryRepository: CategoryRepository, SessionInjectable {
    var session: Session?
    private let interceptor: TokenInterceptor = TokenInterceptor()
    init(session: Session? = .default) {
        self.session = session
    }
    
    // TODO: API 완성되면 다듬기
    func setCategory(categoryIDs: [Int]) -> Completable {
        return Completable.create { completable in
            guard let request = try? UserTarget.postSetCategory(categoryIDs: categoryIDs).asURLRequest() else {
                completable(.error(NetworkError.invalidURLError))
                return Disposables.create()
            }
            
            let task = self.session?.request(request, interceptor: interceptor)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: BaseResponseDTO.self) { response in
                    switch response.result {
                    case .success:
                        return completable(.completed)
                    case .failure(let error):
                        return completable(.error(error))
                    }
                }
            
            return Disposables.create {
                task?.cancel()
            }
        }
    }
}
