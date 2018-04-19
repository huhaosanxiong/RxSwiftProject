//
//  Model.swift
//  UoocTeacher
//
//  Created by 胡浩三雄 on 2018/4/18.
//  Copyright © 2018年 胡浩三雄. All rights reserved.
//

import Foundation
import HandyJSON

class FuliModel: HandyJSON {
    var _id: Int = 0
    var createdAt: String!
    var desc: String!
    var publishedAt: String!
    var source: String!
    var type: String!
    var url: String!
    var used: Bool = false
    var who: String!
    
    required init() {
        
    }
}

class ActivityModel: HandyJSON {
    
    var activity1_id: String?
    var activity1_img_url: String?
    var activity1_url: String?
    var activity1_app_h5_url: String?
    var activity1_title: String?
    var activity1_type: String?
    
    required init() {
        
    }
}

class AppCourseModel: HandyJSON {
    
    var app_course : [ActivityModel] = [ActivityModel]()
    
    required init() {
        
    }
    
}

class BaseModel: HandyJSON {
    
    var code: Int = 0
    var data: Any?
    var msg: String?
    
    required init() {
    }
}

