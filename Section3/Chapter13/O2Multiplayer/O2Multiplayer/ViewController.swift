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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func actionSearchAgain() {
        UIApplication.sharedApplication().keyWindow?.rootViewController = storyboard!.instantiateViewControllerWithIdentifier("ViewController") as UIViewController
    }
    


}

