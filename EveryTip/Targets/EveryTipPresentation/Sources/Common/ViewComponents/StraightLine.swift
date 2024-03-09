//
//  StraightLine.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 3/9/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

final class StraightLine: UIView {
    init(color: UIColor) {
        super.init(frame: .zero)
        self.backgroundColor = color
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
 
    private func setupConstraints() {
        self.snp.makeConstraints{
            $0.height.equalTo(1)
        }
    }
}
