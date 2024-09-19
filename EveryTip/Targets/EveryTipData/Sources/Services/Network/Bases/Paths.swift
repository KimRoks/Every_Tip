//
//  Paths.swift
//  EveryTipData
//
//  Created by 김경록 on 9/19/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

enum Paths: CustomStringConvertible {
    case agreements
    case requestEmail
    
    var description: String {
        switch self {
        case .agreements:
            return "/auth/agreements"
        case .requestEmail:
            return "/auth/verification/email"
        }
    }
}
