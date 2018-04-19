//
//  RxSwift+Observable.swift
//  UoocTeacher
//
//  Created by 胡浩三雄 on 2018/4/19.
//  Copyright © 2018年 胡浩三雄. All rights reserved.
//

import Foundation
import RxSwift
import HandyJSON
import Moya

let RESP_CODE = "code"
let RESP_DATA = "data"
let RESP_MSG = "msg"

enum RxSwiftMoyaError : Swift.Error {
    // 解析失败
    case ParseJSONError
    // 网络请求发生错误
    case RequestFailed
    // 接收到的返回没有data
    case NoResponse
    //服务器返回了一个错误代码
    case UnexpectedResult(resultCode: Int?, resultMsg: String?)
}

enum RequestStatus: Int {
    case RequestSuccess = 1
    case RequestError
}

public extension Observable {
    
    func mapObject<H: HandyJSON>(type :H.Type) -> Observable<H> {
        
        return map{ response in
            
            //返回response
            guard let response = response as? Response else {
                throw RxSwiftMoyaError.NoResponse
            }
            
            //检查状态码
            guard ((200...209) ~= response.statusCode) else {
                throw RxSwiftMoyaError.RequestFailed
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions(rawValue: 0))  as! [String : Any] else {
                throw RxSwiftMoyaError.NoResponse
            }
            
            //判断返回code
            if let code = json[RESP_CODE] as? Int {
                if code == RequestStatus.RequestSuccess.rawValue {
                    let data = json[RESP_DATA]
                    if let data = data as? [String:Any] {
                        let object = JSONDeserializer<H>.deserializeFrom(dict: data)
                        if object != nil {
                            return object!
                        }else {
                            throw RxSwiftMoyaError.ParseJSONError
                        }
                    }else {
                        throw RxSwiftMoyaError.ParseJSONError
                    }
                }else {
                    throw RxSwiftMoyaError.UnexpectedResult(resultCode: json[RESP_CODE] as? Int, resultMsg: json[RESP_MSG] as? String)
                }
            }else{
                throw RxSwiftMoyaError.ParseJSONError
            }
        }
    }
    
    func mapArray<H: HandyJSON>(type :H.Type) -> Observable<[H]> {
        
        return map{ response in
            
            //返回response
            guard let response = response as? Response else {
                throw RxSwiftMoyaError.NoResponse
            }
            
            //检查状态码
            guard ((200...209) ~= response.statusCode) else {
                throw RxSwiftMoyaError.RequestFailed
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions(rawValue: 0))  as! [String : Any] else {
                throw RxSwiftMoyaError.NoResponse
            }
            
            //判断返回code
            if let code = json[RESP_CODE] as? Int {
                if code == RequestStatus.RequestSuccess.rawValue {
                    guard let objectsArray = json[RESP_DATA] as? [[String:Any]] else {
                        throw RxSwiftMoyaError.ParseJSONError
                    }
                    
                    if let modelArray = JSONDeserializer<H>.deserializeModelArrayFrom(array: objectsArray) {
                        if let modelArr = modelArray as? [H] {
                            return modelArr
                        }else{
                            throw RxSwiftMoyaError.ParseJSONError
                        }
                    }else{
                        throw RxSwiftMoyaError.ParseJSONError
                    }
                }else {
                    throw RxSwiftMoyaError.UnexpectedResult(resultCode: json[RESP_CODE] as? Int, resultMsg: json[RESP_MSG] as? String)
                }
            }else{
                throw RxSwiftMoyaError.ParseJSONError
            }
        }
    }
}




