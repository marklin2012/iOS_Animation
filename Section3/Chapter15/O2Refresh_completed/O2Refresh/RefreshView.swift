//
//  RefreshView.swift
//  O2Refresh
//
//  Created by O2.LinYi on 16/3/18.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit
import QuartzCore

// MARK: - Refresh View Delegate Protocol
protocol RefreshViewDelegate {
    func refreshViewDidRefresh(refreshView: RefreshView)
}

class RefreshView: UIView {

    var delegate: RefreshViewDelegate?
    var scrollView: UIScrollView?
    var refreshing: Bool = false
    var progress: CGFloat = 0
    
    var isRefreshing = false
    
    let ovalShapeLayer: CAShapeLayer = CAShapeLayer()
    let airplaneLayer: CALayer = CALayer()
    
    init(frame: CGRect, scrollView: UIScrollView) {
        super.init(frame: frame)
        
        self.scrollView = scrollView
        
        // add the background image
        let imageView = UIImageView(image: UIImage(named: "refresh-view-bg"))
        imageView.frame = bounds
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
        
        ovalShapeLayer.strokeColor = UIColor.whiteColor().CGColor
        ovalShapeLayer.fillColor = UIColor.clearColor().CGColor
        ovalShapeLayer.lineWidth = 4
        ovalShapeLayer.lineDashPattern = [2,3]
        let refreshRadius = frame.size.height / 2 * 0.8
        ovalShapeLayer.path = UIBezierPath(ovalInRect: CGRect(x: frame.size.width/2 - refreshRadius, y: frame.size.height/2 - refreshRadius, width: 2 * refreshRadius, height: 2 * refreshRadius)).CGPath
        
        layer.addSublayer(ovalShapeLayer)
        
        let airplaneImage = UIImage(named: "icon-plane")!
        airplaneLayer.contents = airplaneImage.CGImage
        airplaneLayer.bounds = CGRect(x: 0, y: 0, width: airplaneImage.size.width, height: airplaneImage.size.height)
        airplaneLayer.position = CGPoint(x: frame.size.width/2 + frame.size.height/2 * 0.8, y: frame.size.height/2)
        
        layer.addSublayer(airplaneLayer)
        
        airplaneLayer.opacity = 0
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - animate the refresh view
    func beginRefreshing() {
        isRefreshing = true
        
        UIView.animateWithDuration(0.3, animations: {
            var newInsets = self.scrollView!.contentInset
            newInsets.top += self.frame.size.height
            self.scrollView?.contentInset = newInsets
        })
        
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = -0.5
        strokeStartAnimation.toValue = 1
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1
        
        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration = 1.5
        strokeAnimationGroup.repeatCount = 5
        strokeAnimationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
        ovalShapeLayer.addAnimation(strokeAnimationGroup, forKey: nil)
        
        // add plane animation
        let flightAnimation = CAKeyframeAnimation(keyPath: "position")
        flightAnimation.path = ovalShapeLayer.path
        flightAnimation.calculationMode = kCAAnimationPaced
        
        let airplaneOrientationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        airplaneOrientationAnimation.fromValue = 0
        airplaneOrientationAnimation.toValue = 2 * M_PI
        
        let flightAnimationGroup = CAAnimationGroup()
        flightAnimationGroup.duration = 1.5
        flightAnimationGroup.repeatDuration = 5
        flightAnimationGroup.animations = [flightAnimation, airplaneOrientationAnimation]
        
        airplaneLayer.addAnimation(flightAnimationGroup, forKey: nil)
    }
    
    func endRefreshing() {
        isRefreshing = false
        
        UIView.animateWithDuration(0.3, delay: 0, options: [.CurveEaseOut], animations: { () -> Void in
            var newInsets = self.scrollView!.contentInset
            newInsets.top -= self.frame.size.height
            self.scrollView!.contentInset = newInsets
            }, completion: { _ in
                // finished
        })
    }
    
    func redrawFromProgress(progress: CGFloat) {
        ovalShapeLayer.strokeEnd = progress
        airplaneLayer.opacity = Float(progress)
    }

}

extension RefreshView: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetY = CGFloat(max(-(scrollView.contentOffset.y + scrollView.contentInset.top), 0))
        progress = min(max(offsetY / frame.size.height, 0.0), 1.0)
        
        if !isRefreshing {
            redrawFromProgress(self.progress)
        }
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if !isRefreshing && progress >= 1.0 {
            delegate?.refreshViewDidRefresh(self)
            
            beginRefreshing()
        }
    }
}


