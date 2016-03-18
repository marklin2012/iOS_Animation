//
//  AvatarView.swift
//  O2Multiplayer
//
//  Created by O2.LinYi on 16/3/17.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable
class AvatarView: UIView {

    // constants
    let lineWidth: CGFloat = 6
    let animationDuration = 1.0
    
    // ui
    let photoLayer = CALayer()
    let circleLayer = CAShapeLayer()
    let maskLayer = CAShapeLayer()
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ArialRoundedMTBold", size: 18)
        label.textAlignment = .Center
        label.textColor = UIColor.blackColor()
        return label
    }()
    
    
    
    // variables
    @IBInspectable
    var image: UIImage! {
        didSet {
            photoLayer.contents = image.CGImage
        }
    }
    
    @IBInspectable
    var name: String? {
        didSet {
            label.text = name
        }
    }
    
    var shouldTransitionToFinishedState = false
    var isSquare: Bool = false
    
    override func didMoveToWindow() {
        layer.addSublayer(photoLayer)
        photoLayer.mask = maskLayer
        layer.addSublayer(circleLayer)
        addSubview(label)
    }
    
    override func layoutSubviews() {
        // size the avatar image to fit
        photoLayer.frame = CGRect(
            x: (bounds.size.width - image.size.width + lineWidth)/2,
            y: (bounds.size.height - image.size.height - lineWidth)/2,
            width: image.size.width,
            height: image.size.height)
        // Draw the circle
        circleLayer.path = UIBezierPath(ovalInRect: bounds).CGPath
        circleLayer.strokeColor = UIColor.whiteColor().CGColor
        circleLayer.lineWidth = lineWidth
        circleLayer.fillColor = UIColor.clearColor().CGColor
        
        // Size the layer
        maskLayer.path = circleLayer.path
        maskLayer.position = CGPoint(x: 0, y: 10)
        
        // Size the label
        label.frame = CGRect(x: 0, y: bounds.size.height + 10, width: bounds.size.width, height: 24)
    }
    
    // MARK: - further methods
    func bounceOffPoint(bouncePoint: CGPoint, morphSize: CGSize) {
        let originalCenter = center
        
        UIView.animateWithDuration(animationDuration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: { () -> Void in
            self.center = bouncePoint
            }, completion: { _ in
                // complete bounce to
                if self.shouldTransitionToFinishedState {
                    self.animateToSquare()
                }
                
        })
        
        UIView.animateWithDuration(animationDuration, delay: animationDuration, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: [], animations: { () -> Void in
            self.center = originalCenter
            }, completion: { _ in
                delay(seconds: 0.1, completion: { () -> () in
                    if !self.isSquare {
                       self.bounceOffPoint(bouncePoint, morphSize: morphSize)
                    }
                    
                })
        })
        
        
        // animation effect 
        let morphedFrame = (originalCenter.x > bouncePoint.x) ?
            CGRect(
            x: 0,
            y: bounds.height - morphSize.height,
            width: morphSize.width,
            height: morphSize.height) :
            CGRect(
                x: bounds.width - morphSize.width,
                y: bounds.height - morphSize.height,
                width: morphSize.width,
                height: morphSize.height)
        
        let morphAnimation = CABasicAnimation(keyPath: "path")
        morphAnimation.duration = animationDuration
        morphAnimation.toValue = UIBezierPath(ovalInRect: morphedFrame).CGPath
        morphAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        circleLayer.addAnimation(morphAnimation, forKey: nil)
        maskLayer.addAnimation(morphAnimation, forKey: nil)
    }

    func animateToSquare() {
        isSquare = true
        let squarePath = UIBezierPath(rect: bounds).CGPath
        
        let anim = CABasicAnimation(keyPath: nil)
        anim.duration = 0.25
        anim.fromValue = circleLayer.path
        anim.toValue = squarePath
        
        circleLayer.addAnimation(anim, forKey: nil)
        circleLayer.path = squarePath
        maskLayer.addAnimation(anim, forKey: nil)
        maskLayer.path = squarePath
        
    }
}
