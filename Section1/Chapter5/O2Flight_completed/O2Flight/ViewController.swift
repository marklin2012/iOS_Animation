//
//  ViewController.swift
//  O2Flight
//
//  Created by O2.LinYi on 16/3/11.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

enum AnimationDirection: Int {
    case Positive = 1
    case Negative = -1
}

func delay(seconds seconds: Double, completion:()->()) {
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
    
    dispatch_after(popTime, dispatch_get_main_queue()) {
        completion()
    }
}



class ViewController: UIViewController {

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var summaryIcon: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var flightNrLabel: UILabel!
    @IBOutlet weak var gateNrLabel: UILabel!
    @IBOutlet weak var departingForm: UILabel!
    @IBOutlet weak var arrivingTo: UILabel!
    @IBOutlet weak var planeImageView: UIImageView!
    @IBOutlet weak var flightStatusLabel: UILabel!
    @IBOutlet weak var statusBanner: UIImageView!
    
    var snowView: SnowView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // adjust ui
        summaryLabel.addSubview(summaryIcon)
        summaryIcon.center.y = summaryLabel.frame.size.height/2
        
        // add the snow effect layer
        snowView = SnowView(frame: CGRect(x: -150, y: -100, width: 300, height: 50))
        let snowClipView = UIView(frame: CGRectOffset(view.frame, 0, 50))
        snowClipView.clipsToBounds = true
        snowClipView.addSubview(snowView)
        view.addSubview(snowClipView)
        
        // start rotating the flights
        changeFlightDataTo(londonToParis)
        
        
    }
    
    func changeFlightDataTo(data: FlightData, animated: Bool = false) {
        // populate the UI with the next flight's data
        summaryLabel.text = data.summary
        
        departingForm.text = data.departingFrom
        arrivingTo.text = data.arrivingTo
        
        if animated {
            fadeImageView(bgImageView, toImage: UIImage(named: data.weatherImageName)!, showEffects: data.showWeatherEffects)
            let direction : AnimationDirection = data.isTakingOff ? .Positive : .Negative
            
            cubeTransition(label: flightNrLabel, text: data.flightNr, direction: direction)
            cubeTransition(label: gateNrLabel, text: data.gateNr, direction: direction)
            
            let offsetDeparting = CGPoint(x: CGFloat(direction.rawValue * 80), y: 0)
            moveLabel(departingForm, text: data.departingFrom, offset: offsetDeparting)
            
            let offsetArriving = CGPoint(x: 0, y: CGFloat(direction.rawValue * 50))
            moveLabel(arrivingTo, text: data.arrivingTo, offset: offsetArriving)
            
            cubeTransition(label: flightStatusLabel, text: data.flightStatus, direction: direction)
            
            planeDepart()
            
        } else {
            bgImageView.image = UIImage(named: data.weatherImageName)
            snowView.hidden = !data.showWeatherEffects
            
            flightNrLabel.text = data.flightNr
            gateNrLabel.text = data.gateNr
            
            flightStatusLabel.text = data.flightStatus
        }
        
        
        delay(seconds: 3) { () -> () in
            self.changeFlightDataTo(data.isTakingOff ? parisToRome : londonToParis, animated: true)
        }
        
    }
    
    // MARK: - further method
    func fadeImageView(imageView: UIImageView, toImage: UIImage, showEffects: Bool) {
        UIView.transitionWithView(imageView, duration: 1, options: .TransitionCrossDissolve, animations: { () -> Void in
            imageView.image = toImage
            }, completion: nil)
        UIView.animateWithDuration(1, delay: 0, options: [.CurveEaseOut], animations: { () -> Void in
            self.snowView.alpha = showEffects ? 1 : 0
            }, completion: nil)
    }
    
    func cubeTransition(label label: UILabel, text: String, direction: AnimationDirection) {
        let auxLabel = UILabel(frame: label.frame)
        auxLabel.text = text
        auxLabel.font = label.font
        auxLabel.textAlignment = label.textAlignment
        auxLabel.textColor = label.textColor
        auxLabel.backgroundColor = label.backgroundColor
        
        let auxLabelOffset = CGFloat(direction.rawValue) * label.frame.size.height/2.0
        
        auxLabel.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1, 0.1), CGAffineTransformMakeTranslation(0, auxLabelOffset))
        
        label.superview?.addSubview(auxLabel)
        
        UIView.animateWithDuration(0.5, delay: 0, options: [.CurveEaseOut], animations: { () -> Void in
            auxLabel.transform = CGAffineTransformIdentity
            label.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1, 0.1), CGAffineTransformMakeTranslation(0, -auxLabelOffset))
            }, completion: { _ in
                label.text = auxLabel.text
                label.transform = CGAffineTransformIdentity
                auxLabel.removeFromSuperview()
        })
    }
    
    func moveLabel(label: UILabel, text: String, offset: CGPoint) {
        let auxLabel = UILabel(frame: label.frame)
        auxLabel.text = text
        auxLabel.font = label.font
        auxLabel.textAlignment = label.textAlignment
        auxLabel.textColor = label.textColor
        auxLabel.backgroundColor = UIColor.clearColor()
        
        auxLabel.transform = CGAffineTransformMakeTranslation(offset.x, offset.y)
        auxLabel.alpha = 0
        view.addSubview(auxLabel)
        
        UIView.animateWithDuration(0.5, delay: 0, options: [.CurveEaseIn], animations: { () -> Void in
            label.transform = CGAffineTransformMakeTranslation(offset.x, offset.y)
            label.alpha = 0
            }, completion: nil)
        
        UIView.animateWithDuration(0.25, delay: 0.1, options: [.CurveEaseIn], animations: { () -> Void in
            auxLabel.transform = CGAffineTransformIdentity
            auxLabel.alpha = 1
            }, completion: { _ in
                // clean up
                auxLabel.removeFromSuperview()
                
                label.text = text
                label.alpha = 1
                label.transform = CGAffineTransformIdentity
        })
    }
    
    func planeDepart() {
        let originalCenter = planeImageView.center
        
        UIView.animateKeyframesWithDuration(1.5, delay: 0, options: [], animations: { () -> Void in
            // add keyframe
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.25, animations: { () -> Void in
                self.planeImageView.center.x += 80
                self.planeImageView.center.y -= 10
            })
            
            UIView.addKeyframeWithRelativeStartTime(0.1, relativeDuration: 0.4, animations: { () -> Void in
                self.planeImageView.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_4/2))
            })
            
            UIView.addKeyframeWithRelativeStartTime(0.25, relativeDuration: 0.25, animations: { () -> Void in
                self.planeImageView.center.x += 100
                self.planeImageView.center.y -= 50
                self.planeImageView.alpha = 0
            })
            
            UIView.addKeyframeWithRelativeStartTime(0.51, relativeDuration: 0.01, animations: { () -> Void in
                self.planeImageView.transform = CGAffineTransformIdentity
                self.planeImageView.center = CGPoint(x: 0, y: originalCenter.y)
            })
            
            UIView.addKeyframeWithRelativeStartTime(0.55, relativeDuration: 0.45, animations: { () -> Void in
                self.planeImageView.alpha = 1
                self.planeImageView.center = originalCenter
            })
            
            }, completion: nil)
    }
    


}

