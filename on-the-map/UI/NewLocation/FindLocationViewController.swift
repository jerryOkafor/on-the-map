//
//  FindLocationViewController.swift
//  on-the-map
//
//  Created by Jerry Hanks on 05/08/2019.
//  Copyright © 2019 Jerry. All rights reserved.
//

import UIKit
import MapKit

class FindLocationViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    var location:CLLocation!
    var placeMark:CLPlacemark!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         self.navigationItem.title = "Add Location"
        
        self.mapView.delegate = self
        
        //add location to the map view
        if let prevAnnotation = self.mapView?.annotations{
            self.mapView.removeAnnotations(prevAnnotation)
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title  = placeMark.name
        
        self.mapView.addAnnotations([annotation])
        
        //set the map region
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placeMark.location!.coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
        
    }
    

    @IBAction func onTapFinishBtn(_ sender: Any) {
        
    }
    
    class func launch(_ caller:UIViewController,location:CLLocation,placeMark:CLPlacemark){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: FindLocationViewController.self)) as! FindLocationViewController
        vc.location = location
        vc.placeMark = placeMark
        
        vc.hidesBottomBarWhenPushed = true
        caller.navigationController?.pushViewController(vc, animated: true)
    }

}


extension FindLocationViewController: MKMapViewDelegate{
    
    // Get view for map pins
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pin = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pin!.canShowCallout = true
            pin!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pin!.annotation = annotation
        }
        
        return pin
    }

}
