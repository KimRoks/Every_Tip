//
//  SuggestInterestView.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 1/22/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import SnapKit

final class SuggestInterestView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "맞춤 관심 팁을 모아보고싶다면?"
        label.font = UIFont.et_pretendard(
            style: .semiBold,
            size: 16
        )
        
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "아래 관심사 설정을 해주시면 맞춤 설정된\n 관심 팁을 보여드립니다"
        label.font = UIFont.et_pretendard(
            style: .semiBold,
            size: 16
        )
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = UIColor(hex: "#333333")
        
        return label
    }()
    
    private let categoryImageView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    let moveToSetInterestButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("관심사 설정하러 가기", for: .normal)
        button.titleLabel?.font = UIFont.et_pretendard(style: .bold, size: 16)
        button.backgroundColor = UIColor.et_textColorBlack30
        button.tintColor = .white
        button.layer.cornerRadius = 12
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.et_lineGray20
        self.layer.cornerRadius = 10
        
        setupLayout()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.addSubViews(
            titleLabel,
            subTitleLabel,
            categoryImageView,
            moveToSetInterestButton
        )
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(20)
            $0.centerX.equalTo(self.snp.centerX)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalTo(self.snp.centerX)
        }
        
        categoryImageView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(self).inset(20)
            $0.height.equalTo(self.snp.height).multipliedBy(0.136)
        }
        
        moveToSetInterestButton.snp.makeConstraints{
            $0.top.equalTo(categoryImageView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(self).inset(18)
            $0.height.equalTo(self.snp.height).multipliedBy(0.21)
            $0.bottomMargin.equalTo(self.snp.bottom).offset(-18)
        }
    }
}
