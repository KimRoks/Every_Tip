//
//  RoundedButton.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 3/9/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

final class RoundedButton: UIButton {
    init(cornerRadius: CGFloat, backgroundColor: UIColor, image: UIImage?) {
        super.init(frame: .zero)
        self.layer.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.setImage(image, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
