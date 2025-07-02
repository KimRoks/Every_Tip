//
//  EditTagViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/10/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import SnapKit

// TODO: 이 화면의 이동은 Coordinator를 통해 진행되고 있지않음. 화면 이동 방식 및 액션 전달 방식의 최종 결정 후 조정 될 수 있음.

final class EditTagViewController: BaseViewController {
    var onConfirmButtonTapped: (([String]) -> Void)?
    private var tags: [String] = []
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "태그 편집"
        label.font = .et_pretendard(style: .semiBold, size: 18)
        label.textColor = .et_textColorBlack90
        
        return label
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("완료", for: .normal)
        button.titleLabel?.font = .et_pretendard(style: .medium, size: 18)
        button.tintColor = .et_textColorBlack90
        
        return button
    }()
    
    private let tagTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "#태그를 입력해주세요 (최대 20개)"
        tf.font = .et_pretendard(style: .medium, size: 16)
        tf.textColor = .et_textColorBlack50
        
        return tf
    }()
    
    private let addTagButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+ 추가", for: .normal)
        button.titleLabel?.font = .et_pretendard(style: .medium, size: 16)
        button.tintColor = .et_textColorBlack50
        
        return button
    }()
    
    private let topSeparator: StraightLineView = {
        let line = StraightLineView(color: .et_lineGray40)
        
        return line
    }()
    
    private let tagsTableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    private let bottomSeparator: StraightLineView = {
        let line = StraightLineView(color: .et_lineGray40)
        
        return line
    }()
    
    private let removeAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("모두 지우기", for: .normal)
        button.titleLabel?.font = .et_pretendard(style: .bold, size: 16)
        button.tintColor = .et_textColor5
        
        return button
    }()
    
    init(tags: [String]) {
        self.tags = tags
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupConstraints()
        setupTableView()
        tagTextField.delegate = self
        addTagButton.addTarget(
            self,
            action: #selector(addTagButtonAction)
            , for: .touchUpInside
        )
        confirmButton.addTarget(
            self,
            action: #selector(confirmButtonAction),
            for: .touchUpInside
        )
        removeAllButton.addTarget(
            self,
            action: #selector(removeAllButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func setupLayout() {
        view.addSubViews(
            titleLabel,
            confirmButton,
            tagTextField,
            addTagButton,
            topSeparator,
            tagsTableView,
            bottomSeparator,
            removeAllButton
        )
    }
    
    private func setupConstraints() {
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(17)
            $0.centerX.equalTo(view)
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(17)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        tagTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(39)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-40)
        }
        
        addTagButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(39)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        topSeparator.snp.makeConstraints {
            $0.top.equalTo(addTagButton.snp.bottom).offset(14)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        tagsTableView.snp.makeConstraints {
            $0.top.equalTo(topSeparator.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-50)
        }
        
        bottomSeparator.snp.makeConstraints {
            $0.leading.trailing.equalTo(view)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-46)
        }
        
        removeAllButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-15)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-12)
        }
    }
    
    private func setupTableView() {
        tagsTableView.register(
            EditTagTableViewCell.self,
            forCellReuseIdentifier: EditTagTableViewCell.reuseIdentifier
        )
        
        tagsTableView.delegate = self
        tagsTableView.dataSource = self
        
        tagsTableView.rowHeight = UITableView.automaticDimension
        tagsTableView.estimatedRowHeight = 19
        tagsTableView.separatorStyle = .none
    }
    
    @objc
    private func addTagButtonAction() {
        guard var text = tagTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty
        else {
            showToast(message: "태그를 입력해주세요.")
            return
        }
        
        if tags.count >= 20 {
            showToast(message: "태그는 최대 20개까지 입력 가능해요.")
            return
        }
        
        
        if !text.hasPrefix("#") {
            text = "#" + text
        }
        
        tags.append(text)
        tagTextField.text = nil
        tagsTableView.reloadData()
    }
    
    @objc
    private func confirmButtonAction() {
        if tags == [] {
            self.dismiss(animated: true)
            return
        }
        onConfirmButtonTapped?(tags)
        self.dismiss(animated: true)
    }
    
    @objc
    func removeAllButtonTapped() {
        tags.removeAll()
        tagsTableView.reloadData()
    }
}

extension EditTagViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text,
              let textRange = Range(range, in: currentText) else {
            return false
        }
        
        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        
        if updatedText.count > 10 {
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addTagButtonAction()
        return false
    }
}

extension EditTagViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: EditTagTableViewCell.reuseIdentifier
        ) as? EditTagTableViewCell else {
            return UITableViewCell()
        }
        
        cell.updateTagLabel(tags[indexPath.row])
        cell.onRemoveButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.tags.remove(at: indexPath.row)
            self.tagsTableView.deleteRows(
                at: [indexPath],
                with: .automatic
            )
        }
        
        return cell
    }
}
