//
//  ViewController.swift
//  On The Map
//
//  Created by Eytan Biala on 4/26/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController, UITabBarControllerDelegate, InfoPostingViewControllerDelegate {

    var mapView : MapViewController!
    var listView : ListViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarController?.delegate = self
        tabBar.translucent = false;

        mapView = MapViewController();
        listView = ListViewController();

        viewControllers = [mapView, listView]

        title = "On The Map"

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(logout))
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: #selector(refresh)),
                                              UIBarButtonItem(image: UIImage(named: "pin"), style: .Plain, target: self, action: #selector(addPin))
        ]

        loadLocations()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        for (_, item) in self.viewControllers!.enumerate() {
            item.viewWillAppear(animated)
        }
    }

    func loadLocations() {
        UdacityClient.getStudentLocations { (error, result) -> (Void) in

            if let results = result!["results"] as? NSArray {
                self.mapView.setResults(results)
                self.listView.setResults(results)
            }
        }
    }

    func logout() {
        self.view.alpha = 0.5
        UdacityClient.logout { (error, result) -> (Void) in
            self.view.alpha = 1.0
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    func addPin() {

        let story = UIStoryboard(name: "LoginViewController", bundle: NSBundle.mainBundle())
        let vc = story.instantiateViewControllerWithIdentifier("InfoPostingViewController") as! InfoPostingViewController
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)

        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func refresh() {
        loadLocations()
    }

    func didAddLocation(sender: InfoPostingViewController) {
        refresh()
    }
}
