//
//  Int+.swift
//  EveryTipDesignSystem
//
//  Created by 김경록 on 8/26/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

extension Int {
    /// 숫자가 일정 범위를 넘어가면 k,m,b 등의 단위로 단축시킵니다.
    public func toAbbreviatedString() -> String {
        switch self {
        case 1_000_000_000...:
            return String(format: "%.1fB", Double(self) / 1_000_000_000.0)
        case 1_000_000...:
            return String(format: "%.1fM", Double(self) / 1_000_000.0)
        case 1_000...:
            return String(format: "%.1fk", Double(self) / 1_000.0)
        default:
            return "\(self)"
        }
    }
}
