//
//  DefaultExRepository.swift
//  EveryTipData
//
//  Created by 손대홍 on 6/7/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

import RxSwift

final class DefaultExRepository: ExRepository {
    // 네트워크 코드 추가
    func fetchUppercased(string: String, completion: @escaping (Result<ExModel, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            let resultModel = ExModel(text: string.uppercased())
            completion(.success(resultModel))
        }
    }
    
    func fetchUppercasedRx(string: String) -> Single<ExModel> {
        let resultModel = ExModel(text: string.uppercased())
        return Single<ExModel>.just(resultModel)
    }
}
