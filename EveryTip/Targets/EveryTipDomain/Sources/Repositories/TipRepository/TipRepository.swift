//
//  TipRepository.swift
//  EveryTipDomain
//
//  Created by 김경록 on 5/19/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import RxSwift
public protocol TipRepository {
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
    func reportTip(with tipID: Int) -> Completable
}
