//
//  ListViewController.swift
//  On The Map
//
//  Created by Eytan Biala on 4/26/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import Foundation
import UIKit

class ListViewController : UITableViewController {

    let reuseId = "cell"

    convenience init() {
        self.init(nibName:nil, bundle:nil)

        tabBarItem.title = "List"
        tabBarItem.image = UIImage(named: "list")

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        tableView.rowHeight = 56

        clearsSelectionOnViewWillAppear = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "List"
    }

    func reload() {
        tableView.reloadData()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let locations = Model.sharedInstance.studentLocations {
            return locations.count
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier(reuseId, forIndexPath: indexPath)

        if let user = Model.sharedInstance.studentLocations?[indexPath.row] {
            cell.textLabel?.text = user.full()
            cell.detailTextLabel?.text = user.url
            cell.imageView?.image = UIImage(named: "pin")
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let user = Model.sharedInstance.studentLocations?[indexPath.row] {
            var urlStr = user.url
            if !urlStr.lowercaseString.hasPrefix("http") {
                urlStr = "http://" + urlStr
            }
            
            UIApplication.sharedApplication().openURL(NSURL(string: urlStr)!)
        }

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}