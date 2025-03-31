//
//  AgreementsResponse.swift
//  EveryTipData
//
//  Created by 김경록 on 3/31/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

public struct AgreementsResponse: Decodable {
    public let code: String
    public let message: String
    public let data: [AgreementDTO]
}

public struct AgreementDTO: Decodable {
    public let id: Int
    public let title: String
    public let url: String
    public let mandatory: Int
}

extension AgreementDTO {
    func toDomain() -> Agreements {
        return Agreements(
            id: id,
            title: title,
            url: url,
            mandatory: mandatory
        )
    }
}
