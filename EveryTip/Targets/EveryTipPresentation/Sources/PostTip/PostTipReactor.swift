//
//  PostTipReactor.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/10/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

import ReactorKit
import RxSwift

final class PostTipReactor: Reactor {
    typealias Category = Constants.Category
    
    enum Action {
        case setCategoryButtonTapped(Category)
        case setTagButtonTapped([String])
        case addImageButtonTapped
        case savePhoto([SelectedPhoto])
        case confirmButtonTapped
        case titleChanged(String)
        case contentChanged(String)
    }
    
    enum Mutation {
        case setCategory(Category)
        case setTag([String])
        case setPhotos([SelectedPhoto])
        case setTitle(String)
        case setContent(String)
        
        case setToast(String)
        case setConfirmSignal(Bool)
        case setImageViewSignal(Bool)
    }
    
    struct State {
        var category: Category?
        var tags: [String]?
        var selectedPhotos: [SelectedPhoto] = []
        var title: String?
        var content: String?
        
        @Pulse var toastMessage: String?
        @Pulse var imageSignal: Bool = false
        @Pulse var confirmSignal: Bool = false
    }
    
    private let tipUseCase: TipUseCase
    
    var initialState: State = State()
    
    init(tipUseCase: TipUseCase) {
        self.tipUseCase = tipUseCase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setCategoryButtonTapped(let category):
            return .just(.setCategory(category))
            
        case .setTagButtonTapped(let tags):
            return .just(.setTag(tags))
            
        case .addImageButtonTapped:
            return .just(.setImageViewSignal(true))
            
        case .savePhoto(let photos):
            return .just(.setPhotos(photos))
            
        case .confirmButtonTapped:
            guard let category = currentState.category else {
                return .just(.setToast("카테고리를 선택해주세요"))
            }
            guard let tags = currentState.tags else {
                return .just(.setToast("태그를 하나 이상 입력해주세요"))
            }
            guard let title = currentState.title else {
                return .just(.setToast("제목을 입력해주세요"))
            }
            guard let content = currentState.content else {
                return .just(.setToast("본문을 입력해주세요"))
            }
            
            let photos = currentState.selectedPhotos
            
            let uploadImages: Single<[Tip.Image]> = {
                let uploadTasks = photos.enumerated().map { index, photo in
                    tipUseCase.getPresignedURL(categoryID: category.id, mimeType: photo.mimeType)
                        .flatMap { presignedURL in
                            self.tipUseCase.uploadImage(
                                to: presignedURL,
                                imageData: photo.originalData
                            )
                            .andThen(Single.just((
                                originalURL: presignedURL,
                                isThumbnail: index == 0 ? 1 : 0
                            )))
                        }
                }
                
                return Single.zip(uploadTasks)
                    .map { resultTuples in
                        resultTuples.map { tuple in
                            let baseURL = tuple.originalURL.components(separatedBy: "?").first ?? tuple.originalURL
                            return Tip.Image(
                                url: baseURL,
                                isThumbnail: tuple.isThumbnail
                            )
                        }
                    }
            }()
            
            let postTip = uploadImages
                .flatMapCompletable { uploadedImages in
                    return self.tipUseCase.postTip(
                        categoryID: category.id,
                        tags: tags,
                        title: title,
                        content: content,
                        images: uploadedImages
                    )
                }
            
            return postTip
                .andThen(Observable.concat(
                    .just(.setToast("팁 업로드 성공")),
                    .just(.setConfirmSignal(true)))
                )
                .catch { _ in
                    return .just(.setToast("팁 업로드에 실패했어요. 다시 시도해주세요."))
                }
            
        case .titleChanged(let title):
            return .just(.setTitle(title))
            
        case .contentChanged(let content):
            return .just(.setContent(content))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setCategory(let category):
            newState.category = category
        case .setTag(let tags):
            newState.tags = tags
        case .setImageViewSignal(let signal):
            newState.imageSignal = signal
        case .setPhotos(let photos):
            newState.selectedPhotos = photos
        case .setConfirmSignal(let signal):
            newState.confirmSignal = signal
        case .setToast(let message):
            newState.toastMessage = message
        case .setTitle(let title):
            newState.title = title
        case .setContent(let content):
            newState.content = content
        }
        return newState
    }
}
