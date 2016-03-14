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
    
    var slider: HorizontalItemList!
    var isMenuOpen = false
    var items: [Int] = [5, 6, 7]
    
    @IBAction func actionToggleMenu(sender: AnyObject) {
        
    }
    
    func showItem(index: Int) {
        print("tapped item \(index)")
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

