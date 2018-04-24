//
//  UOCSecondViewController.swift
//  UoocTeacher
//
//  Created by 胡浩三雄 on 2018/4/18.
//  Copyright © 2018年 胡浩三雄. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import HandyJSON
import MJRefresh


class UOCSecondViewController: BaseViewController {
    
    var bag : DisposeBag = DisposeBag()
    
    let provider = MoyaProvider<APIService>()
    
    let VM = ViewModel()
    
    var req : [Cancellable] = [Cancellable]()
    
    var textField : UITextField = UITextField()
    
    lazy var tableView : UITableView = {
        
        let table = UITableView.init(frame: view.bounds)
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        table.delegate = self as? UITableViewDelegate
        
        table.tableFooterView = UIView.init()
        
        return table
        
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(tableView)
        
//        action1()
//        action2()
//        action3()
//        action4()
//        action5()
//        action6()
//        action7()
//        action8()
//        action9()
        
        bindViewModel()
        // 加载数据
        tableView.mj_header.beginRefreshing()
        pushButton .addTarget(self, action: #selector(action1), for: .touchUpInside)
    }
    func bindViewModel() {
        
        
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.VM.requestCommond.onNext(true)
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.VM.requestCommond.onNext(false)
        })
        VM.loadData()
        VM.refreshStatus.asObservable().subscribe(onNext: {[weak self] status in
            switch status {
            case .endHeaderRefresh:
                self?.tableView.mj_header.endRefreshing()
            case .endFooterRefresh:
                self?.tableView.mj_footer.endRefreshing()
            case .noMoreData:
                self?.tableView.mj_footer.endRefreshingWithNoMoreData()
            default:
                break
            }
        }).disposed(by: bag)
        
        VM.dataSource.asObservable().bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
            
            cell.textLabel?.text = "row \(row) -> \(element.activity1_title!)"
            }
            .disposed(by: disposeBag)
    }
        
       @objc func action1() {
        
        req.forEach { $0.cancel()}
        
          let request = provider.request(.appOperation(code: "app_course")) { (result) in
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
        
        req.append(request)
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
        
        @objc func action5() {
            
            
            VM.getAppOperationByMapObjectAsSingle("app_course").subscribe(onSuccess: { (model) in
                print("model = \(model)")
                for model in model.app_course {
                    print(model.activity1_title ?? "none")
                }
            }) { (error) in
                //处理throw异常
                guard let rxError = error as? RxSwiftMoyaError else { return }
                switch rxError {
                case .UnexpectedResult(let resultCode, let resultMsg):
                    print("code = \(resultCode!),msg = \(resultMsg!)")
                default :
                    print("网络故障")
                }
                print(error)
                }.disposed(by: bag)
        }
        
        
        
        
        func action6() {
            
            textField.frame = CGRect.init(x: 0, y: 64, width: 100, height:30)
            view.addSubview(textField)
            
            let text = textField.rx.text.orEmpty.asObservable()
            
            let passwordVaild = text.map{
                $0.count>9
            }
            let passwordHidden = textField.rx.isHidden
            
            passwordVaild.subscribeOn(MainScheduler.instance).observeOn(MainScheduler.instance).bind(to: passwordHidden).disposed(by: bag)
            
            Observable.of(1,2,3).reduce(10, accumulator: +).subscribe(onNext: {print($0)}).disposed(by: bag)
            
            
            
        }
        
        func action7() {
            
            
            pushButton.rx.tap
                .flatMap{ self.VM.getAppOperationByMapObject("app_course") }
                .subscribe(onNext: { [weak self] model in
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
                    print(error)
                }, onCompleted: {

                }).disposed(by: bag)
            
            
//            pushButton.rx.tap
//                .flatMap{self.VM.getAppOperationByMapObjectAsSingle("app_course")}
//                .asSingle()
//                .subscribe(onSuccess: { (model) in
//                print("model = \(model)")
//                for model in model.app_course {
//                    print(model.activity1_title ?? "none")
//                }
//            }) { (error) in
//                //处理throw异常
//                guard let rxError = error as? RxSwiftMoyaError else { return }
//                switch rxError {
//                case .UnexpectedResult(let resultCode, let resultMsg):
//                    print("code = \(resultCode!),msg = \(resultMsg!)")
//                default :
//                    print("网络故障")
//                }
//                print(error)
//                }.disposed(by: bag)
            
            
            pushButton.rx.tap.flatMap{self.VM.getAppOperationByMapObjectAsSingle("app_course")}
                .asSingle()
                .subscribe(onSuccess: { [weak self] model in

                }) { (error) in

                }.disposed(by: bag)
 
        }
        
        
        func action8() {
            
            VM.dataSource.asObservable().subscribe(onNext: { arr in
                print("arr = \(arr)")
            }).disposed(by: bag)
            
            VM.requestAction("app_course")
            
        }
    
    func action9() {
        
        view.addSubview(tableView)
        
        VM.requestAction("app_course")
        
        VM.dataSource.asObservable().bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
            
            cell.textLabel?.text = "row \(row) -> \(element.activity1_title!)"
            }
            .disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
}

extension UOCSecondViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = VM.dataSource.value[indexPath.row]
        print("\(model.activity1_title!)")
    }
}






