//
//  CategorizedTipViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/25/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift

final class CategorizedTipViewController: BaseViewController {
    
    weak var coordinator: CategorizedTipCoordinator?
    var disposeBag: DisposeBag = DisposeBag()
    
    private let tipsTableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    init(reactor: CategorizedTipReactor) {
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
            tipsTableView
        )
    }
    
    private func setupConstraints() {
        tipsTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        tipsTableView.register(
            TipListCell.self,
            forCellReuseIdentifier: TipListCell.reuseIdentifier
        )
    }
}


extension CategorizedTipViewController: View {
    func bind(reactor: CategorizedTipReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    func bindInput(reactor: CategorizedTipReactor) {
        rx.viewDidLoad
            .map { CategorizedTipReactor.Action.loadTips }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tipsTableView.rx.itemSelected
            .map { CategorizedTipReactor.Action.tipSelected($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindOutput(reactor: CategorizedTipReactor) {
        reactor.state
            .map { $0.tips }
            .bind(to: tipsTableView.rx.items(
                cellIdentifier: TipListCell.reuseIdentifier,
                cellType: TipListCell.self
            )) { _, tip, cell in
                cell.configureTipListCell(with: tip)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$pushSignal)
            .filter { $0 == true }
            .withLatestFrom(
                reactor.state.map {
                    $0.selectedTip
                }.compactMap {
                    $0
                }
            )
            .subscribe(onNext: { [weak self] tip in
                self?.coordinator?.pushToTipDetailView(with: tip.id)
            })
            .disposed(by: disposeBag)
    }
}
