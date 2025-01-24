//
//  HomeSectionHeaderView.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 1/22/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import SnapKit

final class HomeSectionHeaderView: UITableViewHeaderFooterView, Reusable {
    
    private let headerTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.et_pretendard(style: .bold, size: 18)
        label.textColor = UIColor.et_textColorBlack90
        
        return label
    }()
    
    private let readMoreButton: UIButton = {
        let button = UIButton(type: .system)
        let textWithSpace = "더보기" + " "
        let symbol = NSTextAttachment(image: UIImage(systemName: "chevron.right")!)
        symbol.bounds = CGRect(x: 0, y: 0, width: 7, height: 10)
        
        let symbolString = NSAttributedString(attachment: symbol)
        
        let attributedString = NSMutableAttributedString(string: textWithSpace)
        attributedString.append(symbolString)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.et_textColorBlack10,
            .font: UIFont.et_pretendard(style: .bold, size: 14)
        ]
        
        attributedString.addAttributes(
            attributes,
            range: NSRange(location: 0, length: attributedString.length)
        )

        button.setAttributedTitle(attributedString, for: .normal)

        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(headerTitle)
        contentView.addSubview(readMoreButton)
    }
    
    private func setupConstraints() {
        headerTitle.snp.makeConstraints {
            $0.centerY.equalTo(contentView)
            $0.leading.equalTo(contentView).offset(20)
        }
        
        readMoreButton.snp.makeConstraints {
            $0.centerY.equalTo(contentView)
            $0.trailing.equalTo(contentView).offset(-20)
        }
    }
    
    func setTitleLabel(_ text: String) {
        headerTitle.text = text
    }
}

