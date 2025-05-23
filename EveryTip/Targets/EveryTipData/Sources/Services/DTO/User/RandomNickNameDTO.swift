//
//  RandomNickNameDTO.swift
//  EveryTipData
//
//  Created by 김경록 on 3/31/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

struct RandomNickNameDTO: Decodable {
    let code: String
    let message: String
    let data: String?
}

extension RandomNickNameDTO {
    func toDomain() -> String? {
        guard let data = data else { return nil }
        return data
    }
}
