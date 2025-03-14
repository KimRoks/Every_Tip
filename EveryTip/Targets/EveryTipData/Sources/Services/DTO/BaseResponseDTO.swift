//
//  BaseResponseDTO.swift
//  EveryTipData
//
//  Created by 김경록 on 3/14/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

public struct BaseResponseDTO: Decodable {
    public let statusCode: Int
    public let code: String?
    public let message: String
    
    public init(statusCode: Int ,code: String? = nil, message: String) {
        self.statusCode = statusCode
        self.code = code
        self.message = message
    }
}
