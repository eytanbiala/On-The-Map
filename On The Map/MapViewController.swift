//
//  MapViewController.swift
//  On The Map
//
//  Created by Eytan Biala on 4/26/16.
//  Copyright © 2016 Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController : UIViewController, MKMapViewDelegate {

    var mapView: MKMapView!

    convenience init() {
        self.init(nibName:nil, bundle:nil)

        tabBarItem.title = "Map"
        tabBarItem.image = UIImage(named: "map")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MKMapView(frame: view.frame)
        mapView.delegate = self
        view.addSubview(mapView)
    }

    func reload() {
        if let locations = Model.sharedInstance.studentLocations {
            addAnnotations(locations)
        }
    }

    func addAnnotations(locations: [User]) {
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()

        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.

        for user in locations {
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = user.coordinate
            annotation.title = "\(user.first) \(user.last)"
            annotation.subtitle = user.url

            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }

        // Clear any existing annotations
        mapView.removeAnnotations(mapView.annotations)

        // Add the annotations to the map.
        mapView.addAnnotations(annotations)
    }

    // MARK: - MKMapViewDelegate

    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {

        let reuseId = "pin"

        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }

        return pinView
    }


    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
}