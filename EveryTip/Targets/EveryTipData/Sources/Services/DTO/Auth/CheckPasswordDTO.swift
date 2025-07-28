//
//  CheckPasswordDTO.swift
//  EveryTipData
//
//  Created by 김경록 on 7/20/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

public struct CheckPasswordDTO: Codable {
    public let code: String
    public let message: String
    public let data: Bool
}
