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
        case tipEllipsisTapped
        case commnetEllipsisTapped(commentID: Int)
        case likeButtonTapped
        case commentLikeButtonTapped(commentID: Int)
        case tipSaveButtonTapped
        case userProfileTapped
        case imageSelected(Int)
    }
    
    enum Mutation {
        case setTip(Tip)
        case setComments([Comment])
        case setToast(String)
        case setCommentInput(message: String, parentID: Int?)
        case setPopSignal(Bool)
        case setCommentSignal(Bool)
        case setUserTappedSignal(Bool)
        case setSelectedImageIndex(Int)
    }
    
    struct State {
        var tip: Tip?
        var comment: [Comment]?
        var commentInput: (message: String, parentID: Int?) = ("", nil)
        @Pulse var commentSubmittedSignal: Bool = false
        @Pulse var toastMessage: String?
        @Pulse var popSignal: Bool = false
        @Pulse var userTappedSignal: Bool = false
        @Pulse var selectedImageIndex: Int?
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
                .asObservable()
                .flatMap { comments in
                    Observable.concat(
                        .just(.setComments(comments)),
                        .just(.setCommentSignal(true))
                    )
                }
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
            
            
        case .tipEllipsisTapped:
            return tipUseCase.deleteTip(for: tipID)
                .andThen(
                    Observable.concat(
                        .just(.setPopSignal(true))
                    )
                )
                .catch { _ in
                        .just(.setToast("팁을 삭제하는데 실패했어요"))
                }
            
        case .likeButtonTapped:
            return tipUseCase.likeTip(for: tipID)
                .andThen(
                    tipUseCase.fetchTip(forTipID: tipID).asObservable()
                )
                .map { Mutation.setTip($0) }
                .catch { _ in
                    return .just(.setToast("팁 좋아요를 실패했어요"))
                }
            
        case .commentLikeButtonTapped(commentID: let commentID):
            return commentUseCase.likeComment(for: commentID)
                .andThen(
                    commentUseCase.fetchComments(tipID: tipID).asObservable()
                )
                .compactMap { $0 }
                .map { Mutation.setComments($0) }
                .catch { _ in
                        .just(.setToast("댓글 좋아요를 실패했어요"))
                }
            
        case .tipSaveButtonTapped:
            return tipUseCase.saveTip(for: tipID)
                .andThen(
                    Observable.merge(
                        tipUseCase
                            .fetchTip(forTipID: tipID).map { Mutation.setTip($0) }
                            .asObservable(),
                        .just(
                            currentState.tip?.isSaved == true
                            ? .setToast("저장된 팁을 제거했어요")
                            : .setToast("팁을 저장했어요")
                        )
                    )
                )
                .catch { _ in
                        .just(.setToast("팁 저장에 실패했어요"))
                }
        case .userProfileTapped:
            return .just(.setUserTappedSignal(true))
        case .imageSelected(let index):
            return .just(.setSelectedImageIndex(index))
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
        case .setPopSignal(let signal):
            newState.popSignal = signal
        case .setCommentSignal(let signal):
            newState.commentSubmittedSignal = signal
        case .setUserTappedSignal(let signal):
            newState.userTappedSignal = signal
        case .setSelectedImageIndex(let index):
            newState.selectedImageIndex = index
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
