//
//  SearchHistoryCell.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/25/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import RxSwift

final class SearchHistoryCell: UITableViewCell, Reusable {
    
    let removeButtonTapped = PublishSubject<Void>()
    var disposeBag = DisposeBag()
    
    private let recentIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .et_getImage(for: .recent)
        
        return imageView
    }()
    
    private let keywordLabel: UILabel = {
        let label = UILabel()
        label.font = .et_pretendard(
            style: .medium,
            size: 16
        )
        label.textColor = .et_textColorBlack50
        
        return label
    }()
    
    private let removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.et_getImage(for: .closeButton), for: .normal)
        button.tintColor = .et_lineGray40
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubViews(
            recentIconImageView,
            keywordLabel,
            removeButton
        )
    }
    
    private func setupConstraints() {
        recentIconImageView.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading)
            $0.height.width.equalTo(16)
            $0.centerY.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(10)
        }
        
        keywordLabel.snp.makeConstraints {
            $0.leading.equalTo(recentIconImageView.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()

        }
        
        removeButton.snp.makeConstraints {
            $0.trailing.equalTo(contentView.snp.trailing)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(10)
        }
    }
    
    func configureCell(with keyword: String) {
        keywordLabel.text = keyword
        
    }
    
    private func bind() {
        removeButton.rx.tap
            .bind(to: removeButtonTapped)
            .disposed(by: disposeBag)
    }
}
