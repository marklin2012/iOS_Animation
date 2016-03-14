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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // set first position to move out the screen
        headingLabel.center.x -= view.bounds.width
        usernameField.center.x -= view.bounds.width
        passwordField.center.x -= view.bounds.width
        
        cloud1.alpha = 0.0
        cloud2.alpha = 0.0
        cloud3.alpha = 0.0
        cloud4.alpha = 0.0
        
        loginBtn.center.y += 30
        loginBtn.alpha = 0
        
        // present animation
        UIView.animateWithDuration(0.5) { () -> Void in
            self.headingLabel.center.x += self.view.bounds.width
//            usernameField.center.x += view.bounds.width
        }
        
        UIView.animateWithDuration(0.5, delay: 0.3, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: { () -> Void in
            self.usernameField.center.x += self.view.bounds.width
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.4, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [.CurveEaseInOut
            ], animations: { () -> Void in
                self.passwordField.center.x += self.view.bounds.width
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.5, options: [], animations: { () -> Void in
            self.cloud1.alpha = 1
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.7, options: [], animations: { () -> Void in
            self.cloud2.alpha = 1
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.9, options: [], animations: { () -> Void in
            self.cloud3.alpha = 1
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 1.1, options: [], animations: { () -> Void in
            self.cloud4.alpha = 1
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: { () -> Void in
            self.loginBtn.center.y -= 30
            self.loginBtn.alpha = 1.0
            }, completion: nil)
        
        
    }

    // MARK: - further methods
    
    @IBAction func login() {
        view.endEditing(true)
        
        // add animation
        UIView.animateWithDuration(1.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [], animations: { () -> Void in
            self.loginBtn.bounds.size.width += 80
            }, completion: nil)
        UIView.animateWithDuration(0.33, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: { () -> Void in
            self.loginBtn.center.y += 60
            self.loginBtn.backgroundColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1)
            
            self.spinner.center = CGPoint(x: 40, y: self.loginBtn.frame.size.height/2)
            self.spinner.alpha = 1
            
            }, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextField = (textField === usernameField) ? passwordField : usernameField
        nextField.becomeFirstResponder()
        return true
    }
    
    


}

