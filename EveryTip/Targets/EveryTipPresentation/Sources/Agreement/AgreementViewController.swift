//
//  AgreementViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 9/16/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit
import WebKit

import EveryTipDomain

import SnapKit
import RxSwift

final class AgreementViewController: BaseViewController {
    weak var coordinator: AgreementCoordinator?
    
    private let urlString: String = "https://maze-palladium-edf.notion.site/Every-Tip-22ac4b24d2e28058b1d2c6f66ba436f8?source=copy_link"
    
    private lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(
            frame: .zero,
            configuration: webConfiguration
        )
        webView.navigationDelegate = self
        return webView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebView()
        setupLayout()
        setupConstraints()
    }
    
    private func setupLayout() {
        view.addSubViews(webView, activityIndicator)
    }
    
    private func setupConstraints() {
        webView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func loadWebView() {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension AgreementViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
}
