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


let APIProvider = MoyaProvider<APIService>.init(requestClosure: requestClosure,
                                                plugins:[NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter),
                                                         RequestLoadingPlugin.init(viewController: (UIApplication.shared.keyWindow?.rootViewController)!)])

public final class RequestLoadingPlugin: PluginType {
    
    private let viewController: UIViewController
    
    
    init(viewController: UIViewController) {
        self.viewController = viewController
        
    }
    
    
    public func willSend(_ request: RequestType, target: TargetType) {
        // show loading
        print("开始请求")
        

    }
    
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        // hide loading
        print("请求完成")

    }
}


enum APIService {
    case appOperation(code:String)
    case login(username:String,password:String)
}

extension APIService : TargetType {
    var baseURL: URL {
        return URL.init(string: ApiManager.instance.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .appOperation(_):
            return Api.app_course.rawValue
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


