//
//  AgreementsDTO.swift
//  EveryTipData
//
//  Created by 김경록 on 3/31/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain
public struct AgreementsDTO: Decodable {
    public let code: String
    public let message: String
    public let data: [Data]?
    
    public struct Data: Decodable {
        public let id: Int
        public let title: String
        public let webLinkURL: String
        public let mandatory: Int
        
        func toDomain() -> Agreements? {
            return Agreements(
                id: id,
                title: title,
                webLinkURL: webLinkURL,
                mandatory: mandatory
            )
        }
    }
}
