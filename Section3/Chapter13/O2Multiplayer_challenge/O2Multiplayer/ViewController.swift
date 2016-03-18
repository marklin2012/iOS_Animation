//
//  ViewController.swift
//  O2Multiplayer
//
//  Created by O2.LinYi on 16/3/17.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

//
// Util delay function
//
func delay(seconds seconds: Double, completion:()->()) {
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
    
    dispatch_after(popTime, dispatch_get_main_queue()) {
        completion()
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var myAvatar: AvatarView!
    @IBOutlet weak var opponentAvatar: AvatarView!
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var vs: UILabel!
    @IBOutlet weak var searchAgain: UIButton!
    
   
    
    
    // MARK: - Life Cycle
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        searchForOpponent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func actionSearchAgain() {
        UIApplication.sharedApplication().keyWindow?.rootViewController = storyboard!.instantiateViewControllerWithIdentifier("ViewController") as UIViewController
    }
    
    // MARK: - further methods
    func searchForOpponent() {
        let avatarSize = myAvatar.frame.size
        let bounceXOffset: CGFloat = avatarSize.width/1.9
        let morphSize = CGSize(width: avatarSize.width * 0.85, height: avatarSize.height * 1.1)
        
        let rightBouncePoint = CGPoint(x: view.frame.size.width/2.0 + bounceXOffset, y: myAvatar.center.y)
        
        let leftBouncePoint = CGPoint(x: view.frame.size.width/2.0 - bounceXOffset, y: myAvatar.center.y)
        
        myAvatar.bounceOffPoint(rightBouncePoint, morphSize: morphSize)
        opponentAvatar.bounceOffPoint(leftBouncePoint, morphSize: morphSize)
        
        delay(seconds: 4) { () -> () in
            self.foundOpponent()
        }
    }
    
    func foundOpponent() {
        status.text = "Connectiong..."
        
        opponentAvatar.image = UIImage(named: "avatar-2")
        opponentAvatar.name = "Ray"
        delay(seconds: 4) { () -> () in
            self.connectedToOpponent()
        }
    }
    
    func connectedToOpponent() {
        myAvatar.shouldTransitionToFinishedState = true
        opponentAvatar.shouldTransitionToFinishedState = true
        
        delay(seconds: 1) { () -> () in
            self.completed()    
        }
    }
    
    func completed() {
        status.text = "Ready to play"
        UIView.animateWithDuration(0.2, animations: { _ in
            self.vs.alpha = 1
            self.searchAgain.alpha = 1
            
        })
    }
    


}

