//
//  RevealAnimator.swift
//  O2Logo
//
//  Created by O2.LinYi on 16/3/22.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

class RevealAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let animationDuration = 2.0
    
    var operation: UINavigationControllerOperation = .Push
    
    weak var storedContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return animationDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        storedContext = transitionContext
        
        if operation == .Push {
            let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! MasterViewController
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! DetailViewController
            transitionContext.containerView()?.addSubview(toVC.view)
            
            let animation = CABasicAnimation(keyPath: "transform")
            
            animation.fromValue = NSValue(CATransform3D: CATransform3DIdentity)
            animation.toValue = NSValue(CATransform3D: CATransform3DConcat(CATransform3DMakeTranslation(0, -10, 0), CATransform3DMakeScale(150, 150, 1)))
            animation.duration = animationDuration
            animation.delegate = self
            animation.fillMode = kCAFillModeForwards
            animation.removedOnCompletion = false
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            
            toVC.maskLayer.addAnimation(animation, forKey: nil)
            fromVC.logo.addAnimation(animation, forKey: nil)

        } // if operation == .Push
        
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if let context = storedContext {
            context.completeTransition(!context.transitionWasCancelled())
            // reset logo
            let fromVC = context.viewControllerForKey(UITransitionContextFromViewControllerKey) as! MasterViewController
            fromVC.logo.removeAllAnimations()
            
        }
        
        storedContext = nil
    }
}
