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

enum RefreshStatus {
    case none
//    case beginHeaderRefresh
    case endHeaderRefresh
//    case beginFooterRefresh
    case endFooterRefresh
    case noMoreData
}

class ViewModel {
    
    let dataSource : Variable<[ActivityModel]> = Variable([])
    // 记录当前的索引值
    var page: Int = 1
    // 外界通过该属性告诉viewModel加载数据（传入的值是为了标志是否重新加载）
    let requestCommond = PublishSubject<Bool>()
    // 告诉外界的tableView当前的刷新状态
    let refreshStatus = Variable<RefreshStatus>(.none)
    
    let disposebag = DisposeBag()
    
}
    
extension ViewModel {
    
    func loadData()  {
        
        requestCommond.subscribe(onNext:{ [unowned self] isReloadData in
            
            if isReloadData { self.page = 1 }
                //假设下面的请求需要用到page
            APIProvider.rx.request(.appOperation(code: "app_course"))
                .filterSuccessfulStatusCodes()
                .asObservable()
                .mapObject(type: AppCourseModel.self)
                .subscribe(onNext: { model in
                    self.page += 1
                    
                    self.dataSource.value = isReloadData ? model.app_course : self.dataSource.value + model.app_course
                    
                    if model.app_course.count == 0 { self.refreshStatus.value = .noMoreData }
                    
                    SVProgressHUD.showSuccess(withStatus: "Load Success")
                }, onError: { error in
                    //处理throw异常
                    guard let rxError = error as? RxSwiftMoyaError else { return }
                    switch rxError {
                    case .UnexpectedResult(let resultCode, let resultMsg):
                        print("code = \(resultCode!),msg = \(resultMsg!)")
                        SVProgressHUD.showError(withStatus: "code = \(resultCode!),msg = \(resultMsg!)")
                    default :
                        print("网络故障")
                        SVProgressHUD.showError(withStatus: "网络故障")
                    }
                    
                }, onCompleted: {
                    self.refreshStatus.value = isReloadData ? .endHeaderRefresh : .endFooterRefresh
                }).disposed(by: self.disposebag)
        }).disposed(by: disposebag)
    }
    
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

