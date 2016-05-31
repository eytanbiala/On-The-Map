//
//  ListViewController.swift
//  On The Map
//
//  Created by Eytan Biala on 4/26/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import Foundation
import UIKit

struct User {
    let first: String
    let last: String
    let url: String
    let location: String

    init(dictionary: Dictionary<String, AnyObject>) {
        first = dictionary["firstName"] as! String
        last = dictionary["lastName"] as! String
        url = dictionary["mediaURL"] as! String
        location = dictionary["mapString"] as! String
    }

    func full() -> String {
        return "\(first) \(last)"
    }
}

class ListViewController : UITableViewController {

    var contents : [User]!

    let reuseId = "cell"

    convenience init() {
        self.init(nibName:nil, bundle:nil)

        tabBarItem.title = "List"
        tabBarItem.image = UIImage(named: "list")

        contents = []

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        tableView.rowHeight = 56

        clearsSelectionOnViewWillAppear = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "List"
    }

    func setResults(results: NSArray) {

        contents.removeAll()

        for dictionary in results {
            contents.append(User(dictionary: dictionary as! Dictionary<String, AnyObject>))
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {


        let user = contents[indexPath.row]

        let cell = tableView.dequeueReusableCellWithIdentifier(reuseId, forIndexPath: indexPath)

        cell.textLabel?.text = user.full()
        cell.detailTextLabel?.text = user.url
        cell.imageView?.image = UIImage(named: "pin")

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let user = contents[indexPath.row]
        var urlStr = user.url
        if !urlStr.lowercaseString.hasPrefix("http") {
            urlStr = "http://" + urlStr
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        UIApplication.sharedApplication().openURL(NSURL(string: urlStr)!)
    }
}