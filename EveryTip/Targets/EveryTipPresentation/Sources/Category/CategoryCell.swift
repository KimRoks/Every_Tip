//
//  CategoryTableViewCell.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/4/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDesignSystem

import SnapKit

final class CategoryCell: UITableViewCell, Reusable {

    private let categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.et_pretendard(
            style: .medium,
            size: 16
        )
        
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        setupLayout()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubViews(
            categoryImageView,
            categoryLabel
        )
    }

    private func setupConstraints() {
        categoryImageView.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(16)
            $0.leading.equalTo(contentView).offset(20)
            $0.bottom.equalTo(contentView).offset(-16)
            $0.width.equalTo(contentView).multipliedBy(0.1)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(10)
            $0.bottom.equalTo(contentView).offset(-10)
            $0.leading.equalTo(categoryImageView.snp.trailing).offset(11)
            $0.trailing.equalTo(contentView).offset(-10)
        }
    }
    
    func configure(image: UIImage?, title: String) {
        categoryImageView.image = image
        categoryLabel.text = title
    }
}
