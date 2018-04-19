//
//  UOCSecondViewController.swift
//  UoocTeacher
//
//  Created by 胡浩三雄 on 2018/4/18.
//  Copyright © 2018年 胡浩三雄. All rights reserved.
//

import UIKit
import RxSwift
import Moya
import HandyJSON


class UOCSecondViewController: BaseViewController {

    let bag : DisposeBag = DisposeBag()
    
    let provider = MoyaProvider<APIService>()
    
    let VM = ViewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        action1()
//        action2()
//        action3()
        action4()
    }
    
    func action1() {
        provider.request(.appOperation(code: "app_course")) { (result) in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let statusCode = moyaResponse.statusCode
                do {
                    let dic = try moyaResponse.mapJSON()
                    print("dic = \(dic)")
                }catch {
                    
                }
                
                print("statusCode = \(statusCode)")
                print("data = \(data)")
                
                
            // do something with the response data or statusCode
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func action2() {
        
        APIProvider.rx.request(.appOperation(code: "app_course"))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .subscribe(onSuccess: { (resp) in
            print(resp)
                
                guard let object = resp as? [String: Any] else { return }
                guard let array = object["results"] as? [[String: Any]] else { return }
                
                print("array = \(array)")
                var dataSource  = [FuliModel]()
                
                for dict in array {
                    
                    guard let model: FuliModel = JSONDeserializer.deserializeFrom(dict: dict) else { return }
                    
                    dataSource.append(model)
                }
                
                
        }, onError: { (error) in
            print(error.localizedDescription)
        }).disposed(by: bag)

    }
    
    func action3() {
        
        VM.getAppOperation("app_course").subscribe(onNext: { (array) in
            print("array = \(array)")
            for model in array {
                print(model.activity1_title ?? "none")
            }
        }, onError: { (error) in
            print("error = \(error)")
        }, onCompleted: {
            print("complete")
        }).disposed(by: bag)
    }
    
    func action4() {
        
        VM.getAppOperationByMapObject("app_course").retry(3)
            .subscribe(onNext: { (model) in
            print("model = \(model)")
            for model in model.app_course {
                print(model.activity1_title ?? "none")
            }
        }, onError: { (error) in
            //处理throw异常
            guard let rxError = error as? RxSwiftMoyaError else { return }
            switch rxError {
            case .UnexpectedResult(let resultCode, let resultMsg):
                print("code = \(resultCode!),msg = \(resultMsg!)")
            default :
                print("网络故障")
            }
//            if case let RxSwiftMoyaError.UnexpectedResult(resultCode: code, resultMsg: msg) = error {
//                print("code = \(code!),msg = \(msg!)")
//            }else{
//                print("网络故障")
//            }
            print(error)
        }, onCompleted: {
            
        }).disposed(by: bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
