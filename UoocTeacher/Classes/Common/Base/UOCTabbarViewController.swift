//
//  UOCTabbarViewController.swift
//  UoocTeacher
//
//  Created by 胡浩三雄 on 2018/4/16.
//  Copyright © 2018年 胡浩三雄. All rights reserved.
//

import UIKit

class UOCTabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configViewControllers()
    }

    func configViewControllers() -> Void {
        
        let arr = [
            BaseViewController.init(),
            UOCSecondViewController.init(),
            BaseViewController.init()
        ]
        
        var navArr = [UINavigationController]()
        
        var itemArr = [
            ["title":"Home","image":"icon_weizhuanye","selectImage":"icon_weizhuanye_selected"],
            ["title":"Message","image":"tab_icon_faxian_default","selectImage":"tab_icon_faxian_pressed"],
            ["title":"Mine","image":"tab_icon_faxian_default","selectImage":"tab_icon_faxian_pressed"]
        ]
        
        for (index,vc) in arr.enumerated() {
            
            let dict = itemArr[index]
        
            let tabbarItem = returnBarItem(title: dict["title"], image: dict["image"], selectImage: dict["selectImage"])
            let nav = UOCNavigationViewController.init(rootViewController: vc)
            nav.isHeroEnabled = true
            nav.tabBarItem = tabbarItem
            
            navArr.append(nav)
        }
        
        setViewControllers(navArr, animated: true)
    }
    
    
    func returnBarItem(title :String? ,image :String? ,selectImage :String?) -> UITabBarItem {
        
        guard title != nil else {
            return UITabBarItem.init(title: "未知", image: nil, tag: 0)
        }
        
        return UITabBarItem.init(title: title, image: UIImage.init(named: image ?? ""), selectedImage: UIImage.init(named: selectImage ?? ""))
    }

}
