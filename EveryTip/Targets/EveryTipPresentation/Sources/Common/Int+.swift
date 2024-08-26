//
//  Int+.swift
//  EveryTipDesignSystem
//
//  Created by 김경록 on 8/26/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

extension Int {
    public func formatNumber() -> String {
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
