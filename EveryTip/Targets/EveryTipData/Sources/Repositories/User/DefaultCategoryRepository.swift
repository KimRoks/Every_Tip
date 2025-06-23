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
    
    // TODO: 현재 API에러로 6,7,8번은 설정되지않음에 주의
    
    func setMyCategories(categoryIDs: [Int]) -> Completable {
        return Completable.create { completable in
            guard let request = try? UserTarget.postSetCategory(categoryIDs: categoryIDs).asURLRequest() else {
                completable(.error(NetworkError.invalidURLError))
                return Disposables.create()
            }
            
            let task = self.session?.request(request, interceptor: interceptor)
                .validate(statusCode: 200..<300)
                .response { response in
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
    
    // TODO: 현재 API 오류로 categoryIDs를 바디에 담아야해서 정상 작동 불가함
    
    func fetchMyCategories(IDs: [Int]) -> Single<[EveryTipDomain.Category]> {
        guard let request = try? UserTarget.getMyCategories.asURLRequest() else {
            return Single.error(NetworkError.invalidURLError)
        }
        
        return Single.create { single in
            let task = session?.request(request, interceptor: interceptor)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: CategoryDTO.self) { response in
                    switch response.result {
                    case .success(let categoryDTO):
                        let categories = categoryDTO.data.map { $0.toDomain() }
                        return single(.success(categories))
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
