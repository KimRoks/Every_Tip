//
//  EmailDuplicationDTO.swift
//  EveryTipData
//
//  Created by 김경록 on 3/31/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

public struct EmailDuplicationDTO: Decodable {
    public let code: String
    public let message: String
    public let data: Data?
    
    public struct Data: Decodable {
        public let check: Bool
    }
}

extension EmailDuplicationDTO {
    func toDomain() -> Bool? {
        guard let data = data else { return nil }
        return data.check
    }
}
