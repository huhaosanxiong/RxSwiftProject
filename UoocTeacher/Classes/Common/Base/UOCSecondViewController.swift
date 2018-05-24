//
//  UOCSecondViewController.swift
//  UoocTeacher
//
//  Created by 胡浩三雄 on 2018/4/18.
//  Copyright © 2018年 胡浩三雄. All rights reserved.
//

import UIKit



class UOCSecondViewController: BaseViewController, Refreshable {
    
    var disposeBag : DisposeBag = DisposeBag()
    
    let provider = MoyaProvider<APIService>()
    
    let VM = ViewModel()
    
    var req : [Cancellable] = [Cancellable]()
    
    var textField : UITextField = UITextField()
    
    lazy var tableView : UITableView = {
        
        let table = UITableView.init(frame: view.bounds)
    
        table.registerCell(ofType: MyTableCell.self)
        
        return table
        
    }()
    
    override func setNavigationItemsIsInEditMode(_ isInEditMode: Bool, animated: Bool) {
        super.setNavigationItemsIsInEditMode(isInEditMode, animated: animated)
        self.titleView.title = "Nav"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleView.style = self.titleView.style == QMUINavigationTitleViewStyle.default ? QMUINavigationTitleViewStyle.subTitleVertical : QMUINavigationTitleViewStyle.default;
        self.titleView.subtitle = self.titleView.style == QMUINavigationTitleViewStyle.subTitleVertical ? "(副标题)" : self.titleView.subtitle;
        
        // Do any additional setup after loading the view.
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsets.zero)
        }
        
        // 加载数据
        tableView.mj_header.beginRefreshing()
 
    }
    
    ///重写父类方法
    override func bindViewModel() {
        
        //配置上下拉刷新
        let refreshHeader = initRefreshHeader(tableView) { [weak self] in
            self?.VM.requestAction(isReloadData: true)
        }
        let refreshFooter = initRefreshFooter(tableView) { [weak self] in
            self?.VM.requestAction(isReloadData: false)
        }
        
        self.VM.autoSetRefreshControlStatus(header: refreshHeader, footer: refreshFooter).disposed(by: disposeBag)
        
        
        // Configure
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfCustomData>(configureCell: {(dataSource, tableView, indexPath, model) -> UITableViewCell in

            let cell = tableView.cell(ofType: MyTableCell.self)
            cell.textLabel?.text = "row \(indexPath.row) -> \(model.activity1_title!)"
            cell.button.rx.tap.subscribe(onNext: {
                DLog("row -> \(indexPath.row)")
            }).disposed(by: cell.disposeBag)
            
            return cell
        })
        
        //bind
        VM.rxDataSource.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        //获取选中项的内容
        tableView.rx.modelSelected(ActivityModel.self).subscribe(onNext: { model in
            print("点击\(model.activity1_title!)")
        }).disposed(by: disposeBag)
        
        //获取选中项的索引
        tableView.rx.itemSelected.subscribe(onNext: {[unowned self] indexPath in
            print("选中项的indexPath为：\(indexPath)")
            let cell = self.tableView.cellForRow(at: indexPath)
            cell?.shake()
        }).disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.modelSelected(ActivityModel.self),tableView.rx.itemSelected)
            .subscribe(onNext: {model, indexPath in
            print("合并 indexPath.row = \(indexPath.row),model.title = \(model.activity1_title!)")
        }).disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.itemDeleted,tableView.rx.modelDeleted(ActivityModel.self))
            .subscribe(onNext:{ [weak self] indexPath ,model in
                print("删除 indexPath.row = \(indexPath.row),model.title = \(model.activity1_title!)")
                self?.VM.dataSource.value.remove(at: indexPath.row)
            }).disposed(by: disposeBag)
        
        tableView.rx.itemDeleted.subscribe(onNext:{ indexPath in
            print("delete \(indexPath.row)")
        }).disposed(by: disposeBag)
        
        
        //必须实现UITableViewDelegate 不然报错
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    
    
    /// 无Rx 的Moya请求
    func action1() {
        
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
        }).disposed(by: disposeBag)
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
                print(error)
            }, onCompleted: {
                
            }).disposed(by: disposeBag)
    }
    
    func action5() {
        
        
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
            }.disposed(by: disposeBag)
    }
    
    
    
    
    func action6() {
        
        textField.frame = CGRect.init(x: 0, y: 64, width: 100, height:30)
        view.addSubview(textField)
        
        let text = textField.rx.text.orEmpty.asObservable()
        
        let passwordVaild = text.map{ $0.count>9 }
        let passwordHidden = textField.rx.isHidden
        
        passwordVaild.subscribeOn(MainScheduler.instance).observeOn(MainScheduler.instance).bind(to: passwordHidden).disposed(by: disposeBag)
        
        Observable.of(1,2,3).reduce(10, accumulator: +).subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        
        
    }
    
    func action7() {
        
        let button = UIButton()
        
        button.rx.tap
            .flatMap{ self.VM.getAppOperationByMapObject("app_course") }
            .subscribe(onNext: { model in
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
                
            }).disposed(by: disposeBag)
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
}



extension UOCSecondViewController :UITableViewDelegate {
    
    
}


