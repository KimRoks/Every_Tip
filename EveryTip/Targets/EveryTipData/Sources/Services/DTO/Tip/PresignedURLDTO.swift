//
//  PresignedUrlDTO.swift
//  EveryTipData
//
//  Created by 김경록 on 6/29/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

public struct PresignedUrlDTO: Codable {
    let code: String
    let message: String
    let data: Datum
    
    public struct Datum: Codable {
        let url: String
    }
}
