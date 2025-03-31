//
//  BaseResponseDTO.swift
//  EveryTipData
//
//  Created by 김경록 on 3/14/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

public struct BaseResponseDTO: Decodable, CodeCheckable {
    public let code: String?
    public let message: String
    
    public init(code: String? = nil, message: String) {
        self.code = code
        self.message = message
    }
}
