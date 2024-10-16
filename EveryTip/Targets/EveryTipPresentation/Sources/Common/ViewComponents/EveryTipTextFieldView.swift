//
//  EveryTipTextFieldView.swift
//  EveryTipPresentation
//
//  Created by 손대홍 on 10/16/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import RxSwift
import SnapKit

enum EveryTipTextFieldStatus {
    case normal
    case editing
    case success
    case error
    case notEnabled
}

enum EveryTipTextFieldAction {
    case editingDidBegin
    case editingDidEnd
    case editingDidEndOnExit
    case textChanged(text: String)
}

final class EveryTipTextFieldView: UIView {
    var borderColorWhenNormal = UIColor.yellow
    var borderColorWhenEditing = UIColor.black
    var borderColorWhenSuccess = UIColor.blue
    var borderColorWhenError = UIColor.red
    var borderColorWhenNotEnabled = UIColor.gray
    
    let borderView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 0
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.red.cgColor
        return view
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "플레이스 홀더"
//        textField.font = nil
       return textField
    }()
    
    let guideMessageLabel: UILabel = {
       let label = UILabel()
        label.text = "안내 메시지"
//        label.font = nil
        return label
    }()
    
    var action: PublishSubject<EveryTipTextFieldAction> = .init()
    var status: BehaviorSubject<EveryTipTextFieldStatus> = .init(value: .normal)
    
    private let containerStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private let guideMessageView = UIView()
    
    private let disposeBag = DisposeBag()
    
    // MARK: -
    
    init(hasClearButton: Bool, hasSecureTextButton: Bool = false) {
        textField.clearButtonMode = hasClearButton ? .always : .never
        textField.isSecureTextEntry = hasSecureTextButton
        super.init(frame: .zero)
        setupLayout()
        setupConstraints()
        bind()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    
    private func setupLayout() {
        addSubview(containerStackView)
        
        containerStackView.addArrangedSubViews(
            borderView.addSubViews(
                textField
            ),
            guideMessageView.addSubViews(
                guideMessageLabel
            )
        )
    }
    
    private func setupConstraints() {
        containerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        borderView.snp.makeConstraints {
            $0.height.equalTo(52)
        }
        
        textField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16)
        }
        
        guideMessageLabel.snp.makeConstraints {
            $0.top.bottom.right.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
        }
    }
    
    private func bind() {
        textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .map { EveryTipTextFieldAction.textChanged(text: $0) }
            .bind(to: action)
            .disposed(by: disposeBag)
        
        textField.rx.controlEvent(.editingDidBegin)
            .map { EveryTipTextFieldAction.editingDidBegin }
            .bind(to: action)
            .disposed(by: disposeBag)
        
        textField.rx.controlEvent(.editingDidEnd)
            .map { EveryTipTextFieldAction.editingDidEnd }
            .bind(to: action)
            .disposed(by: disposeBag)
        
        textField.rx.controlEvent(.editingDidEndOnExit)
            .map { EveryTipTextFieldAction.editingDidEndOnExit }
            .bind(to: action)
            .disposed(by: disposeBag)
        
        let statusBinder: Binder<EveryTipTextFieldStatus> = Binder(self) { view, status in
            switch status {
            case .normal:
                view.borderView.layer.borderColor = view.borderColorWhenNormal.cgColor
                view.guideMessageView.isHidden = true
                
            case .editing:
                view.borderView.layer.borderColor = view.borderColorWhenEditing.cgColor
                
            case .success:
                view.borderView.layer.borderColor = view.borderColorWhenSuccess.cgColor
                view.guideMessageLabel.textColor = view.borderColorWhenSuccess
                view.guideMessageView.isHidden = view.guideMessageLabel.text == nil
                
            case .error:
                view.borderView.layer.borderColor = view.borderColorWhenError.cgColor
                view.guideMessageLabel.textColor = view.borderColorWhenError
                view.guideMessageView.isHidden = false
                
            case .notEnabled:
                view.borderView.layer.borderColor = view.borderColorWhenNotEnabled.cgColor
                view.guideMessageView.isHidden = true
            }
        }
        
        status
            .bind(to: statusBinder)
            .disposed(by: disposeBag)
    }
}
