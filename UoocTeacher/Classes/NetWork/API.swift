//
//  API.swift
//  UoocTeacher
//
//  Created by 胡浩三雄 on 2018/4/23.
//  Copyright © 2018年 胡浩三雄. All rights reserved.
//

import Foundation

enum Environment : String {
    case Product = "http://www.uooconline.com"
    case Beta = "http://beta.uooconline.com"
    case Test = "http://test.uooconline.com"
    case Underline = "http://192.168.1.210"
}

class ApiManager {
    
    static let instance = ApiManager.init()
    
    var baseUrl : String = Environment.Test.rawValue
    
    private init() {}
    
}

enum Api : String {
    
    case app_course = "/index/appOperation"
}
