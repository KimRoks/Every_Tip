//
//  PresignedURLDTO.swift
//  EveryTipData
//
//  Created by 김경록 on 6/17/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

struct PresignedURLDTO: Codable {
    let code: String
    let message: String
    let data: URLData?

    struct URLData: Codable {
        let url: String
    }
}
