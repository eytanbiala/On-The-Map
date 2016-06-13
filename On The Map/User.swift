//
//  User.swift
//  On The Map
//
//  Created by Eytan Biala on 6/13/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import Foundation
import MapKit

struct User {
    let first: String
    let last: String
    let url: String
    let location: String
    let coordinate: CLLocationCoordinate2D

    init(dictionary: Dictionary<String, AnyObject>) {
        first = dictionary["firstName"] as! String
        last = dictionary["lastName"] as! String
        url = dictionary["mediaURL"] as! String
        location = dictionary["mapString"] as! String
        if let latitude = dictionary["latitude"] as? Double, longitude = dictionary["longitude"] as? Double {
            coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            coordinate = kCLLocationCoordinate2DInvalid
        }
    }

    func full() -> String {
        return "\(first) \(last)"
    }
}