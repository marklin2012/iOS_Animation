//
//  AnimatedMaskLabel.swift
//  O2Reveal
//
//  Created by O2.LinYi on 16/3/18.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable
class AnimatedMaskLabel: UIView {

    let gradientLayer: CAGradientLayer = {
       let gradientLayer = CAGradientLayer()
        
        // Configure the gradient here
        return gradientLayer
    }()
    
    @IBInspectable var text: String! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func layoutSubviews() {
        layer.borderColor = UIColor.greenColor().CGColor
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
    }

}
