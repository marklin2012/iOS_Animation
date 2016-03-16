//
//  ViewController.swift
//  O2PackingList
//
//  Created by O2.LinYi on 16/3/14.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var buttonMenu: UIButton!
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet weak var menuHeightConstraint: NSLayoutConstraint!
    
    var slider: HorizontalItemList!
    var isMenuOpen = false
    var items: [Int] = [5, 6, 7]
    
    @IBAction func actionToggleMenu(sender: AnyObject) {
        isMenuOpen = !isMenuOpen
        
        // animating the label
        for constraint in titleLabel.superview!.constraints {
            if constraint.firstItem as? NSObject == titleLabel && constraint.firstAttribute == .CenterX {
                constraint.constant = isMenuOpen ? -100 : 0
            }
            
            if constraint.identifier == "TitleCenterY" {
                constraint.active = false
                
                // add new constraint
                let newConstraint = NSLayoutConstraint(item: titleLabel, attribute: .CenterY, relatedBy: .Equal, toItem: titleLabel.superview!, attribute: .CenterY, multiplier: (isMenuOpen ? 0.67 : 1), constant: 5)
                newConstraint.identifier = "TitleCenterY"
                newConstraint.active = true
                
                
                
                continue
            }
            
        }
        
        
        
        menuHeightConstraint.constant = isMenuOpen ? 200 : 60
        titleLabel.text = isMenuOpen ? "Select Item" : "Packing List"
        
        // animate TitleView
        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10, options: [.CurveEaseIn], animations: { () -> Void in
            self.view.layoutIfNeeded()
            
            // rotate + button
            let angle = self.isMenuOpen ? CGFloat(M_PI_4) : 0
            self.buttonMenu.transform = CGAffineTransformMakeRotation(angle)
            
            }, completion: nil)
        
        for con in titleLabel.superview!.constraints  {
            print("-> \(con.description)\n")
        }
        
        // add change constraint
        if isMenuOpen {
            slider = HorizontalItemList(inView: view)
            slider.didSelectItem = { index in
                print("add \(index)")
                self.items.append(index)
                self.tableView.reloadData()
                self.actionToggleMenu(self)
                
            }
            
            self.titleLabel.superview!.addSubview(slider)
        } else {
            slider.removeFromSuperview()
        }
    }
    
    func showItem(index: Int) {
        print("tapped item \(index)")
        
        let imageView = UIImageView(image: UIImage(named: "summericons_100px_0\(index).png"))
        imageView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        // create theconstraints for the image view
        let conX = imageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor)
        let conBottom = imageView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant: imageView.frame.height)
        let conWidth = imageView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, multiplier:  0.33, constant:  -50)
        let conHeight = imageView.heightAnchor.constraintEqualToAnchor(imageView.widthAnchor)
        NSLayoutConstraint.activateConstraints([conX, conBottom, conWidth, conHeight])
        
        view.layoutIfNeeded()
        
        UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: { () -> Void in
            conBottom.constant = -imageView.frame.size.height/2
            conWidth.constant = 0
            self.view.layoutIfNeeded()
            }, completion: nil)
    }

    


}

let itemTitles = ["Icecream money", "Great weather", "Beach ball", "Swim suit for him", "Swim suit for her", "Beach games", "Ironing board", "Cocktail mood", "Sunglasses", "Flip flops"]

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - ViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 54
    }
    
    // MARK: - Table DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        cell.accessoryType = .None
        cell.textLabel?.text = itemTitles[items[indexPath.row]]
        cell.imageView?.image = UIImage(named: "summericons_100px_0\(items[indexPath.row]).png")
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        showItem(items[indexPath.row])
    }
}

