//
//  InterestSuggestFooterView.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 1/22/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import SnapKit

protocol FooterDelegate: AnyObject {
    func buttonTapped()
}

final class InterestSuggestFooterView: UITableViewHeaderFooterView {
    weak var delegate: FooterDelegate?
    
    private let roundedBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor(hex: "#F6F6F6")
        
        return view
    }()
    
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

    private let categoryImageStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.spacing = 20
        stackview.distribution = .equalSpacing
        
        return stackview
    }()

    let interestsSetupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("관심사 설정하러 가기", for: .normal)
        button.titleLabel?.font = UIFont.et_pretendard(style: .bold, size: 16)
        button.backgroundColor = UIColor.et_textColorBlack30
        button.tintColor = .white
        button.layer.cornerRadius = 12
        
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setStackView()
        setupLayout()
        setupConstraints()
        interestsSetupButton.addTarget(
            self,
            action: #selector(interestsSetupButtonTapped),
            for: .touchUpInside
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func interestsSetupButtonTapped() {
        delegate?.buttonTapped()
    }
    
    private func setStackView() {
        let interestImages = Constants.Category.interestSuggestItems
        for item in interestImages {
            let imageView = UIImageView()
            imageView.image = item.image
            
            if [.it, .finance, .games].contains(item) {
                imageView.alpha = 0.3
            }
            
            categoryImageStackView.addArrangedSubview(imageView)
        }
    }
    
    private func setupLayout() {
        contentView.addSubViews(
            roundedBackgroundView
        )
        
        roundedBackgroundView.addSubViews(
            titleLabel,
            subTitleLabel,
            categoryImageStackView,
            interestsSetupButton
        )
    }

    private func setupConstraints() {
        roundedBackgroundView.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(20)
            $0.leading.equalTo(contentView.snp.leading).offset(20)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-20)
            $0.bottom.equalTo(contentView).offset(-20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(roundedBackgroundView.snp.top).offset(20)
            $0.centerX.equalTo(roundedBackgroundView.snp.centerX)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalTo(roundedBackgroundView.snp.centerX)
        }
    
        categoryImageStackView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(20)
            $0.leading.equalTo(roundedBackgroundView).offset(27)
            $0.trailing.equalTo(roundedBackgroundView).offset(-27)
        }
        
        interestsSetupButton.snp.makeConstraints {
            $0.top.equalTo(categoryImageStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(roundedBackgroundView).inset(18)
            $0.height.equalTo(roundedBackgroundView.snp.height).multipliedBy(0.21)
        }
    }
}
