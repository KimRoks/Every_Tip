//
//  LoginAPI.swift
//  EveryTipData
//
//  Created by 김경록 on 9/5/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

import EveryTipDomain

public struct DefaultAgreementsRepository: AgreementsRepository  {
    public func fetchAgreements() {
        do {
            let requset = try AuthTarget.getAgreements.asURLRequest()
    
            AF.request(requset)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: EveryTipDomain.Agreements.self) { response in
                    switch response.result {
                    case .success(let agreements):
                        print(agreements)
                    case .failure(let error):
                        print(NetworkError.sessionError(error))
                    }
                }
        } catch {
            print(NetworkError.invalidURLError)
        }
    }
}
