//
//  HorizontalItemList.swift
//  O2PackingList
//
//  Created by O2.LinYi on 16/3/14.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

class HorizontalItemList: UIScrollView {

    var didSelectItem: ((index: Int)->())?
    
    let buttonWidth: CGFloat = 60.0
    let padding: CGFloat = 10.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(inView: UIView) {
        let rect = CGRect(x: inView.bounds.width, y: 120, width: inView.frame.width, height: 80)
        self.init(frame: rect)
        
        self.alpha = 0
        for (var i = 0; i < 10; i++) {
            let image = UIImage(named: "summericons_100px_0\(i)")
            let imageView = UIImageView(image: image)
            imageView.center = CGPoint(x: CGFloat(i) * buttonWidth + buttonWidth/2, y: buttonWidth/2)
            imageView.tag = i
            imageView.userInteractionEnabled = true
            addSubview(imageView)
            
            let tap = UITapGestureRecognizer(target: self, action: "didTapImage:")
            imageView.addGestureRecognizer(tap)
        }
        
        contentSize = CGSize(width: padding * buttonWidth, height: buttonWidth + 2*padding)
    }
    
    func didTapImage(tap:UITapGestureRecognizer) {
        didSelectItem!(index: tap.view!.tag)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if superview == nil {
            return
        }
        
        UIView.animateWithDuration(1, delay: 0.01, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: [.CurveEaseIn], animations: { () -> Void in
            self.alpha = 1
            self.center.x -= self.frame.size.width
            }, completion: nil)
    }
    
    

}
