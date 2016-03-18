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
    let animationDuration = 1
    
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
    
    override func didMoveToWindow() {
        layer.addSublayer(photoLayer)
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

}
