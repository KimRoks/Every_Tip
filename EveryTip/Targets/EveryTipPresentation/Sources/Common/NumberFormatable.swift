//
//  NumberFormatterble.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 8/13/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

public protocol NumberFormatable {
    func formatNumber(_ number: Int?) -> String
}

extension NumberFormatable {
    func formatNumber(_ number: Int?) -> String {
        guard let number = number else { return "0" }

        switch number {
        case 1_000_000_000...:
            return String(format: "%.1fB", Double(number) / 1_000_000_000.0)
        case 1_000_000...:
            return String(format: "%.1fM", Double(number) / 1_000_000.0)
        case 1_000...:
            return String(format: "%.1fk", Double(number) / 1_000.0)
        default:
            return "\(number)"
        }
    }
}
