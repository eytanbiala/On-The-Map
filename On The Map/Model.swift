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

    var studentLocations : Array<User>?
    var signedInUser: Dictionary<String, AnyObject>?

    func setStudentLocations(results: Array<Dictionary<String, AnyObject>>) {
        studentLocations = []
        for dictionary in results {
            studentLocations?.append(User(dictionary: dictionary))
        }
    }

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