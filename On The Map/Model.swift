//
//  Model.swift
//  On The Map
//
//  Created by Eytan Biala on 5/30/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import Foundation

class Model {
    static let sharedInstance = Model()

    var studentLocations : Array<Dictionary<String, AnyObject>>?
    var signedInUser: Dictionary<String, AnyObject>?

    func signedInUserId() -> String {
        return signedInUser?["user"]!["key"] as! String
    }

    func signedInUserFirstName() -> String {
        return signedInUser?["user"]!["first_name"] as! String
    }

    func signedInUserLastName() -> String {
        return signedInUser?["user"]!["last_name"] as! String
    }
}