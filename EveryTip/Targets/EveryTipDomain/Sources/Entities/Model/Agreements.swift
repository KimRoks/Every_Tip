//
//  Agreements.swift
//  EveryTipDomain
//
//  Created by 김경록 on 9/5/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

public struct Agreements: Identifiable {
    public let id: Int
    public let title: String
    public let webLinkURL: String
    public let mandatory: Int
    
    public init(
        id: Int,
        title: String,
        webLinkURL: String,
        mandatory: Int
    ) {
        self.id = id
        self.title = title
        self.webLinkURL = webLinkURL
        self.mandatory = mandatory
    }
}
