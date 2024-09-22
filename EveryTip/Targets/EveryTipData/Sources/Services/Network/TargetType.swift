//
//  TargetType.swift
//  EveryTipData
//
//  Created by 김경록 on 9/5/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//
import Foundation

import Alamofire

protocol TargetType {
    var baseURL: String { get }
    var method: HTTPMethods { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
}

extension TargetType {
    var baseURL: String {
        if let baseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String {
            return baseURL
        } else {
            print(NetworkError.baseURLError)
            return ""
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let fullUrl = try? (baseURL + path).asURL() else {
            throw NetworkError.invalidURLError
        }
        
        var urlRequest = URLRequest(url: fullUrl)
        urlRequest.httpMethod = method.rawValue
        
        if let headers = headers {
            for (key, value) in headers {
                urlRequest.addValue(value,forHTTPHeaderField: key)
            }
        }
        
        switch method {
        case .get: urlRequest = try
            // Get인 경우 url쿼리로 인코딩
            URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            // Post, Put인 경우 Json인코딩
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
}
