//
//  SectionedTipViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/9/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDomain

import SnapKit
import ReactorKit

final class SectionedTipViewController: BaseViewController {
    
    weak var coordinator: SectionedTipCoordinator?
    var disposeBag = DisposeBag()
    
    private let tipListTableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    init(reactor: SectionedTipReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupLayout()
        setupConstraints()
        setupTableView()
    }
    
    private func setupLayout() {
        view.addSubview(tipListTableView)
    }
    
    private func setupConstraints() {
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

extension SectionedTipViewController: View {
    func bind(reactor: SectionedTipReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    func bindInput(reactor: SectionedTipReactor) {
        rx.viewDidLoad.map {
            Reactor.Action.fetchTips
        }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
        
        tipListTableView.rx.modelSelected(Tip.self)
            .map { Reactor.Action.itemSelected($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindOutput(reactor: SectionedTipReactor) {
        reactor.state
            .map { $0.tips }
            .bind(to: tipListTableView.rx.items(
                cellIdentifier: TipListCell.reuseIdentifier,
                cellType: TipListCell.self
            )) { _, tip, cell in
                cell.configureTipListCell(with: tip)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$pushSignal)
            .filter { $0 == true}
            .withUnretained(self)
            .bind { vc, _ in
                guard let tip = vc.reactor?.currentState.selectedTip else {
                    return
                }
                self.coordinator?.pushToTipDetail(tipID: tip.id)
            }
            .disposed(by: disposeBag)
    }
}
