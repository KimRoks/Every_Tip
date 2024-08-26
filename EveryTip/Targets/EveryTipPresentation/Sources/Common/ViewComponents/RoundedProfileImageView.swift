//
//  RoundedProfileImageView.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 8/26/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//
import UIKit

final class RoundedProfileImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.width / 2
    }
}
