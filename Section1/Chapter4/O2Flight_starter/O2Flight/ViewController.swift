//
//  ViewController.swift
//  O2Flight
//
//  Created by O2.LinYi on 16/3/11.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

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
    
    func changeFlightDataTo(data: FlightData) {
        // populate the UI with the next flight's data
        summaryLabel.text = data.summary
        flightNrLabel.text = data.flightNr
        gateNrLabel.text = data.gateNr
        departingForm.text = data.departingFrom
        arrivingTo.text = data.arrivingTo
        flightStatusLabel.text = data.flightStatus
        bgImageView.image = UIImage(named: data.weatherImageName)
        snowView.hidden = !data.showWeatherEffects
        
        delay(seconds: 3) { () -> () in
            self.changeFlightDataTo(data.isTakingOff ? parisToRome : londonToParis)
        }
        
    }


}

