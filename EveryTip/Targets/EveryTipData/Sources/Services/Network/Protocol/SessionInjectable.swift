//
//  SessionInjectable.swift
//  EveryTipData
//
//  Created by 김경록 on 3/31/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import Alamofire

protocol SessionInjectable {
    var session: Session? { get }
}
