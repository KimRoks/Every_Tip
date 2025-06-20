//
//  MyTipViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/20/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import SnapKit
import ReactorKit
import RxSwift

final class MyTipViewController: BaseViewController {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    private let tipListTableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    init(reactor: MyTipReactor) {
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
        view.addSubview(tipListTableView)
    }
    
    private func setupConstraints() {
        tipListTableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        tipListTableView.register(
            TipListCell.self,
            forCellReuseIdentifier: TipListCell.reuseIdentifier
        )
      
        tipListTableView.indicatorStyle = .white
        tipListTableView.separatorStyle = .none
        tipListTableView.rowHeight = UITableView.automaticDimension
        tipListTableView.estimatedRowHeight = 130
    }
}

extension MyTipViewController: View {
    func bind(reactor: MyTipReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    func bindInput(reactor: MyTipReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    func bindOutput(reactor: MyTipReactor) {
        reactor.state
            .map { $0.tips }
            .bind(to: tipListTableView.rx.items(
                cellIdentifier: TipListCell.reuseIdentifier,
                cellType: TipListCell.self)
            ) { row, tip, cell in
                cell.configureTipListCell(with: tip)
            }
            .disposed(by: disposeBag)
    }
}
