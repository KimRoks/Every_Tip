//
//  TagCollectionViewCell.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 5/22/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import SnapKit

final class TagCollectionViewCell: UICollectionViewCell, Reusable {
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.font = .et_pretendard(style: .bold, size: 12)
        label.textColor = .et_textColor5
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        setupLayout()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        contentView.layer.borderColor = UIColor.et_lineGray30.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
    }
    
    private func setupLayout() {
        contentView.addSubview(tagLabel)
    }
    
    private func setupConstraints() {
        tagLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(contentView).inset(6)
            $0.leading.trailing.equalTo(contentView).inset(12)
        }
    }
    
    func updateTag(_ text: String) {
        tagLabel.text = "\(text)"
    }
}
