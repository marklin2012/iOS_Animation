//
//  ViewController.swift
//  O2Reveal
//
//  Created by O2.LinYi on 16/3/18.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var sliderView: AnimatedMaskLabel!
    @IBOutlet var time: UILabel!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func didSlide() {
        // reveal the meme upon successful slide
        let image = UIImageView(image: UIImage(named: "meme"))
        image.center = view.center
        image.center.x += view.bounds.size.width
        view.addSubview(image)
        
        UIView.animateWithDuration(0.33, delay: 0, options: [], animations: { () -> Void in
            self.time.center.y -= 200
            self.sliderView.center.y += 200
            image.center.x -= self.view.bounds.size.width
            }, completion: nil)
        
        UIView.animateWithDuration(0.33, delay: 1, options: [], animations: { () -> Void in
            self.time.center.y += 200
            self.sliderView.center.y -= 200
            image.center.x += self.view.bounds.size.width
            }, completion: { _ in
                image.removeFromSuperview()
        })
    }


}

