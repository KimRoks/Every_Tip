//
//  UserFollowViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/2/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import SnapKit
import ReactorKit
import RxSwift
import EveryTipDomain

final class UserFollowViewController: BaseViewController {
    
    var disposeBag: DisposeBag = DisposeBag()
    weak var coordinator: UserFollowCoordinator?
    
    private let userListTableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    private let placeholderView: UserContentPlaceholderView
    
    init(reactor: UserFollowReactor) {
        switch reactor.followType {
        case .followers:
            self.placeholderView = UserContentPlaceholderView(type: .follower)
        case .following:
            self.placeholderView = UserContentPlaceholderView(type: .following)
        }
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
        setupTalbeView()
    }
    
    private func setupLayout() {
        view.addSubViews(
            placeholderView,
            userListTableView
        )
    }
    
    private func setupConstraints() {
        placeholderView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalTo(view).inset(20)
        }
        
        userListTableView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalTo(view).inset(20)
        }
    }
    
    private func setupTalbeView() {
        userListTableView.register(
            UserFollowTableViewCell.self,
            forCellReuseIdentifier: UserFollowTableViewCell.reuseIdentifier
        )
    }
}

extension UserFollowViewController: View {
    func bind(reactor: UserFollowReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    func bindInput(reactor: UserFollowReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        userListTableView.rx.modelSelected(UserPreview.self)
            .map { Reactor.Action.itemSelected($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindOutput(reactor: UserFollowReactor) {
        reactor.state
            .map { $0.userList }
            .bind(to: userListTableView.rx.items(
                cellIdentifier: UserFollowTableViewCell.reuseIdentifier,
                cellType: UserFollowTableViewCell.self
            )) { [weak self] index, user, cell in
                guard let followType = self?.reactor?.followType else { return }
                
                cell.configure(
                    with: user,
                    followType: followType,
                    at: index
                )
                
                cell.removeButtonTapped
                    .subscribe(onNext: {
                        self?.reactor?.action.onNext(.removeButtonTapped(userID: user.id)
                        )
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        
        reactor.pulse(\.$pushSignal)
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] user in
                self?.coordinator?.pushToUserProfile(userID: user.id)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { !$0.userList.isEmpty }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: placeholderView.rx.isHidden)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.userList.isEmpty }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: userListTableView.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
