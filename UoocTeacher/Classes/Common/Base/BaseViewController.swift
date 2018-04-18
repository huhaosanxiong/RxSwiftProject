//
//  BaseViewController.swift
//  UoocTeacher
//
//  Created by 胡浩三雄 on 2018/4/16.
//  Copyright © 2018年 胡浩三雄. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxBlocking
import HandyJSON
import Material
import Hero
import Kingfisher
import Moya

class BaseViewController: QMUICommonViewController {
    
    lazy var disposeBag : DisposeBag = DisposeBag()
    
    var pushButton : UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.qmui_random()
        
        self.titleView.style = self.titleView.style == QMUINavigationTitleViewStyle.default ? QMUINavigationTitleViewStyle.subTitleVertical : QMUINavigationTitleViewStyle.default;
        self.titleView.subtitle = self.titleView.style == QMUINavigationTitleViewStyle.subTitleVertical ? "(副标题)" : self.titleView.subtitle;
        
        
        if (navigationController != nil) && (navigationController?.viewControllers.count)! > 1 {
            self.navigationItem.hidesBackButton = true;
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: Icon.arrowBack, style: UIBarButtonItemStyle.plain, target: self, action: #selector(goback(button:)))
            self.navigationItem.leftItemsSupplementBackButton = true;
        }
        
        
    }

    override func setNavigationItemsIsInEditMode(_ isInEditMode: Bool, animated: Bool) {
        super.setNavigationItemsIsInEditMode(isInEditMode, animated: animated)
        title = "Nav"
    }
    
    override func initSubviews() {
        
        pushButton = UIButton.init(type: .system)
        pushButton.setTitle("Push", for: .normal)
        pushButton.setTitleColor(UIColor.white, for: .normal)
        pushButton.backgroundColor = Color.blue.base
        pushButton.heroID = "push"
        view.addSubview(pushButton)

        
        pushButton.rx.tap.subscribe(onNext: { () in
            print("666")
            
            let vc = UOCDetailViewController()
            vc.isHeroEnabled = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }).disposed(by: disposeBag)

        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        pushButton.frame = CGRect.init(x: 100, y: Int(arc4random()%300+64), width: 200, height: 40)
        
    }

    @objc func goback(button : UIButton){
        
        if (navigationController?.viewControllers.count)!>1 {
            navigationController?.popViewController(animated: true)
        }
        print("back")
    }
    
}

