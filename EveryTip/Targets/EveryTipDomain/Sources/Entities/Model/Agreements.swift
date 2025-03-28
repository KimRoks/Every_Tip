//
//  Agreements.swift
//  EveryTipDomain
//
//  Created by 김경록 on 9/5/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

public struct Agreements: Decodable {
    public let code: String
    public let message: String
    public let data: [AgreementData]
}

public struct AgreementData: Decodable {
    public let id: Int
    public let title: String
    public let url: String
    public let mandatory: Int
}
