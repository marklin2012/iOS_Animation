//
//  ViewController.swift
//  O2UIViewAnimation
//
//  Created by O2.LinYi on 16/3/10.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

// a delay function
func delay(seconds seconds: Double, completion: () -> ()) {
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * seconds))
    dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
        completion()
    }
}

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var headingLabel: UILabel!
    
    @IBOutlet weak var cloud1: UIImageView!
    @IBOutlet weak var cloud2: UIImageView!
    @IBOutlet weak var cloud3: UIImageView!
    @IBOutlet weak var cloud4: UIImageView!
    
    // MARK: - further UI
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    let status = UIImageView(image: UIImage(named: "banner"))
    let label = UILabel()
    let messages = ["Connectiong ...", "Authorizing ...", "Sending credentials ...", "Failed"]
    var statusPosition = CGPoint.zero
    
    // MARK: - Lift cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up the UI
        loginBtn.layer.cornerRadius = 8.0
        loginBtn.layer.masksToBounds = true
        
        spinner.frame = CGRect(x: -20, y: 6, width: 20, height: 20)
        spinner.startAnimating()
        spinner.alpha = 0
        
        loginBtn.addSubview(spinner)
        
        status.hidden = true
        status.center = loginBtn.center
        view.addSubview(status)
        
        label.frame = CGRect(x: 0, y: 0, width: status.frame.size.width, height: status.frame.size.height)
        label.font = UIFont(name: "HelveticaNeue", size: 18)
        label.textColor = UIColor(red: 0.89, green: 0.38, blue: 0, alpha: 1)
        label.textAlignment = .Center
        status.addSubview(label)
        
        statusPosition = status.center
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        usernameField.layer.position.x -= view.bounds.width
        passwordField.layer.position.x -= view.bounds.width
        
        delay(seconds: 5.0, completion: {
            print("where are the fields?")
        })
        
        // add layer animations
        let flyRight = CABasicAnimation(keyPath: "position.x")
        flyRight.fromValue = -view.bounds.size.width/2
        flyRight.toValue = view.bounds.size.width/2
        flyRight.duration = 0.5
        flyRight.fillMode = kCAFillModeBoth
//        flyRight.removedOnCompletion = false
        
        headingLabel.layer.addAnimation(flyRight, forKey: nil)
        
        flyRight.beginTime = CACurrentMediaTime() + 0.3
        usernameField.layer.addAnimation(flyRight, forKey: nil)
        flyRight.beginTime = CACurrentMediaTime() + 0.4
        passwordField.layer.addAnimation(flyRight, forKey: nil)
        
        usernameField.layer.position.x = view.bounds.size.width/2
        passwordField.layer.position.x = view.bounds.size.width/2
        
//        cloud1.alpha = 0.0
//        cloud2.alpha = 0.0
//        cloud3.alpha = 0.0
//        cloud4.alpha = 0.0
        
        loginBtn.center.y += 30
        loginBtn.alpha = 0
        
        // present animation
        
        let fadeIn = CABasicAnimation(keyPath: "opacity")
        fadeIn.fromValue = 0
        fadeIn.toValue = 1
        fadeIn.duration = 0.5
        fadeIn.fillMode = kCAFillModeBackwards
        
        fadeIn.beginTime = CACurrentMediaTime() + 0.5
        cloud1.layer.addAnimation(fadeIn, forKey: nil)
        fadeIn.beginTime = CACurrentMediaTime() + 0.7
        cloud2.layer.addAnimation(fadeIn, forKey: nil)
        fadeIn.beginTime = CACurrentMediaTime() + 0.9
        cloud3.layer.addAnimation(fadeIn, forKey: nil)
        fadeIn.beginTime = CACurrentMediaTime() + 1.1
        cloud4.layer.addAnimation(fadeIn, forKey: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: { () -> Void in
            self.loginBtn.center.y -= 30
            self.loginBtn.alpha = 1.0
            }, completion: nil)
        
        // make the cloud animation
        animateCloud(cloud1)
        animateCloud(cloud2)
        animateCloud(cloud3)
        animateCloud(cloud4)
    }

    // MARK: - further methods
    
    @IBAction func login() {
        view.endEditing(true)
        
        // add animation
        UIView.animateWithDuration(1.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [], animations: { () -> Void in
            self.loginBtn.bounds.size.width += 80
            }, completion: { _ in
                self.showMessage(index: 0)
        })
        
        
        UIView.animateWithDuration(0.33, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: { () -> Void in
            self.loginBtn.center.y += 60
//            self.loginBtn.backgroundColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1)
            
            self.spinner.center = CGPoint(x: 40, y: self.loginBtn.frame.size.height/2)
            self.spinner.alpha = 1
            
            }, completion: nil)
        
        // add button animation
        let tintColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1)
        tintBackgroundColor(loginBtn.layer, toColor: tintColor)
        roundCornerss(loginBtn.layer, toRadius: 25)
        
    }
    
    func showMessage(index index: Int) {
        label.text = messages[index]
        
        UIView.transitionWithView(status, duration: 0.33, options: [.CurveEaseOut, .TransitionFlipFromBottom], animations: { () -> Void in
            self.status.hidden = false
            }, completion: { _ in
                // transition completion
                delay(seconds: 2) { () -> () in
                    if index < self.messages.count-1 {
                        self.removeMessage(index: index)
                    } else  {
                        // reset form
                        self.resetForm()
                    }
                }
        })
        
        
    }
    
    func removeMessage(index index: Int) {
        UIView.animateWithDuration(0.33, delay: 0, options: [], animations: { () -> Void in
            self.status.center.x += self.view.frame.size.width
            }, completion: { _ in
                self.status.hidden = true
                self.status.center = self.statusPosition
                
                self.showMessage(index: index+1)
        })
    }
    
    func resetForm() {
        UIView.transitionWithView(status, duration: 0.2, options: [.TransitionFlipFromTop], animations: { () -> Void in
            self.status.hidden = true
            self.status.center = self.statusPosition
            }, completion: nil)
        
        UIView.animateWithDuration(0.2, delay: 0, options: [], animations: { () -> Void in
            self.spinner.center = CGPoint(x: -20, y: 16)
            self.spinner.alpha = 0
//            self.loginBtn.backgroundColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1)
            self.loginBtn.bounds.size.width -= 90
            self.loginBtn.center.y -= 60
            }, completion: { _ in
                let tintColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1)
                self.tintBackgroundColor(self.loginBtn.layer, toColor: tintColor)
                self.roundCornerss(self.loginBtn.layer, toRadius: 10)
        })
        
    }
    
    func animateCloud(cloud: UIImageView) {
        let cloudSpeed = 60.0 / view.frame.size.width
        let duration = (view.frame.size.width - cloud.frame.origin.x) * cloudSpeed
        UIView.animateWithDuration(NSTimeInterval(duration), delay: 0, options: [.CurveLinear], animations: { () -> Void in
            cloud.frame.origin.x = self.view.frame.size.width
            }, completion: { _ in
                cloud.frame.origin.x = -cloud.frame.size.width
                self.animateCloud(cloud)
        })
    }
    
    func tintBackgroundColor(layer: CALayer, toColor: UIColor) {
        let tint = CABasicAnimation(keyPath: "backgroundColor")
        tint.fromValue = layer.backgroundColor
        tint.toValue = toColor.CGColor
        tint.duration = 1
        layer.addAnimation(tint, forKey: nil)
        layer.backgroundColor = toColor.CGColor
    }
    
    func roundCornerss(layer: CALayer, toRadius: CGFloat) {
        let round = CABasicAnimation(keyPath: "cornerRadius")
        round.fromValue = layer.cornerRadius
        round.toValue = toRadius
        round.duration = 0.33
        layer.addAnimation(round, forKey: nil)
        layer.cornerRadius = toRadius
    }
    
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextField = (textField === usernameField) ? passwordField : usernameField
        nextField.becomeFirstResponder()
        return true
    }
    
    


}

