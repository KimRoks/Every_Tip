//
//  TipUseCase.swift
//  EveryTipDomain
//
//  Created by 김경록 on 5/19/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import RxSwift
public protocol TipUseCase {
    func fetchTotalTips() -> Single<[Tip]>
    func fetchTip(forTipID tipID: Int) -> Single<Tip>
    func fetchTips(forUserID userID: Int) -> Single<[Tip]>
    func likeTip(for tipID: Int) -> Completable
    func saveTip(for tipID: Int) -> Completable
    func deleteTip(for tipID: Int) -> Completable
    
    func getPresignedURL(
        categoryID: Int,
        mimeType: String
    ) -> Single<String>
    
    func uploadImage(
        to url: String,
        imageData: Data
    ) -> Completable
    
    func postTip(
        categoryID: Int,
        tags: [String],
        title: String,
        content: String,
        images: [Tip.Image]
    ) -> Completable
    
    func fetchSavedTips() -> Single<[Tip]>
    func searchTip(with keyword: String) -> Single<[Tip]>
}
final class DefaultTipUseCase: TipUseCase {
    private let tipRepository: TipRepository

    init(tipRepository: TipRepository) {
        self.tipRepository = tipRepository
    }

    func fetchTotalTips() -> Single<[Tip]> {
        tipRepository.fetchTotalTips()
    }

    func fetchTip(forTipID tipID: Int) -> Single<Tip> {
        tipRepository.fetchTip(forTipID: tipID)
    }

    func fetchTips(forUserID userID: Int) -> Single<[Tip]> {
        tipRepository.fetchTips(forUserID: userID)
    }

    func likeTip(for tipID: Int) -> Completable {
        tipRepository.likeTip(for: tipID)
    }

    func saveTip(for tipID: Int) -> Completable {
        tipRepository.saveTip(for: tipID)
    }

    func deleteTip(for tipID: Int) -> Completable {
        tipRepository.deleteTip(for: tipID)
    }

    func getPresignedURL(categoryID: Int, mimeType: String) -> Single<String> {
        tipRepository.getPresignedURL(categoryID: categoryID, mimeType: mimeType)
    }

    func uploadImage(to url: String, imageData: Data) -> Completable {
        tipRepository.uploadImage(to: url, imageData: imageData)
    }

    func postTip(
        categoryID: Int,
        tags: [String],
        title: String,
        content: String,
        images: [Tip.Image]
    ) -> Completable {
        tipRepository.postTip(
            categoryID: categoryID,
            tags: tags,
            title: title,
            content: content,
            images: images
        )
    }

    func fetchSavedTips() -> Single<[Tip]> {
        tipRepository.fetchSavedTips()
    }

    func searchTip(with keyword: String) -> Single<[Tip]> {
        tipRepository.searchTip(with: keyword)
    }
}
