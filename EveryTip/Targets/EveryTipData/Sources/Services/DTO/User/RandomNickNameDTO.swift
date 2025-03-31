//
//  RandomNickNameDTO.swift
//  EveryTipData
//
//  Created by 김경록 on 3/31/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

struct RandomNickNameDTO: Decodable {
    let status: Int
    let code, message, data: String
}

extension RandomNickNameDTO {
    func toDomain() -> String {
        return data
    }
}
