//
//  BaseViewController.swift
//  UoocTeacher
//
//  Created by 胡浩三雄 on 2018/4/16.
//  Copyright © 2018年 胡浩三雄. All rights reserved.
//

import UIKit

class BaseViewController: QMUICommonViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.qmui_random()
        
        if (navigationController != nil) && (navigationController?.viewControllers.count)! > 1 {
            self.navigationItem.hidesBackButton = true;
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: Icon.arrowBack, style: UIBarButtonItemStyle.plain, target: self, action: #selector(goback(button:)))
            self.navigationItem.leftItemsSupplementBackButton = true;
            
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        }
        
        bindViewModel()
    }

    
    override func initSubviews() {
        
        
    }
    
    func bindViewModel() {
        
    }

    @objc func goback(button : UIButton){
        
        if (navigationController?.viewControllers.count)!>1 {
            navigationController?.popViewController(animated: true)
        }
        print("back")
    }
    
}

