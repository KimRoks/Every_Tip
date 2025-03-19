//
//  RecentCell.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 3/19/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import SnapKit

final class RecentCell: UITableViewCell, Reusable {
    
    private let clockImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .et_getImage(for: .clock)
        
        return imageView
    }()
    
    private let searchedLabel: UILabel = {
        let label = UILabel()
        label.font = .et_pretendard(style: .medium, size: 16)
        label.textColor = .et_textColorBlack50
        
        return label
    }()
    
    private let removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.et_getImage(for: .x), for: .normal)
        button.tintColor = .et_lineGray40
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier:  reuseIdentifier)
        setupLayout()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubViews(
            clockImage,
            searchedLabel,
            removeButton
        )
    }
    
    private func setupConstraints() {
       
        clockImage.snp.makeConstraints {
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.leading.equalTo(contentView.snp.leading).offset(20)
        }
        
        searchedLabel.snp.makeConstraints {
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.leading.equalTo(clockImage.snp.trailing).offset(16)
            $0.top.bottom.equalTo(contentView).inset(10)
        }
        
        removeButton.snp.makeConstraints {
            $0.trailing.equalTo(contentView.snp.trailing).offset(-20)
            $0.centerY.equalTo(contentView.snp.centerY)
        }
        
    }
    
    func configureCell(text: String) {
        searchedLabel.text = text
    }
    
    
    
    
    
}
