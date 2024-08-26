//
//  RoundedBackGroundView.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 8/26/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

final class RoundedBackGroundView: UIView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.layer.cornerRadius = 15
        self.backgroundColor = .white
        self.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
