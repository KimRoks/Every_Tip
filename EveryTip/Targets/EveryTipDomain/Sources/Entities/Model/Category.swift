//
//  Category.swift
//  EveryTipDomain
//
//  Created by 김경록 on 6/23/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

public struct Category: Equatable {
    public let id: Int
    public let name: String

    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
