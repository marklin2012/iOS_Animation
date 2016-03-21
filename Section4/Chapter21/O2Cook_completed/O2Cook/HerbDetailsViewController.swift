//
//  HerbDetailsViewController.swift
//  O2Cook
//
//  Created by O2.LinYi on 16/3/21.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

class HerbDetailsViewController: UIViewController {
    
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var bgImage: UIImageView!
    @IBOutlet var titleView: UILabel!
    @IBOutlet var descrioptionView: UITextView!
    @IBOutlet var licenseButton: UIButton!
    @IBOutlet var authorButton: UIButton!
    
    var herb: HerbModel!
    
    // MARK: - Life Cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        bgImage.image = UIImage(named: herb.image)
        titleView.text = herb.name
        descrioptionView.text = herb.description
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "actionClose:"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - further methods
    func actionClose(tap: UITapGestureRecognizer) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - button actions
    @IBAction func actionLicense(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: herb!.license)!)
    }
    
    @IBAction func actionAuthor(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: herb!.credit)!)
    }

}
