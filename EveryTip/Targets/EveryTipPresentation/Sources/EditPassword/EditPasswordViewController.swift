import UIKit
import ReactorKit
import RxSwift
import SnapKit

final class EditPasswordViewController: BaseViewController {
    
    var disposeBag: DisposeBag = DisposeBag()
    private var activeTextField: UITextField?

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleView = TitleDescriptionView(
        title: "비밀번호 변경",
        subTitle: "새로운 비밀번호를 설정합니다."
    )
    
    private let currentPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 비밀번호"
        label.font = .et_pretendard(style: .medium, size: 16)
        label.textColor = .et_textColorBlack70
        return label
    }()
    
    private let currentPasswordTextField: EveryTipTextFieldView = {
        let view = EveryTipTextFieldView(hasClearButton: true, hasSecureTextButton: true)
        view.textField.placeholder = "현재 비밀번호"
        return view
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .et_lineGray20
        return view
    }()
    
    private let newPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "새 비밀번호"
        label.font = .et_pretendard(style: .medium, size: 16)
        label.textColor = .et_textColorBlack70
        return label
    }()
    
    private let newPasswordTextField: EveryTipTextFieldView = {
        let view = EveryTipTextFieldView(hasClearButton: true, hasSecureTextButton: true)
        view.textField.placeholder = "새 비밀번호(영문+숫자 조합 8자리 이상)"
        return view
    }()
    
    private let newPasswordConfirmTextField: EveryTipTextFieldView = {
        let view = EveryTipTextFieldView(hasClearButton: true, hasSecureTextButton: true)
        view.textField.placeholder = "새 비밀번호 확인"
        return view
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = .et_pretendard(style: .bold, size: 16)
        button.tintColor = .white
        button.backgroundColor = .et_textColor5
        button.isEnabled = false
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    weak var coordinator: EditPasswordCoordinator?
    
    init(reactor: EditPasswordReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupConstraints()
    }

    private func setupLayout() {
        view.addSubViews(
            scrollView,
            confirmButton
        )
        scrollView.addSubview(contentView)
        
        contentView.addSubViews(
            titleView,
            currentPasswordLabel,
            currentPasswordTextField,
            separator,
            newPasswordLabel,
            newPasswordTextField,
            newPasswordConfirmTextField
        )
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-20)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        titleView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.leading.equalToSuperview().offset(20)
        }
        
        currentPasswordLabel.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(20)
        }
        
        currentPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(currentPasswordLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        separator.snp.makeConstraints {
            $0.top.equalTo(currentPasswordTextField.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(8)
        }
        
        newPasswordLabel.snp.makeConstraints {
            $0.top.equalTo(separator.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(20)
        }
        
        newPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(newPasswordLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        newPasswordConfirmTextField.snp.makeConstraints {
            $0.top.equalTo(newPasswordTextField.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        confirmButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom ).offset(-20)
            $0.height.equalTo(56)
        }
    }
}

extension EditPasswordViewController: View {
    func bind(reactor: EditPasswordReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }

    func bindInput(reactor: EditPasswordReactor) {
        let textFields = [
            currentPasswordTextField,
            newPasswordTextField,
            newPasswordConfirmTextField
        ]
        
        textFields.forEach { textFieldView in
            let textField = textFieldView.textField
            
            textField.rx.controlEvent(.editingDidBegin)
                .map { EveryTipTextFieldStatus.editing }
                .bind(to: textFieldView.status)
                .disposed(by: disposeBag)
            
            textField.rx.controlEvent(.editingDidEnd)
                .map { EveryTipTextFieldStatus.normal }
                .bind(to: textFieldView.status)
                .disposed(by: disposeBag)
        }
        
        currentPasswordTextField.textField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.currentPasswordChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        newPasswordTextField.textField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.newPasswordChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        newPasswordConfirmTextField.textField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.newPasswordConfirmationChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        confirmButton.rx.tap
            .map { Reactor.Action.confirmButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    func bindOutput(reactor: EditPasswordReactor) {
        reactor.pulse(\.$toastMessage)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] message in
                guard let message = message else { return }
                self?.showToast(message: message)
            })
            .disposed(by: disposeBag)

        reactor.pulse(\.$navigationSignal)
            .filter { $0 == true }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                NotificationCenter.default.post(name: .userDidLogout, object: nil)
                self?.coordinator?.popToRootView()
            })
            .disposed(by: disposeBag)

        reactor.state.map { $0.isConfirmed }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isConfirmed in
                self?.confirmButton.isEnabled = isConfirmed
                self?.confirmButton.backgroundColor = isConfirmed ? .et_brandColor2 : .et_textColor5
            })
            .disposed(by: disposeBag)
    }
}
