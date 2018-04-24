//
//  ViewModel.swift
//  UoocTeacher
//
//  Created by 胡浩三雄 on 2018/4/18.
//  Copyright © 2018年 胡浩三雄. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import HandyJSON
import SVProgressHUD

enum RefreshType {
    case loadNew
    case loadMore
}

class ViewModel {
    
    let dataSource : Variable<[ActivityModel]> = Variable([])
    
    let disposebag = DisposeBag()
    
    
    func requestAction(_ code :String) {
        
        SVProgressHUD.show()
        APIProvider.rx.request(.appOperation(code: code))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .mapObject(type: AppCourseModel.self)
            .asSingle()
            .subscribe(onSuccess: { model in
                SVProgressHUD.dismiss()
                
                self.dataSource.value = model.app_course
                
            }) { error in
                SVProgressHUD.dismiss()
                
            }.disposed(by: disposebag)
        
    }
    
    
    func login(_ username: String,_ password: String) -> Observable<BaseModel> {

        return APIProvider.rx.request(.login(username: username, password: password))
            .asObservable()
            .filterSuccessfulStatusCodes()
            .mapObject(type: BaseModel.self)

    }
    
    //手动转 ，与oc类似
    func getAppOperation(_ code: String) -> Observable<[ActivityModel]> {
        
        return APIProvider.rx.request(.appOperation(code: code))
            .asObservable()
            .filterSuccessfulStatusCodes()
            .map{ response in
                
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
                        
                        guard let app_course = json[RESP_DATA] as? [String:Any] else { throw RxSwiftMoyaError.ParseJSONError }
                        guard let objectsArray = app_course["app_course"] as? [[String:Any]] else { throw RxSwiftMoyaError.ParseJSONError }
                        
                        if let modelArray = JSONDeserializer<ActivityModel>.deserializeModelArrayFrom(array: objectsArray) {
                            if let modelArr = modelArray as? [ActivityModel] {
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
    
    
    
    //通过mapObject 去 json -> model
    func getAppOperationByMapObject(_ code :String) -> Observable<AppCourseModel> {
        
        return APIProvider.rx.request(.appOperation(code: code))
        .asObservable()
        .filterSuccessfulStatusCodes()
        .mapObject(type: AppCourseModel.self)
    }
    
    func getAppOperationByMapObjectAsSingle(_ code :String) -> Single<AppCourseModel> {
        return APIProvider.rx.request(.appOperation(code: code))
            .asObservable()
            .filterSuccessfulStatusCodes()
            .mapObject(type: AppCourseModel.self)
            .asSingle()
    }
    
    
}

