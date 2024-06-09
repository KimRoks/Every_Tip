//
//  NetworkError.swift
//  EveryTip
//
//  Created by 손대홍 on 6/7/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

// 에러 정의 필요
enum NetworkError: LocalizedError {
    case invalid
    
    var errorDescription: String? {
        switch self {
        case .invalid:
            return "유효하지 않은 요청 또는 응답이에요"
        }
    }
}
