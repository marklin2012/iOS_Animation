//
//  MasterViewController.swift
//  O2Logo
//
//  Created by O2.LinYi on 16/3/21.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

import QuartzCore

//
// Util delay function
//
func delay(seconds seconds: Double, completion:()->()) {
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
    
    dispatch_after(popTime, dispatch_get_main_queue()) {
        completion()
    }
}


class MasterViewController: UIViewController {
    
    let logo = RWLogoLayer.logoLayer()
    
    let transition = RevealAnimator()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.delegate = self
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // add the tap gesture recognizer
        let tap = UITapGestureRecognizer(target: self, action: "didTap")
        view.addGestureRecognizer(tap)
        
        // add the logo to the view
        logo.position = CGPoint(x: view.layer.bounds.size.width/2, y: view.layer.bounds.size.height/2 + 30)
        logo.fillColor = UIColor.whiteColor().CGColor
        view.layer.addSublayer(logo)
    }
    
    // MARK: - Gesture 
    func didTap() {
        performSegueWithIdentifier("details", sender: nil)
    }

}

extension MasterViewController: UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.operation = operation
        return transition
    }
}






