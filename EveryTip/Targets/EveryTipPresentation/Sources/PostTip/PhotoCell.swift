//
//  PhotoCell.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 4/4/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import SnapKit

final class PhotoCell: UICollectionViewCell, Reusable {
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        
        return imageView
    }()
    
    private let selectedOvelay: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.et_brandColor2.cgColor
        view.layer.borderWidth = 2
        view.isHidden = true
        
        return view
    }()
    
    private let selectedNumerLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .et_brandColor2
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.isHidden = true
        label.textAlignment = .center
        label.textColor = .white
        label.font = .et_pretendard(style: .medium, size: 14)
        
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        selectedOvelay.addSubViews(
            selectedNumerLabel
        )
        
        contentView.addSubViews(
            
            photoImageView,
            selectedOvelay
        )
    }
    
    private func setupConstraints() {
        selectedOvelay.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
        
        selectedNumerLabel.snp.makeConstraints {
            $0.top.equalTo(selectedOvelay.snp.top).offset(6)
            $0.trailing.equalTo(selectedOvelay.snp.trailing).offset(-6)
            $0.width.height.equalTo(20)
        }
        
        photoImageView.snp.makeConstraints {
            $0.edges.equalTo(selectedOvelay)
        }
    }
    
    func updatePhoto(with image: UIImage?) {
        guard let image = image else { return }
        photoImageView.image = image
    }
    
    func setSelected(index: Int,_ isSelected: Bool) {
        if isSelected {
            selectedOvelay.isHidden = false
            selectedNumerLabel.isHidden = false
            selectedNumerLabel.text = "\(index)"
        } else {
            selectedOvelay.isHidden = true
            selectedNumerLabel.isHidden = true
            selectedNumerLabel.text = nil
        }
    }
}
