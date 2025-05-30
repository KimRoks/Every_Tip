//
//  TipDetailReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 5/22/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

import RxSwift
import ReactorKit

final class TipDetailReactor: Reactor {
    enum Action {
        case viewDidLoad
        case commentSubmitTapped(content: String, parentID: Int?)
        case commnetEllipsisTapped(commentID: Int)
    }
    
    enum Mutation {
        case setTip(Tip)
        case setComments([Comment])
        case setToast(String)
        case setCommentInput(message: String, parentID: Int?)
    }
    
    struct State {
        var tip: Tip?
        var comment: [Comment]?
        var commentInput: (message: String, parentID: Int?) = ("", nil)
        @Pulse var toastMessage: String?
    }
    
    var initialState: State = State()
    
    private let tipUseCase: TipUseCase
    private let commentUseCase: CommentUseCase
    private var tipID: Int
    
    init(
        tipID:Int,
        tipUseCase: TipUseCase,
        commentUseCase: CommentUseCase
    ) {
        self.tipID = tipID
        self.tipUseCase = tipUseCase
        self.commentUseCase = commentUseCase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let tip = tipUseCase.fetchTip(forTipID: tipID)
                .asObservable()
                .map { return Mutation.setTip($0) }
                .catch { _ in
                    return Observable.just(.setToast("팁을 불러오는데 실패했어요"))
                }
            
            let comment = commentUseCase.fetchComments(tipID: tipID)
                .asObservable()
                .map { self.flatten(from: $0) }
                .map { Mutation.setComments($0) }
                .catch { error in
                    return Observable.just(.setToast("댓글을 불러오는데 실패했어요"))
                }
            
            return Observable.merge(
                tip,
                comment
            )
            
        
        case .commentSubmitTapped(content: let content, parentID: let parentID):
            return commentUseCase
                .postComment(
                    content: content,
                    tipID: tipID,
                    parentID: parentID
                )
                .andThen(commentUseCase.fetchComments(tipID: tipID))
                .map { self.flatten(from: $0) }
                .map {    
                    Mutation.setComments($0)
                }
                .asObservable()
                .catch { _ in
                    Observable.just(.setToast("댓글 작성에 실패했어요."))
                }
            
        case .commnetEllipsisTapped(commentID: let commentID):
            return commentUseCase.deleteComment(commentId: commentID)
                .andThen(
                    commentUseCase.fetchComments(tipID: tipID).asObservable()
                )
                .map { self.flatten(from: $0) }
                .flatMap { comments -> Observable<Mutation> in
                    return Observable.concat([
                        .just(.setToast("댓글이 삭제되었어요")),
                        .just(.setComments(comments))
                    ])
                }
                .catch { _ in .just(.setToast("댓글 삭제를 실패했어요")) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setTip(let tip):
            newState.tip = tip
        case .setToast(let message):
            newState.toastMessage = message
        case .setComments(let comments):
            newState.comment = comments
        case .setCommentInput(message: let message, parentID: let parentID):
            newState.commentInput = (message, parentID)
        }
        
        return newState
    }
    
    private func flatten(from commentArray: [Comment]?) -> [Comment] {
        var result: [Comment] = []
        guard let commentArray = commentArray else { return [] }
        for var comment in commentArray {
            comment.isReply = false
            result.append(comment)

            for var reply in comment.replies {
                reply.isReply = true
                result.append(reply)
            }
        }

        return result
    }
}
