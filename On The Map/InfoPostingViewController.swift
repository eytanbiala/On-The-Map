//
//  InfoPostingViewController.swift
//  On The Map
//
//  Created by Eytan Biala on 5/22/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit

protocol InfoPostingViewControllerDelegate: class {
    func didAddLocation(sender: InfoPostingViewController)
}

class InfoPostingViewController: UIViewController, UITextFieldDelegate {

    weak var delegate:InfoPostingViewControllerDelegate?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var textfield: UITextField!

    var isSettingLocation = true

    var locationText : String?
    var locationURL : String?
    var locationPlacemark : MKPlacemark?

    convenience init() {
        self.init(nibName:nil, bundle:nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(cancel))

        textfield.delegate = self

        configureTextfield()
    }

    func configureTextfield() {
        textfield.text = nil
        if isSettingLocation {
            titleLabel.text = "Where are you studying today?"
            submitButton.titleLabel?.text = "Find on the map"
            textfield.keyboardType = .Default;
        } else {
            titleLabel.text = "URL"
            submitButton.titleLabel?.text = "Submit"
            textfield.keyboardType = .URL;
        }
    }

    func cancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func submitPressed(sender: AnyObject) {
        if let text = textfield.text {
            if text.characters.count == 0 {
                textfield.becomeFirstResponder()
                return
            }

            textfield.resignFirstResponder()

            if (isSettingLocation) {
                forwardGeocode(text)
            } else {
                submitURL(text);
            }
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let text = textField.text {
            if (isSettingLocation) {
                forwardGeocode(text)
            } else {
                submitURL(text)
            }
        }

        textField.resignFirstResponder()

        return true
    }

    func forwardGeocode(text: String) {
        locationText = text
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = text

        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { (response, error) in
            guard let response = response else {
                print("Search error: \(error)")
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }

            // print(response)

            if let item = response.mapItems.first {
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.setRegion(response.boundingRegion, animated: true)
                self.mapView.addAnnotation(item.placemark)

                self.locationPlacemark = item.placemark

                self.isSettingLocation = false
                self.configureTextfield()
            }
        }
    }

    func submitURL(text: String) {
        locationURL = text
        if let mark = locationPlacemark, location = locationText, url = locationURL {
            textfield.enabled = false
            submitButton.enabled = false

            view.alpha = 0.95

            let userId = Model.sharedInstance.signedInUserId()
            let first = Model.sharedInstance.signedInUserFirstName()
            let last = Model.sharedInstance.signedInUserLastName()

            UdacityClient.addStudentLocation(userId, firstName: first, lastName: last, mapString: location, url: url, latitude: (mark.location?.coordinate.latitude)!, longitude: (mark.location?.coordinate.longitude)!, completion: { (error, result) -> (Void) in

                self.textfield.enabled = true
                self.submitButton.enabled = true

                self.view.alpha = 1.0

                guard let response = result else {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    return
                }

                
                let objectId = response["objectId"]
                print("Created location \(objectId)")
                
                self.delegate?.didAddLocation(self)
                
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
    }
}