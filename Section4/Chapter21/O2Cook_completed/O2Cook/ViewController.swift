//
//  ViewController.swift
//  O2Cook
//
//  Created by O2.LinYi on 16/3/21.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

let herbs = HerbModel.all()

class ViewController: UIViewController {
    
    @IBOutlet var listView: UIScrollView!
    @IBOutlet var bgImage: UIImageView!
    
    var selectedImage: UIImageView?
    
    let transition = PopAnimator()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if listView.subviews.count < herbs.count {
            listView.viewWithTag(0)?.tag = 1000 // prevent confusion when looking up images
            setupList()
        }
        
        transition.dismissCompletion = {
            self.selectedImage!.hidden = false
        }
    }
    
    

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - view setup
    // add all images to the list
    func setupList() {
        for var i=0; i < herbs.count; i++ {
            // create image view
            let imageView = UIImageView(image: UIImage(named: herbs[i].image))
            imageView.tag = i + 100
            imageView.contentMode = .ScaleAspectFill
            imageView.userInteractionEnabled = true
            imageView.layer.cornerRadius = 20
            imageView.layer.masksToBounds = true
            listView.addSubview(imageView)
            
            // attach tap detector
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "didTapImageView:"))
        }
        
        listView.backgroundColor = UIColor.clearColor()
        positionListItems()
    }
    
    // position all images inside the list
    func positionListItems() {
        let itemHeight: CGFloat = listView.frame.height * 1.33
        let aspectRatio  = UIScreen.mainScreen().bounds.height / UIScreen.mainScreen().bounds.width
        let itemWidth: CGFloat = itemHeight / aspectRatio
        
        print("width: \(itemWidth)")
        
        let horizontalPadding: CGFloat = 10.0
        
        for var i = 0; i < herbs.count; i++ {
            let imageView = listView.viewWithTag(i+100) as! UIImageView
            imageView.frame = CGRect(x: CGFloat(i+1) * horizontalPadding + CGFloat(i) * itemWidth, y: 0, width: itemWidth, height: itemHeight)
            print("frame: \(imageView.frame)")
        }
        
        listView.contentSize = CGSize(width: CGFloat(herbs.count) * (itemWidth+horizontalPadding) + horizontalPadding, height: 0)
    }
    
    func didTapImageView(tap: UITapGestureRecognizer) {
        selectedImage = tap.view as? UIImageView
        
        let index = tap.view!.tag - 100
        let selectedHerb = herbs[index]
        
        //present details view controller
        let herbDetails = storyboard!.instantiateViewControllerWithIdentifier("HerbDetailsViewController") as! HerbDetailsViewController
        herbDetails.herb = selectedHerb
        herbDetails.transitioningDelegate = self
        presentViewController(herbDetails, animated: true, completion: nil)
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        coordinator.animateAlongsideTransition({ (context) -> Void in
            self.bgImage.alpha = (size.width > size.height) ? 0.25 : 0.55
            self.positionListItems()
            }, completion: nil)
    }


}

extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.originFrame = selectedImage!.superview!.convertRect(selectedImage!.frame, toView: nil)
        transition.presenting = true
        selectedImage!.hidden = true
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
    
    
}

