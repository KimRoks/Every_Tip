//
//  UserTipViewCotroller.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/20/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//
import UIKit

import EveryTipDomain

import SnapKit
import ReactorKit
import RxSwift

final class UserTipViewCotroller: BaseViewController {
    
    var disposeBag = DisposeBag()
    weak var coordinator: UserTipCoordinator?
    
    private let placeholderView: UserContentPlaceholderView
    
    private let tipListTableView: UITableView = {
        let tableView = UITableView()
        tableView.indicatorStyle = .white
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 130
        
        return tableView
    }()
    
    init(reactor: UserTipReactor) {
        switch reactor.listType {
        case .myTips:
            self.placeholderView = UserContentPlaceholderView(type: .myTip)
        case .savedTips:
            self.placeholderView = UserContentPlaceholderView(type: .savedTip)
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
        setupTableView()
    }
    
    private func setupLayout() {
        view.addSubViews(
            placeholderView,
            tipListTableView
        )
    }
    
    private func setupConstraints() {
        placeholderView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalTo(view).inset(20)
        }
        
        tipListTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        tipListTableView.register(
            TipListCell.self,
            forCellReuseIdentifier: TipListCell.reuseIdentifier
        )
    }
}

extension UserTipViewCotroller: View {
    func bind(reactor: UserTipReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: UserTipReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rx.viewWillAppear
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tipListTableView.rx.modelSelected(Tip.self)
            .map { Reactor.Action.itemSelected($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: UserTipReactor) {
        reactor.state
            .map { $0.tips }
            .bind(to: tipListTableView.rx.items(
                cellIdentifier: TipListCell.reuseIdentifier,
                cellType: TipListCell.self
            )) { _, tip, cell in
                cell.configureTipListCell(with: tip)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { !$0.tips.isEmpty }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: placeholderView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.tips.isEmpty }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: tipListTableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$pushSignal)
            .filter { $0 }
            .withUnretained(self)
            .bind { vc, _ in
                guard let tip = vc.reactor?.currentState.selectedTip else {
                    return
                }
                vc.coordinator?.pushToTipDetail(tipID: tip.id)
            }
            .disposed(by: disposeBag)
    }
}
