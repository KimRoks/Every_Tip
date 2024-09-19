//
//  AgreementUseCase.swift
//  EveryTipDomain
//
//  Created by 김경록 on 9/15/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

import RxSwift

public protocol AgreementUseCase {
    func getAgreements()
}

final public class DefaultAgreementUseCase: AgreementUseCase {
    private let agreementsRepository: AgreementsRepository
    
    init(agreementsRepository: AgreementsRepository) {
        self.agreementsRepository = agreementsRepository
    }
    
    public func getAgreements() {
        return agreementsRepository.fetchAgreements()
    }
}
