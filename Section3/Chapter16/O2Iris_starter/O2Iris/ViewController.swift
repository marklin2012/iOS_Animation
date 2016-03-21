//
//  ViewController.swift
//  O2Iris
//
//  Created by O2.LinYi on 16/3/18.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var meterLabel: UILabel!
    @IBOutlet weak var speakButton: UIButton!
    
    let monitor = MicMonitor()
    let assistant = Assistant()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // MARK: - button action
    @IBAction func actionStartMonitoring(sender: AnyObject) {
        
    }

    @IBAction func actionEndMonitoring(sender: AnyObject) {
        
        // speak after 1s
        delay(seconds: 1, completion: {
            self.startSpeaking()
        })
    }
    
    // MARK: - further methods
    func startSpeaking() {
        print("speak back")
    }
    
    func endSpeaking() {
        
    }

}

