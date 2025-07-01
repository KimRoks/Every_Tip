//
//  CategoryDTO.swift
//  EveryTipDomain
//
//  Created by 김경록 on 6/23/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

public struct CategoryDTO: Codable {
    public let code: String
    public let message: String
    public let data: [Datum]

    public struct Datum: Codable {
        public let id: Int
        public let name: String
    }
}

extension CategoryDTO.Datum {
    public func toDomain() -> EveryTipDomain.Category {
        return Category(id: id, name: name)
    }
}
