//
//  UOCThirdViewController.swift
//  UoocTeacher
//
//  Created by 胡浩三雄 on 2018/5/7.
//  Copyright © 2018年 胡浩三雄. All rights reserved.
//

import UIKit

class UOCThirdViewController: BaseViewController {

    var square :UIView = {
        
        let viewk = UIView.init(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        viewk.backgroundColor = UIColor.orange
        
        return viewk
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        view.addSubview(square)
        
//        let centerX = view.bounds.size.width/2.0
//
//        let boundingRect = CGRect(x: centerX-75, y: 64+50, width: 150, height: 150)
//
//        let orbit = CAKeyframeAnimation(keyPath: "position")
//        orbit.duration = 3
//        orbit.path = CGPath.init(roundedRect: boundingRect, cornerWidth: 75, cornerHeight: 75, transform: nil)
//        orbit.calculationMode = kCAAnimationPaced
//        orbit.repeatCount = HUGE
//        orbit.rotationMode = kCAAnimationRotateAuto
//        square.layer.add(orbit, forKey: "Move")
        
        
        //旋转动画
        let rotateAnimation =  CAKeyframeAnimation(keyPath:"transform.rotation.z")
        rotateAnimation.values = [0,200 * Float.pi]
        
        //轨迹动画路径
        let centerX = view.bounds.size.width/2
        //创建用于转移坐标的Transform，这样我们不用按照实际显示做坐标计算
        let transform:CGAffineTransform = CGAffineTransform(translationX: centerX, y: 50)
        let path =  CGMutablePath()
        path.move(to: CGPoint(x:0 ,y:0), transform: transform)
        path.addLine(to: CGPoint(x:0 ,y:75), transform: transform)
        path.addLine(to: CGPoint(x:75 ,y:75), transform: transform)
        path.addArc(center: CGPoint(x:0 ,y:75), radius: 75, startAngle: 0,
                    endAngle: CGFloat(1.5 * .pi), clockwise: false, transform: transform)
        
        //轨迹动画
        let orbitAnimation = CAKeyframeAnimation(keyPath:"position")
        orbitAnimation.path = path
        orbitAnimation.calculationMode = kCAAnimationPaced
        
        //组合两个动画
        let animationgroup =  CAAnimationGroup()
        animationgroup.animations = [rotateAnimation, orbitAnimation]
        animationgroup.duration = 4
        animationgroup.repeatCount = HUGE
        square.layer.add(animationgroup,forKey:"Move")
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
