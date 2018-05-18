//
//  Log.swift
//  UoocTeacher
//
//  Created by 胡浩三雄 on 2018/5/17.
//  Copyright © 2018年 胡浩三雄. All rights reserved.
//

import Foundation


func DLog<T>(_ message:T, file: String = #file, function: String = #function, line: Int = #line) {
    
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    let date = Date()
    let dateString = dateFormatter.string(from: date)
    print("")
    print("\(dateString) [\(fileName) \(function) [Line \(line)]] \(message)")

    #endif
}
