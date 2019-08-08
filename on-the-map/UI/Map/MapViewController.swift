//
//  MapViewController.swift
//  on-the-map
//
//  Created by Jerry Hanks on 03/08/2019.
//  Copyright © 2019 Jerry. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    private var locations:[Location]{
        get{return (UIApplication.shared.delegate as! AppDelegate).locations}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoutBtnItem = UIBarButtonItem(title: "LOGOUT", style: .done, target: self, action: #selector(logout(_:)))
        self.navigationItem.leftBarButtonItems = [logoutBtnItem]
        
        let refreshBtnItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh(_:)))
        let addBtnItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem(_:)))
        
        self.navigationItem.rightBarButtonItems  = [addBtnItem,refreshBtnItem]
        
        //load map locations here and drop pins
         self.mapView.delegate = self
        
        
        //add observers
        NotificationCenter.default.addObserver(self, selector: #selector(doneLoadingData(_:)), name: .doneLoading, object: nil)
        
    }
    
    @objc
    private func doneLoadingData(_ notification:Notification){
        addAnnotions()
    }
    
    
    
   /// Add Annotations to the map
   private func addAnnotions() {
        mapView.removeAnnotations(mapView.annotations)
        
        var annotations = [MKPointAnnotation]()
        
        for location in locations {
            let lat = CLLocationDegrees(location.latitude)
            let long = CLLocationDegrees(location.longitude)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            annotation.title = "\(String(describing: location.firstName!)) \(String(describing: location.lastName!))"
            annotation.subtitle = location.mediaURL
            
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
        
        //make the annotations visible with animation
        self.mapView.showAnnotations(annotations, animated: true)
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //refres maps pins
        addAnnotions()
    }
    
    @IBAction
    private func logout(_ sender:AnyObject){
        NotificationCenter.default.post(name: .logout, object: nil)
    }
    
    @objc
    private func refresh(_ sender:UIBarButtonItem){
        NotificationCenter.default.post(name: .refresh, object: nil)
    }
    
    @objc
    private func addItem(_ sender:UIBarButtonItem){
        PostLocationViewController.launch(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.title = ""
    }


}

extension MapViewController : MKMapViewDelegate{
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
    
    //open location link when the pin annotation is clicked.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView{
            if let substitle = view.annotation?.subtitle, let url = URL(string:substitle!) {
                UIApplication.shared.openURL(url)
            }else{
                self.showError("Unable to open url")
            }

        }
    }
}
