//
//  DetailDisclosureView.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 3/9/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDesignSystem

import RxSwift

final class DetailDisclosureView: UIStackView {
    
    private let tapSubject = PublishSubject<Void>()
    
    var tap: Observable<Void> {
        return tapSubject.asObservable()
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.et_pretendard(
            style: .medium,
            size: 16
        )
        label.textColor = .et_textColorBlack50
        
        return label
    }()
    
    private let detailDisclosureButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(
            .et_getImage(for: .nextButton),
                        for: .normal
        )

        button.tintColor = .et_textColor5
        button.contentMode = .center
        
        return button
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        
        setupAttributes()
        setupLayout()
        setupConstraints()
        detailDisclosureButton.addTarget(
            self,
            action: #selector(buttonTappped),
            for: .touchUpInside
        )
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTappped() {
        tapSubject.onNext(())
    }
    
    private func setupAttributes() {
        self.axis = .horizontal
        self.distribution = .fillProportionally
    }
    
    private func setupLayout() {
        self.addArrangedSubview(titleLabel)
        self.addArrangedSubview(detailDisclosureButton)
    }
    
    private func setupConstraints() {
        detailDisclosureButton.snp.makeConstraints {
            $0.width.equalTo(15)
        }
    }
    
    func updateTitle(_ title: String) {
        titleLabel.text = title
        titleLabel.textColor = .et_textColorBlack70
        titleLabel.font = .et_pretendard(
            style: .bold,
            size: 16
        )
    }
}
