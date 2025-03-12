//
//  VerificationCodeResponse.swift
//  EveryTipDomain
//
//  Created by 김경록 on 2/17/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

public struct VerificationCodeResponse: Decodable {
    public let code: String
    public let message: String
    
    public init(code: String, message: String) {
        self.code = code
        self.message = message
    }
}
