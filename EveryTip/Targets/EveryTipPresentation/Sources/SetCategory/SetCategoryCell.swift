//
//  SetCategoryCell.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/20/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

final class SetCategoryCell: UITableViewCell, Reusable {
    
    private let borderView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.et_lineGray40.cgColor
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .et_pretendard(style: .medium, size: 16)
        
        return label
    }()
    
    private let checkMarkImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupLayout()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(
            borderView
        )
        
        borderView.addSubViews(
            iconImageView,
            titleLabel,
            checkMarkImageView
        )
    }
    
    private func setupConstraints() {
        borderView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(5)
        }
        
        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.leading.equalTo(borderView.snp.leading).offset(20)
            $0.top.bottom.equalTo(borderView).inset(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(12)
            $0.centerY.equalTo(borderView)
        }
        
        checkMarkImageView.snp.makeConstraints {
            $0.trailing.equalTo(borderView.snp.trailing).offset(-20)
            $0.top.bottom.equalTo(borderView).inset(23)
        }
    }
    
    func configureCell(with item: Constants.Category, isSelected: Bool) {
        iconImageView.image = item.image
        titleLabel.text = item.title
        
        let borderColor: UIColor = isSelected ? .et_brandColor2  : .et_lineGray40
        let backgroundColor = isSelected ? UIColor(hex: "#E0FAEC") : .white
        
        borderView.layer.borderColor = borderColor.cgColor
        borderView.backgroundColor = backgroundColor
        
        let checkMark: UIImage = isSelected ? .et_getImage(for: .checkedMark_circle) : .et_getImage(for: .checkMark_circle)
        
        checkMarkImageView.image = checkMark
    }
}
