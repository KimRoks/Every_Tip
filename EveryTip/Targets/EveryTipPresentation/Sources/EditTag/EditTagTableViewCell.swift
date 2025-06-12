//
//  EditTagTableViewCell.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/10/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import SnapKit

final class EditTagTableViewCell: UITableViewCell, Reusable {
    var onRemoveButtonTapped: (() -> Void)?
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.font = .et_pretendard(style: .medium, size: 16)
        label.textColor = .et_textColorBlack50
        
        return label
    }()
    
    private let removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("지우기", for: .normal)
        button.tintColor = .et_textColor5
        button.titleLabel?.font = .et_pretendard(style: .medium, size: 14)
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupConstraints()
        removeButton.addTarget(
            self,
            action: #selector(setRemoveButtonAction),
            for: .touchUpInside
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubViews(
            tagLabel,
            removeButton
        )
    }
    
    private func setupConstraints() {
        tagLabel.snp.makeConstraints {
            $0.top.bottom.leading.equalTo(contentView)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-40)
        }
        
        removeButton.snp.makeConstraints {
            $0.top.bottom.trailing.equalTo(contentView)
        }
    }
    
    @objc
    private func setRemoveButtonAction() {
        onRemoveButtonTapped?()
    }
    
    func updateTagLabel(_ tag: String) {
        tagLabel.text = tag
    }
}

