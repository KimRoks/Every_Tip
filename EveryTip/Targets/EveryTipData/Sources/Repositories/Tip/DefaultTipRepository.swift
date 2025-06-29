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
    
    func fetchTip(forTipID tipID: Int) -> Single<Tip> {
        guard let request = try? TipTarget.fetchTipByTipID(tipID).asURLRequest() else {
            return Single.error(NetworkError.invalidURLError)
        }
        
        return Single.create { single in
            let task = session?.request(request, interceptor: interceptor)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: TipDTO.self) { response in
                    switch response.result {
                    case .success(let tipDTO):
                        guard let tip = tipDTO.data.tips.first?.toDomain() else { return }
                        return single(.success(tip))
                    case .failure(let error):
                        return single(.failure(error))
                    }
                }
            return Disposables.create {
                task?.cancel()
            }
        }
    }
    
    func fetchTips(forUserID userID: Int) -> RxSwift.Single<[EveryTipDomain.Tip]> {
        guard let request = try? TipTarget.fetchTipByUserID(userID).asURLRequest() else {
            return Single.error(NetworkError.invalidURLError)
        }
        
        return Single.create { single in
            let task = session?.request(request)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: TipDTO.self) { response in
                    switch response.result {
                        
                    case .success(let tipDTO):
                        let tips = tipDTO.data.tips.map { $0.toDomain() }
                        return single(.success(tips))
                    case .failure(let error):
                        return single(.failure(error))
                    }
                }
            
            return Disposables.create {
                task?.cancel()
            }
        }
    }
    
    func deleteTip(for tipID: Int) -> Completable {
        guard let request = try? TipTarget.deleteTip(tipID: tipID).asURLRequest() else{ return Completable.error(NetworkError.invalidURLError)}
        return Completable.create { completable in
            let task = session?.request(request, interceptor: interceptor)
                .validate(statusCode: 200..<300)
                .response { response in
                    switch response.result {
                    case .success(_):
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
    
    func likeTip(for tipID: Int) -> Completable {
        guard let request = try? TipTarget.postLikeTip(tipID: tipID).asURLRequest() else {
            return Completable.error(NetworkError.invalidURLError)
        }
        
        return Completable.create { completable in
            let task = session?.request(request, interceptor: interceptor)
                .validate(statusCode: 200..<300)
                .response { response in
                    switch response.result {
                    case .success(_):
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
    
    func saveTip(for tipID: Int) -> Completable {
        guard let request = try? TipTarget.postSaveTip(tipID: tipID).asURLRequest() else {
            return Completable.error(NetworkError.invalidURLError)
        }
        
        return Completable.create { completable in
            let task = session?.request(request, interceptor: interceptor)
                .validate(statusCode: 200..<300)
                .response { response in
                    switch response.result {
                    case .success(_):
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
    
    // TODO: DTO 바꿔야할수있음 서버랑 협의 중
    func fetchSavedTips() -> Single<[Tip]> {
        guard let request = try? TipTarget.getSavedTips.asURLRequest() else {
            return Single.error(NetworkError.invalidURLError)
        }
        
        return Single.create { single in
            let task = session?.request(request, interceptor: interceptor)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: SavedTipDTO.self) { response in
                    switch response.result {
                    case .success(let tipData):
                        let tips = tipData.data.map { $0.toDomain() }
                        
                        return single(.success(tips))
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                        return single(.failure(error))
                    }
                }
            
            return Disposables.create {
                task?.cancel()
            }
        }
    }
    
    func searchTip(with keyword: String) -> Single<[EveryTipDomain.Tip]> {
        guard let request = try? TipTarget.getSearchTips(keyword: keyword).asURLRequest() else {
            return Single.error(NetworkError.invalidURLError)
        }
        
        return Single.create { single in
            let task = session?.request(request)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: TipDTO.self) { response in
                    switch response.result {
                    case .success(let tipDTO):
                        let tips = tipDTO.data.tips.map { $0.toDomain() }
                        
                        return single(.success(tips))
                    case .failure(let error):
                        return single(.failure(error))
                    }
                }
            return Disposables.create {
                task?.cancel()
            }
        }
    }
    
    func fetchPresignedURL(categoryID: Int, fileType: String) -> Single<String> {
        guard let request = try? TipTarget.postPresignedURL(
            categoryID: categoryID,
            fileType: fileType
        ).asURLRequest() else {
            return Single.error(NetworkError.invalidURLError)
        }
        
        return Single.create { single in
            
            let task = session?.request(request, interceptor: interceptor)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: PresignedUrlDTO.self) { response in
                    switch response.result {
                    case .success(let response):
                        let url = response.data.url
                        return single(.success(url))
                        
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
