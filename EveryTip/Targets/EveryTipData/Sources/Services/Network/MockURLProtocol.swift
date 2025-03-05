//
//  MockURLProtocol.swift
//  EveryTipData
//
//  Created by 김경록 on 2/17/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import Alamofire
final class MockURLProtocol: URLProtocol {
    static var mockResponse: (data: Data?, response: HTTPURLResponse?, error: Error?)?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let response = MockURLProtocol.mockResponse?.response {
            client?.urlProtocol(
                self, didReceive: response,
                cacheStoragePolicy: .notAllowed
            )
        }

        if let data = MockURLProtocol.mockResponse?.data {
            client?.urlProtocol(self, didLoad: data)
        }

        if let error = MockURLProtocol.mockResponse?.error {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            client?.urlProtocolDidFinishLoading(self)
        }
    }

    override func stopLoading() {}
}

final class MockSession {
    static func getMockSession() -> Session {
        let configuration = URLSessionConfiguration.default
        // MockURLProtocol을 사용하도록 설정
        configuration.protocolClasses = [MockURLProtocol.self]
        return Session(configuration: configuration)
    }
}
