//
//  BottomSheetViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 4/11/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit
import SnapKit

// 바텀 시트 스타일에 상속하여 사용 사용처에서 modalPresentationStyle = .overFullScreen 준수
// 추가 뷰 객체는 contentView를 통해 레이아웃 설정


// TODO: 유동적 높이로 수정 필요

class BottomSheetViewController: UIViewController {
    private var bottomSheetConstraint: Constraint?
    
    private let translucentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.0)
        
        return view
    }()
    
    private let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.setRoundedCorners(radius: 10, corners: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = CGSize(width: 0, height: -10)
        view.layer.shadowRadius = 6
        view.alpha = 0
        
        return view
    }()
    
    // 해당 뷰에 서브 클래스들 객체 담아 사용
    let contentView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupConstraints()
        setupTranslucentView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatePresent()
    }
    
    private func setupLayout() {
        view.addSubViews(
            translucentView,
            bottomSheetView
        )
        
        bottomSheetView.addSubview(contentView)
    }
    
    private func setupConstraints() {
        translucentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bottomSheetView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(view).multipliedBy(0.5)
            bottomSheetConstraint = $0.top.equalTo(view.snp.bottom).constraint // 시작은 화면 밖 아래
        }
        
        contentView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    
    private func setupTranslucentView() {
        let translucentViewTapped = UITapGestureRecognizer(
            target: self,
            action: #selector(handleDismiss)
        )
        translucentView.addGestureRecognizer(translucentViewTapped)
    }
    
    private func animatePresent() {
        // 배경 어둡게 + BottomSheet 위로 애니메이션
        self.bottomSheetConstraint?.update(offset: -view.frame.height * 0.5)
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.translucentView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.6)
                self.bottomSheetView.alpha = 1
                self.view.layoutIfNeeded()
            }
        )
    }
    
    @objc
    private func handleDismiss() {
        // BottomSheet 다시 아래로 + 배경 투명하게
        self.bottomSheetConstraint?.update(offset: 0)
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                self.translucentView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.0)
                self.view.layoutIfNeeded()
            }
        ) { _ in
            self.dismiss(animated: false)
        }
    }
}
