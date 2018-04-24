//
//  NilSwift.swift
//  UoocTeacher
//
//  Created by 胡浩三雄 on 2018/4/20.
//  Copyright © 2018年 胡浩三雄. All rights reserved.
//

import Foundation
import UIKit
import Hero

class HeroHelper: NSObject {
    
    func configureHero(in navigationController: UINavigationController) {
        guard let topViewController = navigationController.topViewController else { return }
        
        topViewController.isHeroEnabled = true
        navigationController.heroNavigationAnimationType = .fade
        navigationController.isHeroEnabled = true
        navigationController.delegate = self
    }
}

//Navigation Popping
private extension HeroHelper {
    private func addEdgePanGesture(to view: UIView) {
        let pan = UIScreenEdgePanGestureRecognizer(target: self, action:#selector(popViewController(_:)))
        pan.edges = .left
        view.addGestureRecognizer(pan)
    }
    
    @objc private func popViewController(_ gesture: UIScreenEdgePanGestureRecognizer) {
        guard let view = gesture.view else { return }
        let translation = gesture.translation(in: nil)
        let progress = translation.x / 2 / view.bounds.width
        
        switch gesture.state {
        case .began:
            let vc = UIApplication.shared.windows.first?.rootViewController
            vc?.hero_dismissViewController()
        case .changed:
            Hero.shared.update(progress)
        default:
            if progress + gesture.velocity(in: nil).x / view.bounds.width > 0.3 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
        }
    }
}


//Navigation Controller Delegate
extension HeroHelper: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return Hero.shared.navigationController(navigationController, interactionControllerFor: animationController)
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            addEdgePanGesture(to: toVC.view)
        }
        return Hero.shared.navigationController(navigationController, animationControllerFor: operation, from: fromVC, to: toVC)
    }
}
