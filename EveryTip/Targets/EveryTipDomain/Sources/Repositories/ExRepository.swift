//
//  ExRepository.swift
//  EveryTipData
//
//  Created by 손대홍 on 6/7/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

import RxSwift

public struct ExModel: Codable {
    public init(text: String) {
        self.text = text
    }
    
    public let text: String
}

public protocol ExRepository {
    func fetchUppercased(string: String, completion: @escaping (Result<ExModel, Error>) -> Void)
    
    func fetchUppercasedRx(string: String) -> Single<ExModel>
}
