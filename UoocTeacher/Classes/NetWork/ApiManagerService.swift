//
//  ApiManagerService.swift
//  UoocTeacher
//
//  Created by 胡浩三雄 on 2018/4/19.
//  Copyright © 2018年 胡浩三雄. All rights reserved.
//

import Foundation
import Moya
import Result

class ApiManagerService {
    
    
    
    
}

public func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data //fallback to original data if it cant be serialized
    }
}


// MARK: - Provider support
public extension String {
    var urlEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}

//设置一个公共请求超时时间
public let requestClosure = { (endpoint: Endpoint, closure: (Result<URLRequest, MoyaError>) -> Void)  -> Void in
    do {
        var  urlRequest = try endpoint.urlRequest()
        urlRequest.timeoutInterval = 30.0
        urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        urlRequest.httpShouldHandleCookies = true
        closure(.success(urlRequest))
    } catch MoyaError.requestMapping(let url) {
        closure(.failure(MoyaError.requestMapping(url)))
    } catch MoyaError.parameterEncoding(let error) {
        closure(.failure(MoyaError.parameterEncoding(error)))
    } catch {
        closure(.failure(MoyaError.underlying(error, nil)))
    }
    
}
