//
//  UserProfileViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/27/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDomain

import ReactorKit
import RxSwift

final class UserProfileViewController: BaseViewController {
    weak var coordinator: UserProfileCoordinator?
    
    var disposeBag = DisposeBag()
    
    private let ellipsisButton: UIButton = {
        let button = UIButton()
        button.setImage(.et_getImage(for: .ellipsis_black), for: .normal)
        
        return button
    }()
    
    private let userProfileView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .et_getImage(for: .blankImage)
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .et_pretendard(style: .semiBold, size: 22)
        
        return label
    }()
    
    private let subscribeCountLabel: UILabel = {
        let label = UILabel()
        label.font = .et_pretendard(style: .medium, size: 14)
        
        return label
    }()
    
    private let writtenTipCountLabel: UILabel = {
        let label = UILabel()
        label.font = .et_pretendard(style: .medium, size: 14)

        return label
    }()
    
    private let subscribeButton: UIButton = {
        let button = UIButton()
        button.setTitle("구독", for: .normal)
        button.titleLabel?.font = .et_pretendard(style: .bold, size: 14)
        button.backgroundColor = .et_textColorBlack50
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        
        return button
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let guideLabel: UILabel = {
        let label = UILabel()
        label.font = .et_pretendard(style: .bold, size: 14)
        label.textColor = .et_textColorBlack10
        
        return label
    }()
    
    private let sortButton: SortButton = {
        let button = SortButton(type: .system)
        button.configureButtonStyle(with: .latest)
        
        return button
    }()
    
    private let tipListTableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    init(reactor: UserProfileReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        setupLayout()
        setupConstraints()
        setupTablewView()
        setupNavigationRightBarButtonItem()
        
    }
    
    private func setupNavigationRightBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: ellipsisButton)
    }
    
    private func setupLayout() {
        view.addSubViews(
            userProfileView,
            subscribeButton,
            containerView,
            tipListTableView
        )
        
        userProfileView.addSubViews(
            profileImageView,
            nicknameLabel,
            subscribeCountLabel,
            writtenTipCountLabel
        )
        
        containerView.addSubViews(
            guideLabel,
            sortButton
        )
    }
    
    private func setupConstraints() {
        userProfileView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view)
            
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(userProfileView.snp.top).offset(16)
            $0.leading.equalTo(userProfileView.snp.leading).offset(20)
            $0.height.width.equalTo(60)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(userProfileView.snp.top).offset(22)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
        }
        
        subscribeCountLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(6)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
        }
        
        writtenTipCountLabel.snp.makeConstraints {
            $0.top.equalTo(subscribeCountLabel)
            $0.leading.equalTo(subscribeCountLabel.snp.trailing).offset(12)
        }
        
        subscribeButton.snp.makeConstraints {
            $0.top.equalTo(userProfileView.snp.top).offset(96)
            $0.leading.trailing.equalTo(view).inset(20)
            $0.bottom.equalTo(userProfileView.snp.bottom).offset(20)
            $0.height.equalTo(32)
        }

        containerView.snp.makeConstraints {
            $0.top.equalTo(subscribeButton.snp.bottom).offset(24)
            $0.height.equalTo(17)
            $0.leading.trailing.equalTo(view).inset(20)
        }
        
        guideLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        
        sortButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        
        tipListTableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(containerView.snp.bottom).offset(4)
        }
    }
    
    private func setupTablewView() {
        tipListTableView.register(
            TipListCell.self,
            forCellReuseIdentifier: TipListCell.reuseIdentifier
        )
    }
    
    private func showReportAlert(
        confirmHandler: @escaping () -> Void
    ) {
        let alert = UIAlertController(
            title: "이 사용자를 신고할까요?",
            message: "커뮤니티 가이드에 따라 신고 사유에 해당하는지 검토 후 처리됩니다.",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            confirmHandler()
        }
        
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension UserProfileViewController: View {
    func bind(reactor: UserProfileReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    func bindInput(reactor: UserProfileReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tipListTableView.rx.modelSelected(Tip.self)
            .map {
                Reactor.Action.itemSelected($0)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        sortButton.rx.tap
            .subscribe { [weak self] _ in
                self?.presentSortAlert { selectedOption in
                    self?.reactor?.action.onNext(.sortButtonTapped(selectedOption))
                }
            }
            .disposed(by: disposeBag)
        
        subscribeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.checkLoginBeforeAction {
                    self?.reactor?.action.onNext(.subScribeButtonTapped)
                }
            })
            .disposed(by: disposeBag)
        
        ellipsisButton.rx.tap
            .map { Reactor.Action.profileEllipsisButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindOutput(reactor: UserProfileReactor) {
        let nicknameStream = reactor.state
            .map { $0.userProfile?.nickName }
            .compactMap { $0 }
            .share(replay: 1, scope: .whileConnected)
        
        nicknameStream
            .bind(to: nicknameLabel.rx.text)
            .disposed(by: disposeBag)
        
        nicknameStream
            .map{ "\($0)님이 작성한 팁을 확인하세요!" }
            .bind(to: guideLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.userProfile?.subscriberCount }
            .compactMap{ $0 }
            .map { "구독자 \($0)" }
            .bind(to: subscribeCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        reactor.state.map { $0.userProfile?.tipCount }
            .compactMap{ $0 }
            .map { "작성 팁 \($0)" }
            .bind(to: writtenTipCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.tips }
            .bind(to: tipListTableView.rx.items(
                cellIdentifier: TipListCell.reuseIdentifier,
                cellType: TipListCell.self)
            ) { row, tip, cell in
                cell.configureTipListCell(with: tip)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.userProfile?.isFollowing }
            .compactMap{ $0 }
            .distinctUntilChanged()
            .subscribe(onNext: {[weak self] isFollowing in
                if isFollowing == false {
                    self?.subscribeButton.setTitle("구독", for: .normal)
                    self?.subscribeButton.backgroundColor = .et_textColorBlack50
                } else {
                    self?.subscribeButton.setTitle("구독 중", for: .normal)
                    self?.subscribeButton.backgroundColor = .et_brandColor2
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.userProfile?.isMyProfile }
            .compactMap { $0 }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isMine in
                if isMine {
                    self?.subscribeButton.snp.updateConstraints {
                        $0.height.equalTo(0)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$pushSignal)
            .filter { $0 }
            .withLatestFrom(reactor.state.map { $0.selectedTip })
            .compactMap { $0?.id }
            .bind { [weak self] tipID in
                self?.coordinator?.pushToTipDetailView(tipID: tipID)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.sortOption }
            .distinctUntilChanged()
            .bind { [weak self] sortOption in
                guard let self = self else { return }
                self.sortButton.configureButtonStyle(with: sortOption)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$toastMessage)
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] message in
                self?.showToast(message: message)
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$ellipsisSignal)
            .filter { $0 == true }
            .subscribe(onNext: { [weak self] _ in
                self?.showReportAlert() {
                    self?.coordinator?.checkLoginBeforeAction {
                        self?.reactor?.action.onNext(.reportUser)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}

