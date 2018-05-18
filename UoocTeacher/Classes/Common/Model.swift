//
//  Model.swift
//  UoocTeacher
//
//  Created by 胡浩三雄 on 2018/4/18.
//  Copyright © 2018年 胡浩三雄. All rights reserved.
//

import Foundation
import HandyJSON

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

struct SectionOfCustomData {
    var header : String
    var items : [Item]
}

extension SectionOfCustomData : SectionModelType {
    typealias Item = ActivityModel
    
    init(original: SectionOfCustomData, items: [Item]) {
        self = original
        self.items = items
    }
}

class AppCourseModel: HandyJSON {
    
    var app_course : [ActivityModel] = [ActivityModel]()
    
    required init() {
        
    }
}


