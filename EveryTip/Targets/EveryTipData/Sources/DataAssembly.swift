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
        
        container.register(AccountRepository.self) { _ in
            return DefaultAccountRepository()
        }
        
        container.register(AgreementsRepository.self) { _ in
            return DefaultAgreementsRepository()
        }
        
        container.register(VerificationCodeRepository.self) { _ in
            return DefaultVerificationCodeRepository()
        }
        
        container.register(NickNameRepository.self) { _ in
            return DefaultNickNameRepository()
        }
        
        container.register(CategoryRepository.self) { _ in
            return DefaultCategoryRepository()
        }
        
        container.register(ProfileRepository.self) { _ in
            return DefaultProfileRepository()
        }
        
        container.register(TipRepository.self) { _ in
            return DefaultTipRepository()
        }
        
        container.register(CommentRepository.self) { _ in
            return DefaultCommentRepository()
        }
        
        container.register(UserFollowRepository.self) { _ in
            return DefaultUserFollowRepository()
        }
    }
}
