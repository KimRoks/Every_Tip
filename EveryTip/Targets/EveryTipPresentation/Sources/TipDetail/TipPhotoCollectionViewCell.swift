//
//  TipPhotoCollectionViewCell.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/11/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import SnapKit
import Kingfisher

final class TipPhotoCollectionViewCell: UICollectionViewCell, Reusable {
    private let tipImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tipImageView.image = nil
    }
    
    func setupLayout() {
        contentView.addSubview(tipImageView)
    }
    
    func setupConstraints() {
        tipImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureCell(with imageURL: String) {
        guard let url = URL(string: imageURL) else {
            tipImageView.image = UIImage.et_getImage(for: .blankImage)
            return
        }
        tipImageView.kf.setImage(
            with: url,
            placeholder: UIImage.et_getImage(for: .blankImage),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ]
        )
    }
}
