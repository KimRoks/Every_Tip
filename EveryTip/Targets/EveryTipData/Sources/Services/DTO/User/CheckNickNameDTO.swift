//
//  CheckNickNameDTO.swift
//  EveryTipData
//
//  Created by 김경록 on 5/16/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

public struct NicknameCheckDTO: Decodable {
    public let code: String
    public let message: String
    public let data: DataClass

    public struct DataClass: Decodable {
        public let isRedundant: Bool

        enum CodingKeys: String, CodingKey {
            case isRedundant = "is_redundant"
        }

        public init(isRedundant: Bool) {
            self.isRedundant = isRedundant
        }
    }

    public init(code: String, message: String, data: DataClass) {
        self.code = code
        self.message = message
        self.data = data
    }
}
