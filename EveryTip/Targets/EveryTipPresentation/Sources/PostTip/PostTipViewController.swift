//
//  PostTipViewController.swift
//  EveryTip
//
//  Created by 김경록 on 2/22/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDesignSystem

import SnapKit
import ReactorKit
import RxSwift

final class PostTipViewController: BaseViewController {
    
    //MARK: Properties
    
    weak var coordinator: PostTipViewCoordinator?
    var disposeBag: DisposeBag = DisposeBag()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(
            .et_getImage(for: .closeButton),
            for: .normal
        )
        button.tintColor = .black
        
        return button
    }()
    
    private let topTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "팁 추가"
        label.font = UIFont.et_pretendard(
            style: .semiBold,
            size: 18
        )
        
        return label
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(
            "등록",
            for: .normal
        )
        button.titleLabel?.font = UIFont.et_pretendard(
            style: .medium,
            size: 16
        )
        
        button.tintColor = .black
        
        return button
    }()
    
    private lazy var topStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        
        return stack
    }()
    
    private let choiceCategoryView: DetailDisclosureView = {
        return DetailDisclosureView(title: "카테고리 선택")
    }()
    
    private let categoryUnderLine: StraightLineView = StraightLineView(color: .et_brandColor4)
    
    private let hashtagView: DetailDisclosureView = {
        return DetailDisclosureView(title: "#태그 입력(최대 20개)")
    }()
    
    private let hashTagUnderLine: StraightLineView = StraightLineView(color: .et_brandColor4)
    
    private let titleTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "제목을 입력하세요"
        field.font = UIFont.et_pretendard(
            style: .semiBold,
            size: 20
        )
        
        return field
    }()
    
    private let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.text = "내용 입력"
        textView.textColor = UIColor.placeholderText
        textView.font = UIFont.et_pretendard(
            style: .medium,
            size: 16
        )
        
        textView.isScrollEnabled = true
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        
        return textView
    }()
    
    private let addPhotoCellButton: UIButton = {
        let button = UIButton(type: .system)
        var configuration = UIButton.Configuration.plain()
        configuration.image = .et_getImage(for: .addImage_fill)
        
        button.configuration = configuration
        
        return button
    }()
    
    private let selectedPhotosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 70, height: 70)
        layout.minimumInteritemSpacing = 13
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
 
        return collectionView
    }()
    
    private let bodyUnderLine: StraightLineView = StraightLineView(color: .et_brandColor4)
    
    private let addPhotoButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        let attributedTitle = AttributedString(
            "이미지",
            attributes: AttributeContainer([
                .font: UIFont.et_pretendard(style: .medium, size: 18)
            ])
        )
        configuration.attributedTitle = attributedTitle
        configuration.image = .et_getImage(for: .addImage_empty)
        configuration.baseForegroundColor = .et_textColor5
        
        configuration.imagePadding = 4
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        let button = UIButton(configuration: configuration)
        
        return button
    }()
    
    // MARK: Init
    
    init(reactor: PostTipReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupConstraints()
        bodyTextView.delegate = self
        closeButton.addTarget(
            nil,
            action: #selector(dismissView),
            for: .touchUpInside
        )
        
        self.navigationController?.isNavigationBarHidden = true
        setupCollectionView()
    }
    
    //MARK: Private Methods
    
    private func setupLayout() {
        view.addSubViews(
            topStackView,
            choiceCategoryView,
            categoryUnderLine,
            hashtagView,
            hashTagUnderLine,
            titleTextField,
            bodyTextView,
            bodyUnderLine,
            addPhotoCellButton,
            selectedPhotosCollectionView,
            addPhotoButton
        )
        
        topStackView.addArrangedSubViews(
            closeButton,
            topTitleLabel,
            confirmButton
        )
    }
    
    private func setupConstraints() {
        closeButton.snp.makeConstraints {
            $0.width.equalTo(confirmButton.snp.width)
        }
        
        topTitleLabel.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(closeButton.snp.width)
        }
        
        topStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(30)
        }
        
        choiceCategoryView.snp.makeConstraints {
            $0.top.equalTo(topStackView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(30)
        }
        
        categoryUnderLine.snp.makeConstraints {
            $0.top.equalTo(choiceCategoryView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        hashtagView.snp.makeConstraints {
            $0.top.equalTo(categoryUnderLine.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(30)
        }
        
        hashTagUnderLine.snp.makeConstraints {
            $0.top.equalTo(hashtagView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(hashTagUnderLine.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(24)
        }
        
        bodyTextView.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.bottom.equalTo(bodyUnderLine.snp.top).offset(5)
        }
        
        bodyUnderLine.snp.makeConstraints {
            $0.bottom.equalTo(addPhotoButton.snp.top).offset(-120)
            $0.leading.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        addPhotoCellButton.snp.makeConstraints {
            $0.top.equalTo(bodyUnderLine.snp.bottom).offset(16)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.height.width.equalTo(70)
            $0.bottom.equalTo(addPhotoButton.snp.top).offset(-20)
        }
        
        selectedPhotosCollectionView.snp.makeConstraints {
            $0.top.equalTo(bodyUnderLine.snp.bottom).offset(16)
            $0.leading.equalTo(addPhotoCellButton.snp.trailing).offset(10)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(80)
            $0.bottom.equalTo(addPhotoButton.snp.top).offset(-20)
        }
        
        addPhotoButton.snp.makeConstraints {
            $0.top.equalTo(selectedPhotosCollectionView.snp.bottom).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
        }
    }
    
    private func setupCollectionView() {
        selectedPhotosCollectionView.register(
            SelectedPhotoCell.self,
            forCellWithReuseIdentifier: SelectedPhotoCell.reuseIdentifier
        )
    }
    
    private func presentCategorySheet() -> Observable<Constants.Category> {
        return Observable.create { [weak self] observer in
            let alert = UIAlertController(
                title: "카테고리 선택",
                message: nil,
                preferredStyle: .actionSheet
            )
            
            for category in Constants.Category.allCases {
                let action = UIAlertAction(
                    title: category.title,
                    style: .default
                ) { _ in
                    observer.onNext(category)
                    observer.onCompleted()
                }
                alert.addAction(action)
            }
            
            alert.addAction(
                UIAlertAction(title: "취소", style: .cancel) { _ in
                    observer.onCompleted()
                }
            )
            
            self?.present(alert, animated: true)
            
            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc
    private func dismissView() {
        coordinator?.didFinish()
    }
}

extension PostTipViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "내용 입력" {
            textView.text = ""
            textView.textColor = UIColor.et_textColorBlack70
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "내용 입력"
            textView.textColor = .placeholderText
        }
    }
}

extension PostTipViewController: View {
    func bind(reactor: PostTipReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    func bindInput(reactor: PostTipReactor) {
        choiceCategoryView.tap
            .flatMapLatest{ [weak self] _ in
                self?.presentCategorySheet() ?? .empty()
            }
            .map { Reactor.Action.setCategoryButtonTapped($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        hashtagView.tap
            .subscribe(onNext: { [weak self] in
                let tagEditVC = EditTagViewController(tags: reactor.currentState.tags ?? [])
                tagEditVC.onConfirmButtonTapped = { [weak self] tags in
                    self?.reactor?.action.onNext(.setTagButtonTapped(tags))
                }
                
                self?.present(tagEditVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        addPhotoCellButton.rx.tap
            .map {
                Reactor.Action.addImageButtonTapped
            }.bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addPhotoButton.rx.tap
            .map {
                Reactor.Action.addImageButtonTapped
            }.bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        titleTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.titleChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        bodyTextView.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.contentChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .map { Reactor.Action.confirmButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindOutput(reactor: PostTipReactor) {
        reactor.state
            .compactMap { $0.category?.title }
            .bind {
                self.choiceCategoryView.updateTitle($0)
            }.disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.tags?.joined(separator: ",") }
            .distinctUntilChanged()
            .bind(to: Binder(self) { owner, tagString in
                owner.hashtagView.updateTitle(tagString)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedPhotos }
            .bind(to: selectedPhotosCollectionView.rx.items(
                cellIdentifier: SelectedPhotoCell.reuseIdentifier,
                cellType: SelectedPhotoCell.self)
            ) { index, imageData, cell in
                
                let image = UIImage(data: imageData.originalData)
                cell.updatePhoto(image)
                
                if index == 0 {
                    cell.setThumnail()
                } else {
                    cell.clearThumnail()
                }
            }.disposed(by: disposeBag)

        reactor.pulse(\.$imageSignal)
            .filter { $0 == true }
            .subscribe(onNext: { [weak self] _ in
                let vc = PhotoPickerViewController()
                vc.onConfirm = { [weak self] selectedPhotos in
                    self?.reactor?.action.onNext(.savePhoto(selectedPhotos)
                    )
                }
                self?.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$confirmSignal)
            .filter { $0 == true }
            .subscribe { [weak self] _ in
                self?.coordinator?.didFinish()
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$toastMessage)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind { [weak self] message in
                self?.showToast(message: message)
            }
            .disposed(by: disposeBag)
    }
}
