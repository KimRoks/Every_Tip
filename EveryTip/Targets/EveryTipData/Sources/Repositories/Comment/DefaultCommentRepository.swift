//
//  DefaultCommentRepository.swift
//  EveryTipData
//
//  Created by 김경록 on 5/27/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import Alamofire
import RxSwift

import EveryTipDomain

struct DefaultCommentRepository: CommentRepository, SessionInjectable {
    
    var session: Session?
    
    init(session: Session? = .default) {
        self.session = session
    }
    
    private let interceptor = TokenInterceptor()
    
    func fetchComments(tipID: Int) -> Single<[Comment]?> {
        guard let request = try? CommentTarget.getComments(tipID: tipID).asURLRequest() else {
            return Single.error(NetworkError.invalidURLError)
        }
        
        return Single.create { single in
            let task = session?.request(request, interceptor: interceptor)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: CommentDTO.self) { response in
                    switch response.result {
                    case .success(let dto):
                        let domainComments = dto.data.comments.map { $0.toDomain() }
                        
                        return single(.success(domainComments))
                    case .failure(let error):
                        return single(.failure(error))
                    }
                }
            
            return Disposables.create {
                task?.cancel()
            }
        }
    }
    
    func postComment(content: String, tipID: Int, parentID: Int?) -> Completable {
        guard let request = try? CommentTarget.postComment(content: content, tipID: tipID, parentID: parentID).asURLRequest() else {
            return Completable.error(NetworkError.invalidURLError)
        }
        
        return Completable.create { completable in
            let task = session?.request(request, interceptor: interceptor)
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
    
    func deleteComment(commentId: Int) -> Completable {
        guard let request = try? CommentTarget.deleteComment(commentID: commentId).asURLRequest() else {
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
}
