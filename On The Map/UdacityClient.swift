//
//  UdacityClient.swift
//  On The Map
//
//  Created by Eytan Biala on 4/27/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import Foundation
import UIKit

typealias UdacityClientResult = (error: NSError?, result: Dictionary<String, AnyObject>?) -> (Void)


class UdacityClient : NSObject {

    class func jsonFromResponseData(data: NSData) -> Dictionary<String, AnyObject>? {
        do {
            let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
            return jsonObject as? Dictionary<String, AnyObject>
        } catch let jsonError as NSError {
            print(jsonError.localizedDescription)
        }

        return nil
    }

    class func udacityDataTaskWithCompletion(request: NSURLRequest, completion: UdacityClientResult?) {

        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            guard error == nil else {
                completion?(error: error, result: nil)
                return
            }

            /* subset response data! */
            let json = jsonFromResponseData(data!.subdataWithRange(NSMakeRange(5, data!.length - 5)))
            print(json)
            dispatch_async(dispatch_get_main_queue(), {
                completion?(error: error, result: json)
            })
        }
        task.resume()
    }

    class func parseDataTask(request: NSURLRequest, completion: UdacityClientResult?) {
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard error == nil else {
                completion?(error: error, result: nil)
                return
            }

            let json = jsonFromResponseData(data!)
            print(json)
            dispatch_async(dispatch_get_main_queue(), {
                completion?(error: error, result: json)
            })
        }
        task.resume()
    }

    class func login(username: String, password: String, completion: UdacityClientResult?) {

        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let bodyDict = ["udacity": ["username": "\(username)", "password": "\(password)"]]
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(bodyDict, options: NSJSONWritingOptions.init(rawValue: 0))
        } catch let jsonError as NSError {
            completion?(error: jsonError, result: nil)
            return
        }

        udacityDataTaskWithCompletion(request, completion: completion)
    }

    class func logout(completion: UdacityClientResult?) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }

        udacityDataTaskWithCompletion(request, completion: completion)
    }

    class func getUserData(userId: String, completion: UdacityClientResult?) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(userId)")!)

        udacityDataTaskWithCompletion(request, completion: completion)
    }

    class func getStudentLocations(completion: UdacityClientResult?) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?limit=100&order=updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")

        parseDataTask(request, completion: completion)
    }

    class func addStudentLocation(userId: String, firstName: String, lastName: String, mapString: String, url: String, latitude: Double, longitude: Double, completion: UdacityClientResult?) {

        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let bodyDict = ["uniqueKey": "\(userId)",
                        "firstName": "\(firstName)",
                        "lastName": "\(lastName)",
                        "mapString": "\(mapString)",
                        "mediaURL": "\(url)",
                        "latitude": latitude,
                        "longitude": longitude
        ]
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(bodyDict, options: NSJSONWritingOptions.init(rawValue: 0))
        } catch let jsonError as NSError {
            completion?(error: jsonError, result: nil)
            return
        }
        
        parseDataTask(request, completion: completion)
    }
}