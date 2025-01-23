//
//  HomeSectionFooterView.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 1/22/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import SnapKit

final class HomeSectionFooterView: UIView {
    private let colorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.et_lineGray20
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.addSubViews(colorView)
    }
    
    private func setupConstraints() {
        colorView.snp.makeConstraints {
            $0.leading.trailing.equalTo(self)
            $0.height.equalTo(8)
            $0.centerY.equalTo(self)
        }
    }
}
