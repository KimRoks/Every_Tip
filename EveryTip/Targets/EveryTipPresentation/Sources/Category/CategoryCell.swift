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

    private let categoryImageBackgroundView: UIView = {
        let view = UIView()

        return view
    }()

    private let categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
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
    
    override func layoutSubviews() {
        categoryImageBackgroundView.makeCircular()
    }

    private func setupLayout() {
        categoryImageBackgroundView.addSubview(categoryImageView)
        contentView.addSubview(categoryImageBackgroundView)

        contentView.addSubview(categoryLabel)
    }

    private func setupConstraints() {
        categoryImageBackgroundView.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(15)
            $0.leading.equalTo(contentView).offset(10)
            $0.bottom.lessThanOrEqualTo(contentView).offset(-10)
            $0.width.equalTo(contentView).multipliedBy(0.1)
            $0.height.equalTo(categoryImageBackgroundView.snp.width)
        }

        categoryImageView.snp.makeConstraints {
            $0.edges.equalTo(categoryImageBackgroundView).inset(6)
        }

        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(10)
            $0.bottom.equalTo(contentView).offset(-10)
            $0.leading.equalTo(categoryImageBackgroundView.snp.trailing).offset(10)
            $0.trailing.equalTo(contentView).offset(-10)
        }
    }

    func configure(image: UIImage?, color: UIColor ,title: String) {
        categoryImageView.image = image
        categoryImageBackgroundView.backgroundColor = color
        categoryLabel.text = title
    }
}
