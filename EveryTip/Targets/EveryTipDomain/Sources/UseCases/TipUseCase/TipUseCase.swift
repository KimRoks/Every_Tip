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
    func fetchSavedTips() -> Single<[Tip]>
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
    
    func fetchTips(forUserID userID: Int) -> RxSwift.Single<[Tip]> {
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
    
    func fetchSavedTips() -> Single<[Tip]> {
        tipRepository.fetchSavedTips()
    }
}
