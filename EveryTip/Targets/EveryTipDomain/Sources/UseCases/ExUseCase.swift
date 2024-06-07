//
//  ExUseCase.swift
//  EveryTipData
//
//  Created by 손대홍 on 6/7/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

import RxSwift

public protocol ExUseCase {
    func fetchUppercased(string: String, completion: @escaping (Result<ExModel, Error>) -> Void)
    
    func fetchUppercasedRx(string: String) -> Single<ExModel>
}

final class DefaultExUseCase: ExUseCase {
    private let exRepository: ExRepository
    
    init(exRepository: ExRepository) {
        self.exRepository = exRepository
    }
    
    func fetchUppercased(string: String, completion: @escaping (Result<ExModel, Error>) -> Void) {
        exRepository.fetchUppercased(string: string) { result in
            completion(result)
        }
    }
    
    func fetchUppercasedRx(string: String) -> Single<ExModel> {
        return exRepository.fetchUppercasedRx(string: string)
    }
}
