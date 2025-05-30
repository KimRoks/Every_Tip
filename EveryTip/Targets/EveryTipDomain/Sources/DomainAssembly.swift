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
        
        container.register(AuthUseCase.self) { _ in
            DefaultAuthUseCase(
                verificationCodeRepository: container.resolve(VerificationCodeRepository.self)!,
                agreementsRepository: container.resolve(AgreementsRepository.self)!,
                accountRepository: container.resolve(AccountRepository.self)!
            )
        }
        
        container.register(UserUseCase.self) { _ in
            DefaultUserUseCase(
                profileRepository: container.resolve(ProfileRepository.self)!,
                nickNameRepository: container.resolve(NickNameRepository.self)!,
                categoryRepository: container.resolve(CategoryRepository.self)!
            )
        }
        
        container.register(TipUseCase.self) { _ in
            DefaultTipUseCase(tipRepository: container.resolve(TipRepository.self)!)
        }
        
        container.register(CommentUseCase.self) { _ in
            DefaultCommentUseCase(commentRepository: container.resolve(CommentRepository.self)!)
        }
    }
}
