//
//  SelectedPhotoCell.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 4/4/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import SnapKit

final class SelectedPhotoCell: UICollectionViewCell, Reusable {
    private let selectedPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private let removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.setTitle("X", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .et_brandColor2
        
        return button
    }()
    
    private let thumnailOverlayView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.et_brandColor2.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        return view
    }()
    
    private let thumnailOverlayTextLabel: UILabel = {
        let label = UILabel()
        label.text = "대표사진"
        label.textColor = .white
        label.font = .et_pretendard(
            style: .medium,
            size: 8
        )
        label.textAlignment = .center
        label.backgroundColor = .et_brandColor2
        label.setRoundedCorners(
            radius: 10,
            corners: .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner
        )
        label.layer.masksToBounds = true
        label.isHidden = true
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupConstraints()
        removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubViews(
            selectedPhotoImageView,
            thumnailOverlayView,
            thumnailOverlayTextLabel,
            removeButton
        )
    }
    
    private func setupConstraints() {
        selectedPhotoImageView.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
        
        removeButton.snp.makeConstraints {
            $0.width.height.equalTo(12)
            $0.top.equalTo(selectedPhotoImageView.snp.top).offset(-4)
            $0.trailing.equalTo(selectedPhotoImageView.snp.trailing).offset(3)
        }
        
        thumnailOverlayView.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
        
        thumnailOverlayTextLabel.snp.makeConstraints {
            $0.width.equalTo(contentView)
            $0.leading.trailing.equalTo(contentView)
            $0.bottom.equalTo(contentView)
            $0.height.equalTo(12)
        }
    }
    
    @objc
    func removeButtonTapped() {
        print("dddd")
    }
    
    func setThumnail() {
        thumnailOverlayTextLabel.isHidden = false
    }
    
    func clearThumnail() {
        thumnailOverlayTextLabel.isHidden = true
    }
    
    func updatePhoto(_ image: UIImage?) {
        guard let image = image else { return }
        selectedPhotoImageView.image = image
    }
}
