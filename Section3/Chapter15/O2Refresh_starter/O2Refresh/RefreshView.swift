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


