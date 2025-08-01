//
//  StoryCollectionViewCell.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 11/29/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDesignSystem

import SnapKit
import ReactorKit
import Kingfisher

final class StoryCollectionViewCell: UICollectionViewCell, Reusable {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(hex: "#EEEEEE")
        imageView.layer.cornerRadius = 30
        
        return imageView
    }()
    
    // TODO: 알파 값 추후 세밀하게 설정
    
    private let selectedOverlayView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.et_brandColor2.cgColor
        view.backgroundColor = UIColor.et_brandColor2.withAlphaComponent(0.2)
        view.layer.cornerRadius = 30
    
        view.isHidden = true
    
        return view
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.et_pretendard(
            style: .bold,
            size: 14
        )
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setuplayout()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        profileImageView.clipsToBounds = false
    }
    
    private func setuplayout() {
        self.backgroundColor = .white
        contentView.addSubViews(
            profileImageView,
            selectedOverlayView,
            userNameLabel
        )
    }
    
    private func setupConstraints() {
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(10)
            $0.centerX.equalTo(contentView.snp.centerX)
            $0.width.height.equalTo(60)
        }
        
        selectedOverlayView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(10)
            $0.centerX.equalTo(contentView.snp.centerX)
            $0.width.height.equalTo(60)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(contentView).inset(5)
            $0.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    func setSelected(_ isSelected: Bool)  {
        selectedOverlayView.isHidden = !isSelected
    }
    
    func configureEveryTipCell(userName: String, image: UIImage) {
        userNameLabel.text = userName
        profileImageView.image = image
            .withAlignmentRectInsets(UIEdgeInsets(top: -14.4, left: -14.4, bottom: -14.4, right: -14.4))
    }
    
    func configureUserTipCell(userName: String?, imageURL: String?) {
        userNameLabel.text = userName ?? "unknown"

        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        let url = URL(string: imageURL ?? "")

        profileImageView.kf.setImage(
            with: url,
            placeholder: UIImage.et_getImage(for: .blankImage)
        )
    }
}
