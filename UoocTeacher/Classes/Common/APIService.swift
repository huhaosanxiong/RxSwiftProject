//
//  APIService.swift
//  UoocTeacher
//
//  Created by 胡浩三雄 on 2018/4/18.
//  Copyright © 2018年 胡浩三雄. All rights reserved.
//

import Foundation
import Moya
import Result

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data //fallback to original data if it cant be serialized
    }
}
// MARK: - Provider support
private extension String {
    var urlEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

public final class RequestLoadingPlugin: PluginType {
    
    public func willSend(_ request: RequestType, target: TargetType) {
        // show loading
        print("开始请求")
    }
    
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        // hide loading
        print("请求完成")
    }
    
}

let APIProvider = MoyaProvider<APIService>(plugins:[NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter),RequestLoadingPlugin()])

//let APIProvider = MoyaProvider<APIService>()

enum APIService {
    case appOperation(code:String)
    case login(username:String,password:String)
}

extension APIService : TargetType {
    var baseURL: URL {
        return URL.init(string: "http://www.uooconline.com")!
    }
    
    var path: String {
        switch self {
        case .appOperation(_):
            return "/index/appOperation"
        case .login(let username, let password):
            return "/\(username)/\(password)"
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .appOperation:
            return .get
        case .login( _, _):
            return .post
        }
    }
    
    var sampleData: Data {
        return "".utf8Encoded
    }
    
    var task: Task {
        
        switch self {
        case .appOperation(let code):
            return .requestParameters(parameters: ["code":code], encoding: URLEncoding.default)
        case .login(let username, let password):
            return .requestParameters(parameters: ["username":username,"password":password], encoding:URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type" : "application/json",
                "sourceFlag":"iOS",
                "productFlag":"iPhone 6s",
                "versionFlag" : "1.2.0",
                "xgTokenFlag":"ca479511365a8069cb5be265947099587fb7cc7ddf8705ce437948513c890f94",
                "machineFlag":"25724d7cefe11039149a91b5d72ea2d2"]
    }
    
    
}

private extension String {
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
