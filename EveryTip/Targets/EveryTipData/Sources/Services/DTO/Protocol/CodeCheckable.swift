//
//  CodeCheckable.swift
//  EveryTipData
//
//  Created by 김경록 on 3/24/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

protocol CodeCheckable {
    var code: String? { get }
    func isSuccess() -> Bool
}

extension CodeCheckable {
    func isSuccess() -> Bool {
        return code == "SUCCESS"
    }
}
