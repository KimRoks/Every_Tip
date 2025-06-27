//
//  MyInfoViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/31/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDesignSystem

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

final class MyInfoViewController: BaseViewController {
    
    weak var coordinator: MyInfoViewCoordinator?
    var disposeBag = DisposeBag()
    
    private let logoutConfirmTapped = PublishRelay<Void>()
    private let tableViewCellTapped = PublishRelay<Int>()
    private let tapGesture = UITapGestureRecognizer()
    
    private let roundedBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.setRoundedCorners(
            radius: 15,
            corners: .layerMinXMinYCorner, .layerMaxXMinYCorner
        )
        
        return view
    }()
        
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.et_getImage(for: .blankImage)
        imageView.backgroundColor = .gray
        
        return imageView
    }()
    
    private let userNameLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.et_pretendard(
            style: .semiBold,
            size: 22
        )
        
        return label
    }()
    
    private let subscribersCountLabel: UILabel = {
        let label = UILabel()
        label.text = "구독자 0"
        
        return label
    }()
    
    private let postedTipCountLabel: UILabel = {
        let label = UILabel()
        label.text = "구독자 0"
        return label
    }()
    
    private let savedTipCountLabel: UILabel = {
        let label = UILabel()
        label.text = "구독자 0"

        return label
    }()
    
    private let touchableView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let nextButtonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .et_getImage(for: .nextButton_darkGray)
        
        return imageView
    }()
    
    private let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
                
        var configuration = UIButton.Configuration.plain()
        configuration.image = .et_getImage(for: .edit)

        let attributedTitle = AttributedString(
            "프로필 편집",
            attributes: AttributeContainer([
                .font: UIFont.et_pretendard(style: .bold, size: 14)
            ])
        )
        configuration.attributedTitle = attributedTitle
        configuration.imagePadding = 8
        configuration.baseForegroundColor = .et_textColorBlack50
        configuration.background.backgroundColor = .et_lineGray20
        
        button.configuration = configuration
        button.layer.cornerRadius = 5

        return button
    }()
    
    private let userInfoTableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    init(reactor: MyInfoReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        userImageView.makeCircular()
    }
    
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .et_brandColor2
        setupLayout()
        setupConstraints()
        setTableView()
        setUserInteraction()
    }
    
    //MARK: Private Methods
    
    private func setupLayout() {
        view.addSubview(roundedBackgroundView)
        roundedBackgroundView.addSubViews(
            userImageView,
            userNameLable,
            touchableView,
            editProfileButton,
            userInfoTableView
        )
        
        touchableView.addSubViews(
            subscribersCountLabel,
            postedTipCountLabel,
            savedTipCountLabel,
            nextButtonImageView
        )
    }
    
    private func setupConstraints() {
        roundedBackgroundView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view)
        }
        
        userImageView.snp.makeConstraints {
            $0.top.equalTo(roundedBackgroundView.snp.top).offset(30)
            $0.leading.equalTo(roundedBackgroundView.snp.leading).offset(20)
            $0.width.height.equalTo(60)
        }
        
        userNameLable.snp.makeConstraints {
            $0.top.equalTo(roundedBackgroundView.snp.top).offset(35)
            $0.leading.equalTo(userImageView.snp.trailing).offset(20)
            $0.trailing.equalTo(roundedBackgroundView.snp.trailing)
        }
        
        subscribersCountLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(touchableView)
            $0.leading.equalTo(touchableView)
        }
        
        postedTipCountLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(touchableView)
            $0.leading.equalTo(subscribersCountLabel.snp.trailing).offset(12)
        }
        
        savedTipCountLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(touchableView)
            $0.leading.equalTo(postedTipCountLabel.snp.trailing).offset(12)
        }
        
        nextButtonImageView.snp.makeConstraints {
            $0.width.equalTo(4)
            $0.height.equalTo(8)
            $0.centerY.equalTo(touchableView)
            $0.leading.equalTo(savedTipCountLabel.snp.trailing).offset(12)
        }
        
        touchableView.snp.makeConstraints {
            $0.top.equalTo(userNameLable.snp.bottom).offset(5)
            $0.leading.equalTo(userImageView.snp.trailing).offset(20)
            $0.trailing.equalTo(roundedBackgroundView.snp.trailing).offset(-10)
            $0.height.equalTo(20)
        }
        
        editProfileButton.snp.makeConstraints {
            $0.top.equalTo(roundedBackgroundView.snp.top).offset(120)
            $0.leading.trailing.equalTo(roundedBackgroundView).inset(20)
        }
        
        userInfoTableView.snp.makeConstraints {
            $0.top.equalTo(editProfileButton.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalTo(roundedBackgroundView)
        }
    }
    
    private func setTableView() {
        userInfoTableView.delegate = self
        userInfoTableView.dataSource = self
        
        userInfoTableView.register(
            MyInfoTableViewCell.self,
            forCellReuseIdentifier: MyInfoTableViewCell.reuseIdentifier
        )
    }
    
    private func setUserInteraction() {
        touchableView.addGestureRecognizer(tapGesture)
    }
    
    private func showLogoutAlert() {
        let alertController = UIAlertController(
            title: "로그아웃 하시겠습니까?",
            message: nil,
            preferredStyle: .alert
        )
        let confirmAction = UIAlertAction(
            title: "예",
            style: .default
        ) { [weak self] _ in
            self?.logoutConfirmTapped.accept(())
        }
        let cancleAction = UIAlertAction(title: "아니오", style: .default)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancleAction)
        
        self.present(alertController, animated: true)
    }
}

extension MyInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableViewCellTapped.accept(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MyInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let reactor = reactor else { return 0 }
        
        return reactor.getInfoTableViewItems().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = userInfoTableView.dequeueReusableCell(
            withIdentifier: MyInfoTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? MyInfoTableViewCell else { return
            UITableViewCell()
        }
        
        cell.leftLabel.text = reactor?.getInfoTableViewItems()[indexPath.row]
        
        switch indexPath.row {
        case 0...2:
            cell.accessoryType = .disclosureIndicator
            cell.rightLabel.text = nil
        case 3:
            // TODO: 버전정보 및 공지사항등 api 연결
            cell.accessoryType = .none
            cell.rightLabel.text = "1.01"
        default:
            cell.accessoryType = .none
            cell.rightLabel.text = nil
        }
        
        return cell
    }
}

//MARK: Reactor

extension MyInfoViewController: View {
    func bind(reactor: MyInfoReactor) {
        bindInputs(to: reactor)
        bindOutputs(to: reactor)
    }
    
    private func bindInputs(to reactor: MyInfoReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rx.viewWillAppear
            .map { Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tapGesture.rx.event
            .bind { [weak self] _ in
                self?.coordinator?.checkLoginBeforeAction(onLoggedIn: { [weak self] in
                    self?.coordinator?.pushToUserContentsView(myID: reactor.currentState.myProfile.id)
                })
            }
            .disposed(by: disposeBag)
        
        logoutConfirmTapped.map { Reactor.Action.logoutConfirmTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableViewCellTapped.map { row -> Reactor.Action? in
            switch row {
            case 1: return .setCategoryButtonTapped
            case 2: return .agreementCellTapped
            case 4: return .logoutCellTapped
        
            default:
                return nil
            }
        }
        .compactMap { $0 }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        editProfileButton.rx.tap
            .map { Reactor.Action.editProfileButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutputs(to reactor: MyInfoReactor) {
        reactor.state.map { $0.myProfile.nickName }
            .distinctUntilChanged()
            .bind(to: userNameLable.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.myProfile.subscriberCount }
            .distinctUntilChanged()
            .bind(
                with: self,
                onNext: { owner, count in
                    owner.subscribersCountLabel.setCountLabelStyle(
                        normalText: "구독자 ",
                        boldText: count.toAbbreviatedString()
                    )
                }
            )
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.myProfile.tipCount }
            .distinctUntilChanged()
            .bind(
                with: self,
                onNext: { owner, count in
                    owner.postedTipCountLabel.setCountLabelStyle(
                        normalText: "작성 팁 ",
                        boldText: count.toAbbreviatedString()
                    )
                }
            )
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.myProfile.savedTipCount }
            .distinctUntilChanged()
            .bind(
                with: self,
                onNext: { owner, count in
                    owner.savedTipCountLabel.setCountLabelStyle(
                        normalText: "저장 팁 ",
                        boldText: count.toAbbreviatedString()
                    )
                }
            )
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$toastMessage)
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] message in
                self?.showToast(message: message)
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$navigationSignal)
            .compactMap { $0 }
            .bind(onNext: { [weak self] event in
                switch event {
                case .agreement:
                    self?.coordinator?.pushToAgreementViewcontroller()
                case .logout:
                    self?.showLogoutAlert()
                case .userContents:
                    self?.coordinator?.checkLoginBeforeAction {
                        self?.coordinator?.pushToUserContentsView(myID: reactor.currentState.myProfile.id)
                    }
                case .editProfile:
                    self?.coordinator?.checkLoginBeforeAction {
                        self?.coordinator?.pushToEditProfileView(myNickName: reactor.currentState.myProfile.nickName)
                    }
                case .setCategories:
                    self?.coordinator?.checkLoginBeforeAction {
                        self?.coordinator?.pushToSetCategory()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}
