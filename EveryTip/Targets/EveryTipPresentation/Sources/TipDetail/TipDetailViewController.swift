//
//  TipDetailViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 5/22/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDesignSystem

import SnapKit
import ReactorKit
import RxSwift
import Kingfisher

final class TipDetailViewController: BaseViewController {
    weak var coordinator: TipDetailCoordinator?
    var disposeBag: DisposeBag = DisposeBag()
    
    enum EllipsisButtonType {
        case tip
        case comment
    }
    
    private let backgroundScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    // MARK: 작성자
    
    private let writerView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let writerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.et_getImage(for: .blankImage)
        
        return imageView
    }()
    
    private let writerNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.et_pretendard(style: .semiBold, size: 14)
        label.textColor = .et_textColorBlack70
        
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.et_pretendard(style: .medium, size: 12)
        label.textColor = .et_textColorBlack30
        
        return label
    }()
    
    private let postWrittenTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.et_pretendard(style: .medium, size: 12)
        label.textColor = .et_textColorBlack10
        
        return label
    }()
    
    private let viewsImageView: UIImageView = {
        let imageView  = UIImageView()
        imageView.image = UIImage.et_getImage(for: .viewsImage)
        
        return imageView
    }()
    
    private let viewsCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.et_pretendard(style: .medium, size: 12)
        label.textColor = .et_textColorBlack10
        
        return label
    }()
    
    private let lineSeparator: StraightLineView = {
        let line = StraightLineView(color: UIColor.et_lineGray30)
        
        return line
    }()
    
    private let tipView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .et_pretendard(style: .semiBold, size: 20)
        label.textColor = .et_textColorBlack90
        
        return label
    }()
    
    private let mainTexLabel: UILabel = {
        let label = UILabel()
        label.font = .et_pretendard(style: .regular, size: 16)
        label.textColor = .et_textColorBlack70
        label.numberOfLines = 0
        
        return label
    }()
    
    private let tipImagesStackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        stack.spacing = 10

        return stack
    }()
    
    private let tagsCollectionView: UICollectionView = {
        let tagStyleLayout = TagStyleFlowLayout()
        tagStyleLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        tagStyleLayout.minimumInteritemSpacing = 6
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: tagStyleLayout
        )
        collectionView.isScrollEnabled = false
        
        return collectionView
    }()
    
    private let socialView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let likeButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        
        let button = UIButton(configuration: configuration)
        button.tintColor = .et_textColorBlack50
        
        return button
    }()
    
    private let shareButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = .et_getImage(for: .share)
        configuration.imagePadding = 6
        
        let attributedTitle = AttributedString(
            "공유하기",
            attributes: AttributeContainer([
                .font: UIFont.et_pretendard(style: .medium, size: 14)
            ])
        )
        configuration.attributedTitle = attributedTitle
        
        let button = UIButton(configuration: configuration)
        button.tintColor = .et_textColorBlack50
        
        return button
    }()
    
    private let saveButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = .et_getImage(for: .bookmark)
        configuration.imagePadding = 6
        
        let attributedTitle = AttributedString(
            "팁 저장",
            attributes: AttributeContainer([
                .font: UIFont.et_pretendard(style: .medium, size: 14)
            ])
        )
        configuration.attributedTitle = attributedTitle
        
        let button = UIButton(configuration: configuration)
        button.tintColor = .et_textColorBlack50
        
        return button
    }()
    
    private let bottomSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .et_lineGray20
        
        return view
    }()
    
    private let commentInfoView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let commentCountLabel: UILabel = {
        let label = UILabel()
        label.font = .et_pretendard(style: .bold, size: 16)
        
        return label
    }()
    
    private let commentSortButton: SortButton = {
        let button = SortButton(type: .system)
        button.configureButtonStyle(with: .latest)
        
        return button
    }()
    
    private let commentTableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    private let commentInputTextFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.et_lineGray30.cgColor
        view.layer.borderWidth = 1
        
        return view
    }()
    
    private let commentInputTextView: UITextView = {
        let textView = UITextView()
        textView.font = .et_pretendard(style: .bold, size: 14)
        textView.isScrollEnabled = false
        textView.text = "유용한 답변으로 팁 좋아요를 받아보세요 :)"
        textView.textColor = .et_textColor5
        
        return textView
    }()
    
    private let submitCommentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("입력", for: .normal)
        button.backgroundColor = .et_brandColor2
        button.layer.cornerRadius = 5
        button.tintColor = .white
        button.clipsToBounds = true
        
        return button
    }()
    
    init(reactor: TipDetailReactor) {
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
        setupTagCollectionView()
        setupCommentTableView()
        commentInputTextView.delegate = self
        navigationItem.rightBarButtonItem = rightButtonItem
        
    }
    
    private let ellipsisButton: UIButton = {
        let button = UIButton()
        button.setImage(.et_getImage(for: .ellipsis_black), for: .normal)
        
        button.tintColor = .et_textColorBlack90
        button.isHidden = true
        
        return button
    }()

    private lazy var rightButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(customView: ellipsisButton)
    }()

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        writerImageView.makeCircular()
        
        let height = tagsCollectionView.collectionViewLayout.collectionViewContentSize.height
        
        tagsCollectionView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
        
        updateTableViewHeight()
    }
    
    private func setupTagCollectionView() {
        tagsCollectionView.register(
            TagCollectionViewCell.self,
            forCellWithReuseIdentifier: TagCollectionViewCell.reuseIdentifier
        )
    }
    
    private func setupCommentTableView() {
        commentTableView.register(
            CommentTableViewCell.self,
            forCellReuseIdentifier: CommentTableViewCell.reuseIdentifier
        )
        
        commentTableView.rowHeight = UITableView.automaticDimension
        commentTableView.estimatedRowHeight = 78

        commentTableView.separatorStyle = .none
        commentTableView.isScrollEnabled = false
    }
    
    private func setupLayout() {
        view.addSubViews(
            backgroundScrollView,
            commentInputTextFieldView
        )
        
        backgroundScrollView.addSubview(contentView)
        
        contentView.addSubViews(
            writerView,
            lineSeparator,
            tipView,
            bottomSeparator,
            commentInfoView,
            commentTableView
        )
        
        commentInputTextFieldView.addSubViews(
            commentInputTextView,
            submitCommentButton
        )
        
        writerView.addSubViews(
            writerImageView,
            writerNameLabel,
            categoryLabel,
            postWrittenTimeLabel,
            viewsImageView,
            viewsCountLabel
        )
        
        tipView.addSubViews(
            titleLabel,
            mainTexLabel,
            tipImagesStackView,
            tagsCollectionView,
            socialView
        )
        
        socialView.addSubViews(
            likeButton,
            shareButton,
            saveButton
        )
        
        commentInfoView.addSubViews(
            commentCountLabel,
            commentSortButton
        )
    }
    
    private func updateTableViewHeight() {
        commentTableView.layoutIfNeeded()
        let contentHeight = commentTableView.contentSize.height + 20
        
        commentTableView.snp.updateConstraints {
            $0.height.equalTo(contentHeight)
        }
    }
    
    private func setupConstraints() {
        backgroundScrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(backgroundScrollView.contentLayoutGuide)
            $0.width.equalTo(backgroundScrollView.frameLayoutGuide)
        }
        
        writerView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(0)
            $0.leading.trailing.equalTo(contentView)
            $0.height.equalTo(68)
        }
        
        writerImageView.snp.makeConstraints {
            $0.top.equalTo(writerView.snp.top).offset(12)
            $0.leading.equalTo(writerView.snp.leading).offset(20)
            $0.width.height.equalTo(44)
        }
        
        writerNameLabel.snp.makeConstraints {
            $0.top.equalTo(writerView.snp.top).offset(16)
            $0.leading.equalTo(writerImageView.snp.trailing).offset(12)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(writerNameLabel.snp.bottom).offset(3)
            $0.leading.equalTo(writerImageView.snp.trailing).offset(12)
        }
        
        postWrittenTimeLabel.snp.makeConstraints {
            $0.top.equalTo(writerNameLabel.snp.bottom).offset(3)
            $0.leading.equalTo(categoryLabel.snp.trailing).offset(0)
        }
        
        viewsImageView.snp.makeConstraints {
            $0.centerY.equalTo(writerView.snp.centerY)
            $0.trailing.equalTo(writerView.snp.trailing).offset(-50)
        }
        
        viewsCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(writerView.snp.centerY)
            $0.leading.equalTo(viewsImageView.snp.trailing).offset(3)
            $0.trailing.equalTo(writerView.snp.trailing).offset(20)
        }
        
        lineSeparator.snp.makeConstraints {
            $0.top.equalTo(writerView.snp.bottom)
            $0.leading.trailing.equalTo(contentView).inset(20)
        }
        
        tipView.snp.makeConstraints {
            $0.top.equalTo(lineSeparator.snp.bottom)
            $0.leading.trailing.equalTo(contentView)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(tipView.snp.top).offset(24)
            $0.leading.trailing.equalTo(tipView).inset(20)
        }
        
        mainTexLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(tipView).inset(20)
        }
        
        tipImagesStackView.snp.makeConstraints {
            $0.height.equalTo(70)
            $0.top.equalTo(mainTexLabel.snp.bottom).offset(40)
            $0.leading.equalTo(tipView.snp.leading).offset(20)
            $0.trailing.lessThanOrEqualTo(tipView.snp.trailing).offset(-20)
        }
        
        tagsCollectionView.snp.makeConstraints {
            $0.top.equalTo(tipImagesStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(tipView).inset(20)
            $0.bottom.equalTo(socialView.snp.top)
                .offset(-20)
            $0.height.equalTo(0)
        }
        
        socialView.snp.makeConstraints {
            $0.top.equalTo(tagsCollectionView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(tipView).inset(48)
            $0.bottom.equalTo(tipView.snp.bottom).offset(-20)
            $0.height.equalTo(25)
        }
        
        likeButton.snp.makeConstraints {
            $0.centerY.equalTo(socialView)
            $0.trailing.equalTo(shareButton.snp.leading).offset(-27)
        }
        
        shareButton.snp.makeConstraints {
            $0.centerY.equalTo(socialView)
            $0.centerX.equalTo(socialView)
        }
        
        saveButton.snp.makeConstraints {
            $0.centerY.equalTo(socialView)
            $0.leading.equalTo(shareButton.snp.trailing).offset(29)
        }
        
        bottomSeparator.snp.makeConstraints {
            $0.top.equalTo(tipView.snp.bottom)
            $0.leading.trailing.equalTo(contentView)
            $0.height.equalTo(8)
        }
        
        commentInputTextFieldView.snp.makeConstraints {
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            $0.leading.trailing.equalTo(view)
            $0.height.equalTo(50)
        }
        
        commentInfoView.snp.makeConstraints {
            $0.top.equalTo(bottomSeparator.snp.bottom)
            $0.height.equalTo(50)
            $0.leading.trailing.equalTo(contentView)
        }
        
        commentCountLabel.snp.makeConstraints {
            $0.leading.equalTo(commentInfoView.snp.leading).offset(20)
            $0.centerY.equalTo(commentInfoView.snp.centerY)
        }
        
        commentSortButton.snp.makeConstraints {
            $0.trailing.equalTo(commentInfoView.snp.trailing).offset(-20)
            $0.centerY.equalTo(commentInfoView.snp.centerY)
        }
        
        commentTableView.snp.makeConstraints {
            $0.top.equalTo(commentInfoView.snp.bottom)
            $0.leading.trailing.equalTo(contentView)
            $0.height.equalTo(100)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-50)
        }
        
        commentInputTextView.snp.makeConstraints {
            $0.centerY.equalTo(commentInputTextFieldView.snp.centerY)
            $0.leading.equalTo(commentInputTextFieldView.snp.leading).offset(20)
            $0.trailing.equalTo(commentInputTextFieldView.snp.trailing).offset(-100)
        }
        
        submitCommentButton.snp.makeConstraints {
            $0.width.equalTo(48)
            $0.height.equalTo(30)
            $0.centerY.equalTo(commentInputTextFieldView.snp.centerY)
            $0.trailing.equalTo(commentInputTextFieldView.snp.trailing).offset(-20)
        }
    }
    
    private func updateLikeButton(for count: Int) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.plain()
        configuration.image = .et_getImage(for: .likeImage_empty)
        configuration.imagePadding = 6
        
        let attributedTitle = AttributedString(
            "좋아요 \(count)",
            attributes: AttributeContainer([
                .font: UIFont.et_pretendard(style: .medium, size: 14)
            ])
        )
        configuration.attributedTitle = attributedTitle
        
        return configuration
    }
    
    private func showDeleteAlert(
        contentType: EllipsisButtonType,
        confirmHandler: @escaping () -> Void
    ) {
        switch contentType {
        case .tip:
            let alertController = UIAlertController(
                title: "작성하신 팁을 삭제할까요?",
                message: nil,
                preferredStyle: .alert
            )
            
            let confirmAction = UIAlertAction(title: "예", style: .destructive) { _ in
                confirmHandler()
            }
            let cancleAction = UIAlertAction(title: "아니오", style: .cancel)
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancleAction)
            
            self.present(alertController, animated: true)
            
        case .comment:
            let alertController = UIAlertController(
                title: "댓글을 삭제할까요?",
                message: nil,
                preferredStyle: .alert
            )
            
            let confirmAction = UIAlertAction(title: "예", style: .destructive) { _ in
                confirmHandler()
            }
            let cancleAction = UIAlertAction(title: "아니오", style: .cancel)
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancleAction)
            
            self.present(alertController, animated: true)
        }
    }
}

extension TipDetailViewController: View {
    func bind(reactor: TipDetailReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    func bindInput(reactor: TipDetailReactor) {
        rx.viewDidLoad
            .map { _ in Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // TODO: 로그인 안되어있는 경우 동작 불가능하도록 개선 필요
        self.submitCommentButton.rx.tap
            .withLatestFrom(commentInputTextView.rx.text.orEmpty)
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .map { content in
                // 대댓글 기능 임시 미지원
                let parentID: Int? = nil
                return Reactor.Action.commentSubmitTapped(content: content, parentID: parentID)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        ellipsisButton.rx.tap
            .bind { [weak self] in
                self?.showDeleteAlert(contentType: .tip) {
                    self?.reactor?.action.onNext(.tipEllipsisTapped)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func bindOutput(reactor: TipDetailReactor) {
        reactor.state.compactMap { $0.tip }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] tip in
                if let writerImageUrlString = tip.writer.profileImage {
                    self?.writerImageView.kf.setImage(
                        with: URL(string: writerImageUrlString),
                        placeholder: UIImage.et_getImage(for: .blankImage)
                    )
                }
                
                if tip.isMine {
                    self?.ellipsisButton.isHidden = false
                }
                
                self?.writerNameLabel.text = tip.writer.name
                self?.categoryLabel.text = "\(tip.categoryName) ・ "
                self?.postWrittenTimeLabel.text = tip.createdAt.timeAgo()
                self?.viewsCountLabel.text = tip.views.toAbbreviatedString()
                self?.titleLabel.text = tip.title
                self?.mainTexLabel.text = tip.content
                let likeCount = tip.likes
                self?.likeButton.configuration = self?.updateLikeButton(for: likeCount)
            
                // TODO: 이미지 업로드 api 적용 후 수정 및 사진 확대 가능하도록 개선
                let images = tip.images
                
                if images.count == 0 {
                    self?.tipImagesStackView.snp.updateConstraints {
                        $0.height.equalTo(0)
                    }
                }
                
                for i in 0..<images.count {
                    let button = UIButton()
                    button.snp.makeConstraints {
                        $0.width.height.equalTo(70)
                    }
                    button.layer.cornerRadius = 10
                    button.clipsToBounds = true
                    
                    button.kf.setBackgroundImage(
                        with: URL(string: images[i].url),
                        for: .normal,
                        placeholder: .et_getImage(for: .blankImage)
                    )
                    self?.tipImagesStackView.addArrangedSubview(button)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.tip?.tags }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: tagsCollectionView.rx.items(
                cellIdentifier: TagCollectionViewCell.reuseIdentifier,
                cellType: TagCollectionViewCell.self)
            ) { _, tag, cell in
                cell.updateTag(tag)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.comment?.count }
            .map { "댓글 \($0 ?? 0)" }
            .observe(on: MainScheduler.instance)
            .bind(to: commentCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        // TODO: 댓글 작성 완료시 높이 조정 동작의 검토 필요
        reactor.state
            .compactMap { $0.comment }
            .observe(on: MainScheduler.instance)
            .bind(to: commentTableView.rx.items(
                cellIdentifier: CommentTableViewCell.reuseIdentifier,
                cellType: CommentTableViewCell.self)
            ) { _, data, cell in
                cell.configureCell(with: data)
                 
                // TODO: 현재 댓글 삭제 한번에 여러번 불가능 개선 필요
                cell.ellipsisTapped
                    .subscribe(onNext: { [weak self] in
                        self?.showDeleteAlert(contentType: .comment) {
                            reactor.action.onNext(.commnetEllipsisTapped(commentID: data.id))
                        }
                    })
                    .disposed(by: cell.disposeBag)
            }.disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.comment }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.updateTableViewHeight()
                }
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$toastMessage)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind { [weak self] message in
                self?.showToast(message: message)
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$popSignal)
            .filter { $0 == true }
            .bind { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
                self?.coordinator?.didFinish()
            }
            .disposed(by: disposeBag)
    }
}

extension TipDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "유용한 답변으로 팁 좋아요를 받아보세요 :)" {
            textView.text = ""
            textView.textColor = UIColor.et_textColorBlack70
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "유용한 답변으로 팁 좋아요를 받아보세요 :)"
            textView.textColor = .placeholderText
        }
    }
}
