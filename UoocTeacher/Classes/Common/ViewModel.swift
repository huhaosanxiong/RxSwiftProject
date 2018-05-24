//
//  ViewModel.swift
//  UoocTeacher
//
//  Created by 胡浩三雄 on 2018/4/18.
//  Copyright © 2018年 胡浩三雄. All rights reserved.
//

import Foundation



class ViewModel : RefreshProtocol {
    
    let dataSource : Variable<[ActivityModel]> = Variable([])
    
    let rxDataSource : Variable<[SectionOfCustomData]> = Variable([])
    
    // 记录当前的索引值
    var page: Int = 1
    // 外界通过该属性告诉viewModel加载数据（传入的值是为了标志是否重新加载）
    // 2018.4.28 觉得不需要用rx写这个操作，直接外部MJRefresh的回调里直接调用vm的方法，把是否重新加载的标识传进来即可
    var requestCommond = PublishSubject<Bool>()
    // 告诉外界的tableView当前的刷新状态
    let refreshStatus = Variable<RefreshStatus>(.none)
    
    let disposebag = DisposeBag()
    
}
    
extension ViewModel {
    
    ///目前可行写法
    func requestAction(isReloadData : Bool) {
        
        if isReloadData {self.page = 1}
        DLog("page = \(self.page)")
        APIProvider.rx.request(.appOperation(code: "app_course"))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .mapObject(type: AppCourseModel.self)
            .subscribe(onNext: { [weak self] model in
                
                self?.page += 1
                
                self?.dataSource.value = isReloadData ? model.app_course : (self?.dataSource.value)! + model.app_course
                
                //RxDataSources库
                self?.rxDataSource.value = isReloadData ?
                    [SectionOfCustomData(header:"",items:model.app_course)] :
                    [SectionOfCustomData(header:"",items:(self?.rxDataSource.value.first?.items)! + model.app_course)]
                
                self?.refreshStatus.value = isReloadData ? .endHeaderRefresh : .endFooterRefresh
                
                if model.app_course.count == 0 { self?.refreshStatus.value = .noMoreData }
                
            }, onError: { [weak self] error in
                //处理throw异常
                DLog("\(error.localizedDescription)")
                self?.refreshStatus.value = isReloadData ? .endHeaderRefresh : .endFooterRefresh
                guard let rxError = error as? RxSwiftMoyaError else {
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                    return
                }
                switch rxError {
                case .UnexpectedResult(let resultCode, let resultMsg):
                    SVProgressHUD.showError(withStatus: "code = \(resultCode!),msg = \(resultMsg!)")
                default :
                    DLog("网络故障")
                    SVProgressHUD.showError(withStatus: "网络故障")
                }  
            }, onCompleted: {

            }).disposed(by: disposebag)
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
    
    //只会执行一次
    func getAppOperationByMapObjectAsSingle(_ code :String) -> Single<AppCourseModel> {
        return APIProvider.rx.request(.appOperation(code: code))
            .asObservable()
            .filterSuccessfulStatusCodes()
            .mapObject(type: AppCourseModel.self)
            .asSingle()
    }
    
    //转成driver
    func getAppOperationByMapObjectAsDriver(_ code :String) -> Driver<[ActivityModel]> {
        return APIProvider.rx.request(.appOperation(code: code))
            .asObservable()
            .filterSuccessfulStatusCodes()
            .mapObject(type: AppCourseModel.self)
            .map{$0.app_course}
            .asDriver(onErrorDriveWith: Driver.empty())
    }
    
}

