//
//  DataAssembly.swift
//  EveryTipData
//
//  Created by 손대홍 on 6/7/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import EveryTipDomain

import Foundation

import Swinject

public struct DataAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        container.register(ExRepository.self) { _ in
            return DefaultExRepository()
        }
    }
}
