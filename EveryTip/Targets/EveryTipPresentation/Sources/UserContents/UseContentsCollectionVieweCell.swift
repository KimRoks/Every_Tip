//
//  UseContentsCollectionVieweCell.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/20/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import SnapKit

final class UseContentsCollectionVieweCell: UICollectionViewCell, Reusable {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .et_pretendard(
            style: .bold,
            size: 16
        )
        
        return label
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
        contentView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(16)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-15)
            $0.centerX.equalTo(contentView)
        }
    }
    
    func setupTitle(_ title: String, isSelected: Bool) {
        titleLabel.text = title
        titleLabel.textColor = isSelected ? .et_textColorBlack90 : .et_textColorBlack10
    }
}
