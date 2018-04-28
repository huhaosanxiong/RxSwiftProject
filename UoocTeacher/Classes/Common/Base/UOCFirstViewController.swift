//
//  UOCFirstViewController.swift
//  UoocTeacher
//
//  Created by 胡浩三雄 on 2018/4/26.
//  Copyright © 2018年 胡浩三雄. All rights reserved.
//

import UIKit

class UOCFirstViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        let button = UIButton.init(type: .system)
        button.setTitle("push", for: .normal)
        button.addTarget(self, action: #selector(pushAction), for: .touchUpInside)
        view.addSubview(button)
        
        button.snp.makeConstraints { (make) in
            make.center.equalTo(view.snp.center)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        
    }
    
    
    
    override func shouldCustomNavigationBarTransitionIfBarHiddenable() -> Bool {
        return true
    }
    
    override func preferredNavigationBarHidden() -> Bool {
        return arc4random()%2 == 1 ? true :false
    }
    @objc func pushAction() {
        navigationController?.pushViewController(UOCFirstViewController(), animated: true)
    }
    
    override func setNavigationItemsIsInEditMode(_ isInEditMode: Bool, animated: Bool) {
        super.setNavigationItemsIsInEditMode(isInEditMode, animated: animated)
        self.titleView.title = "First"
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
