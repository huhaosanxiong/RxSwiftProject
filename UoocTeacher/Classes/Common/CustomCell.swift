//
//  CustomCell.swift
//  UoocTeacher
//
//  Created by 胡浩三雄 on 2018/5/17.
//  Copyright © 2018年 胡浩三雄. All rights reserved.
//

import Foundation
//单元格类
class MyTableCell: UITableViewCell {
    
    private(set) var disposeBag = DisposeBag()
    
    var button:UIButton!
    
    //初始化
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        button = UIButton(frame:CGRect(x:0, y:0, width:40, height:25))
        button.setTitle("点击", for:.normal) //普通状态下的文字
        button.backgroundColor = UIColor.orange
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(button)
    }
    
    //布局
    override func layoutSubviews() {
        super.layoutSubviews()
        button.center = CGPoint(x: bounds.size.width - 35, y: bounds.midY)
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
}


