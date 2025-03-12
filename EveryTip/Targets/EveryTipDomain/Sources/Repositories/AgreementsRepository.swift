//
//  AgreementsRepository.swift
//  EveryTipDomain
//
//  Created by 김경록 on 9/5/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

import RxSwift

public protocol AgreementsRepository {
    func fetchAgreements()
}
