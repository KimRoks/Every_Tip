//
//  TokenSessionDelegate.swift
//  EveryTipDomain
//
//  Created by 김경록 on 11/20/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

public protocol TokenSessionDelegate: AnyObject {
    func refreshTokenDidExpire(error: Error)
}
