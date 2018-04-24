//
//  UOCDetailViewController.swift
//  UoocTeacher
//
//  Created by 胡浩三雄 on 2018/4/17.
//  Copyright © 2018年 胡浩三雄. All rights reserved.
//

import UIKit
import RxSwift
import Hero

class UOCDetailViewController: BaseViewController {

    let bag : DisposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Detail"
        self.titleView.subtitle = "interesting"
        
        view.backgroundColor = UIColor.qmui_random()
        // Do any additional setup after loading the view.
        
        let button = UIButton.init(type: .system)
        button.frame = CGRect.init(x: 100, y: 200, width: 200, height: 40)
        button.backgroundColor = UIColor.red
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("ok", for: .normal)
        view.addSubview(button)
        

        button.rx.tap.subscribe(onNext: { () in
            print("666")
            self.hero.dismissViewController()
            
        }).disposed(by: bag)

    }

    
    override func goback(button: UIButton) {
        super.goback(button: button)
        print("\(NSStringFromClass(self.classForCoder)) back")
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
