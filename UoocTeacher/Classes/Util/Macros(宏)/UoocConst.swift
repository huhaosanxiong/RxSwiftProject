//
//  UoocConst.swift
//  SameUooc
//
//  Created by 汤命圳 on 2017/12/29.
//  Copyright © 2017年 Apple_TMZ. All rights reserved.
//

import UIKit



/// 屏幕的宽
let MAXWIDTH = UIScreen.main.bounds.size.width
/// 屏幕的高
let MAXHEIGHT = UIScreen.main.bounds.size.height
/// 状态栏的高度
let KmairmH = UIApplication.shared.statusBarFrame.height
///导航栏高度
let SafeAreaTopHeight = KmairmH + 44.0
///tabBar高度
let SafeAreaBottomHeight:CGFloat = (MAXHEIGHT == 812.0 ? 83.0 : 49.0)



/// 字体大小
func Font(size:CGFloat) -> UIFont {
    let s:CGFloat = size*MAXHEIGHT/375.0
    return UIFont.systemFont(ofSize: s)
}

///图片赋值
func imageName(image:String) -> UIImage {
    return UIImage(named:image)!
}

func FrameMake(x:CGFloat,y:CGFloat,w:CGFloat,h:CGFloat) -> CGRect {
   return CGRect(x: x, y: y, width: w, height: h)
}


///颜色的方法
func UIColorHexFromRGB(rgbValue: Int) -> (UIColor) {
    return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0,
                   green: ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0,
                   blue: ((CGFloat)(rgbValue & 0xFF)) / 255.0, alpha: 1.0)
}

/// 主色
let blueTextColor = UIColorHexFromRGB(rgbValue: 0x0b99ff)
let SixNineColor  = UIColorHexFromRGB(rgbValue: 0x696969)

