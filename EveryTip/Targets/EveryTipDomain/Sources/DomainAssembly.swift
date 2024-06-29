//
//  DomainAssembly.swift
//  EveryTipDomain
//
//  Created by 손대홍 on 6/7/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

import Swinject

public struct DomainAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        container.register(ExUseCase.self) { _ in
            return DefaultExUseCase(exRepository: container.resolve(ExRepository.self)!)
        }
        container.register(PostListUseCase.self) { _ in
            return DefaultPostListUseCase(postRepository: container.resolve(PostRepository.self)!)
        }
    }
}
