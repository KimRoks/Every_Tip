//
//  Reuseable.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/24/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
