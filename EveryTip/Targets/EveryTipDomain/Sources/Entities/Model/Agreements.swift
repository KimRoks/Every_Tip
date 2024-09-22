//
//  Agreements.swift
//  EveryTipDomain
//
//  Created by 김경록 on 9/5/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

// MARK: - DD
public struct Agreements: Codable {
    let status: Int
    let code, message: String
    let data: [Datum]
}

// MARK: - Datum
public struct Datum: Codable {
    let id: Int
    let title, url: String
    let mandatory: Bool
}
